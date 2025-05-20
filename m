Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A322D7A8;
	Tue, 20 May 2025 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749579; cv=none; b=G5joCuXWnLiBqrm9GBzFKnV//ZqmfQxv7SLEQgM513xJ/NzCDhuBlYHGdW9yDs8Pc/Pk+jvi9slea+HOgT2afl2YqF3OFHTdd/yW8gYSTKaGcmFeEYnBIcoJiZ/5kWVflbJiHwAddBZwvym0JCJzh47FPoE/WxbDYePI8EsooTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749579; c=relaxed/simple;
	bh=8o2J1Goq8S4gvSWgRvrcqa6/9m4+tDJ8Rco03obWhxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJnGuaWyGmOm97VvEozbNKZXfWitfl59WOISp+KtnZqQN1ZE6neE3/lMiVU4L/VObmIao6mVGRHpQ7JdfJUEPYyjmx8KhcMsXHPtY4PX5BHL9D2aFj15x/tKbhAZey3GIigiItToqL7winGO9p586Jd7O58CGewDfjUck+9BCr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtEh7qg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtEh7qg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A396CC4CEE9;
	Tue, 20 May 2025 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749579;
	bh=8o2J1Goq8S4gvSWgRvrcqa6/9m4+tDJ8Rco03obWhxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtEh7qg1H6hGikHVSYTM6j20O4ffmJeLF7UyqcDNYOQJRuKtekb0D/Ep+GLIUNtO4
	 NPjsC0smsqx9gISLuM2DWntIXiKpWlXi7idLxCgbGL2No5Go2B9aSYVDNNbJ8FxpUg
	 2AXTaYWKiQf5MYgjfoNVntBozTCCQpPyzmH6otVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jethro Donaldson <devel@jro.nz>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 62/97] smb: client: fix memory leak during error handling for POSIX mkdir
Date: Tue, 20 May 2025 15:50:27 +0200
Message-ID: <20250520125803.082298042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2826,7 +2826,7 @@ int smb311_posix_mkdir(const unsigned in
 	/* Eventually save off posix specific response info and timestaps */
 
 err_free_rsp_buf:
-	free_rsp_buf(resp_buftype, rsp);
+	free_rsp_buf(resp_buftype, rsp_iov.iov_base);
 	kfree(pc_buf);
 err_free_req:
 	cifs_small_buf_release(req);


