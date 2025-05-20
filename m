Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9E1222570;
	Tue, 20 May 2025 14:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749970; cv=none; b=njq0nH1PO5uxicZXYJDyLa1XXseuDIdTZ1eJziAZPeEoGQSCaoClI1XfXRSGuca8m0b24SHdIJmTIM8bmfGW2boqdNW2AuW6ydTFyejMylTis1P+l+ahRT6g9MGgDTeQCvBNabSIYAiiICKJgBSdFx4doQqGML3BvEJwruNaLO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749970; c=relaxed/simple;
	bh=BfEglnPtv3l+a7VnvLkBkO0eI/RqNu1gRvKOI5Ro9t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHHsJw5I4UGktuNof026HL2qcC4JmXxzbkNA+uBcSDaLrs2f5815dM+V0wVsZNeZJnTw+GR6Og0AuFE9jsM+cBeZCnj3AfQJl0D8YLNgf5Nnxst3Ja8UlXbcTtqUYbyC7L7v703/sOTOym+7unVFL/gjs7KeHfbGDU6ddWvJWeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERzi6cOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERzi6cOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228C5C4CEE9;
	Tue, 20 May 2025 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749970;
	bh=BfEglnPtv3l+a7VnvLkBkO0eI/RqNu1gRvKOI5Ro9t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERzi6cOe/osh29emgp5WS0p6aC9k1wmP7vwBMU4Muq50SwAS8tinaVAXnHfYFcQfI
	 XPQ9CWAuWuJSWDE37ZqqxA/2Gp2AYmsfyHzHystwqdEOZ2zBqRirblSnwwgrvbMlLB
	 YCg9lfzGY4itHkJ66Be9MZ95asoAfbD9PAL/6oc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 088/117] smb: client: fix memory leak during error handling for POSIX mkdir
Date: Tue, 20 May 2025 15:50:53 +0200
Message-ID: <20250520125807.488863242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2979,7 +2979,7 @@ replay_again:
 	/* Eventually save off posix specific response info and timestaps */
 
 err_free_rsp_buf:
-	free_rsp_buf(resp_buftype, rsp);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);


