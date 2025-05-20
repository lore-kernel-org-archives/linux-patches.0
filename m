Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F5524729E;
	Tue, 20 May 2025 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750403; cv=none; b=Mml/fLh5ElXCvUSfIJnInK6m8rqTLUAaDwIrYnTc77ztj+zFWkO+bH4x5ZmtVSfbefTNJYzymZCmbYGLfAaKbyyoH8XVK6CaO/Eik0HKswx8ARKFbGsAuFrtgIu31KK2NKbclv4asPIlfOfeGJvyhwu2LpbrczpNXZscOxNsZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750403; c=relaxed/simple;
	bh=kS38ErVfUuU1X6WfxhEG34KsDu8IJ46AArxm1LWvSfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GzdCSeJBaLypfFbs+OlKTBPX9FhyqD7uqC3rODGrRuA7xtqlBRG3Lte6RSR0Ujtu/NC7EZkzxiLFskiZifMTJhv0o3MpJW46frFKyYKhaWjQfMqGxM1AdBbWn4sQ90BI5AlQ4EjGavympz2WZN/9Xiuaab3p8UsyCHg6SgYApX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQl5Qvsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQl5Qvsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2783C4CEE9;
	Tue, 20 May 2025 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750403;
	bh=kS38ErVfUuU1X6WfxhEG34KsDu8IJ46AArxm1LWvSfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQl5QvsiXGmytn7FJPPnhwFN7fueSWIbLTzSbo/ZSPlSHl9TEUzqw5tF3ZLyTNCSr
	 m8WA66xwOX0+z6MkcfhMjRRxVDsCgkcfDj/XELBPkuSXSBKCc77WsLRuIp2Cl47l4x
	 XMd7FYA/szx64g4yDhUa+byjJ8yFCQoz/cY6eik8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 111/143] smb: client: fix memory leak during error handling for POSIX mkdir
Date: Tue, 20 May 2025 15:51:06 +0200
Message-ID: <20250520125814.405102389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jethro Donaldson <devel@jro.nz>

commit 1fe4a44b7fa3955bcb7b4067c07b778fe90d8ee7 upstream.

The response buffer for the CREATE request handled by smb311_posix_mkdir()
is leaked on the error path (goto err_free_rsp_buf) because the structure
pointer *rsp passed to free_rsp_buf() is not assigned until *after* the
error condition is checked.

As *rsp is initialised to NULL, free_rsp_buf() becomes a no-op and the leak
is instead reported by __kmem_cache_shutdown() upon subsequent rmmod of
cifs.ko if (and only if) the error path has been hit.

Pass rsp_iov.iov_base to free_rsp_buf() instead, similar to the code in
other functions in smb2pdu.c for which *rsp is assigned late.

Cc: stable@vger.kernel.org
Signed-off-by: Jethro Donaldson <devel@jro.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2985,7 +2985,7 @@ replay_again:
 	/* Eventually save off posix specific response info and timestamps */
 
 err_free_rsp_buf:
-	free_rsp_buf(resp_buftype, rsp);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);


