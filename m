Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B953242D98;
	Tue, 20 May 2025 14:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750857; cv=none; b=KiG6BesLI9cBPizddw31whPvZ+XkEkpslqe01OgRJaCzTlGI8uqC+yAGHrbFec6KfMw0pZgE9FiL7oIcmCFJn3K4TksTUm0V64Ukykon4Fc7Tl2k6+26pMfAWrgHhqNPxu6iwyJ4aJVbo+n3uGuyZbGDVt/6j1NCHJQqZKubkM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750857; c=relaxed/simple;
	bh=h1eJ8Y3896EsGx9xKr3hiut7Q2XNGG3A2yQggg5arlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXuVf9SYWzK6Dmayc08JM5m0FjIeRDTowo7Y2PEnkQF90Xj28h1DFMDUVGw9YZHEJRJ3v+mXOCyRMpehfrBuWDABZubHTdrYmBfCRcb9U8+kwrtkpnMpPgzNopq5+/QW/u1MX/cLeFeTzp2/J36/BHEwu4zj/ApIcc+KMxsv0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r6fVqhQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r6fVqhQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1448C4CEE9;
	Tue, 20 May 2025 14:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750857;
	bh=h1eJ8Y3896EsGx9xKr3hiut7Q2XNGG3A2yQggg5arlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r6fVqhQp9bgQevurG1n5RTdOsjSY8KF+VKReY58zNZtAIlNyZRmBYL+o9IAzV3634
	 fFSUikK8k9Kgl/l1Im36E4fGephL9HgnYc8gHMufSq/tMOOwf94JFG5AAT62xBMTu/
	 lJDPMqvbzy1HAaiSOvzPIH+GfVxQbiA4ge3d0RJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 114/145] smb: client: fix memory leak during error handling for POSIX mkdir
Date: Tue, 20 May 2025 15:51:24 +0200
Message-ID: <20250520125815.014095872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2967,7 +2967,7 @@ replay_again:
 	/* Eventually save off posix specific response info and timestamps */
 
 err_free_rsp_buf:
-	free_rsp_buf(resp_buftype, rsp);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);


