Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224211A619B;
	Tue, 30 Jul 2024 16:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357476; cv=none; b=EMIGztQwn3XQSAAuQXK/wTNF6gGeVnsSOoqBllCLm4q7ylPRLxnqIhm/AHwcU2L+u/dTBjP7EzITyqK47vPwx6kCyWOCKca/S8Yq5RUFb4He4yVH/J7aeN/yXOqo1Qs9QbWov3ncAmNOEE0SZa9joJOE7h+UppmvWdtA54QW4H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357476; c=relaxed/simple;
	bh=kzby/A8tUOYuqTdPA+T8PxNPM5DMoNW+UagPD2nGw6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OiLnz5KuSelbA1tVAwY2sXqOzL6s6rfZbf3Jw+SAzDjzazxYzJYSa7Xezdp44eJZthb0aAsrn6UVRdBc/P+y8hug6lXyM+5zyQLsfsh+5sxCdEgrdEejSXCSYhCJMbgSKkytDCHGDoznCxsbukLRTecQW9xypmkF4RXviA0TXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf1s42dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf1s42dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879A5C32782;
	Tue, 30 Jul 2024 16:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357476;
	bh=kzby/A8tUOYuqTdPA+T8PxNPM5DMoNW+UagPD2nGw6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pf1s42ddAH1p/q9A162XAwObDh16eZyJnq4P+pEgWA/9BCZepRGtkesOMl5jCHiaC
	 fxt4TIRgN17r8BYqrDPdnFAylsU4dcNdB7z33BxjEZkguTT6E7PvItRrFRhMJFn2Da
	 xraVOzFcubAb331vOhNr+jTknjZV7AovZEnNs/XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowell@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 296/440] cifs: fix potential null pointer use in destroy_workqueue in init_cifs error path
Date: Tue, 30 Jul 2024 17:48:49 +0200
Message-ID: <20240730151627.391028245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Steve French <stfrench@microsoft.com>

commit 193cc89ea0ca1da311877d2b4bb5e9f03bcc82a2 upstream.

Dan Carpenter reported a Smack static checker warning:
   fs/smb/client/cifsfs.c:1981 init_cifs()
   error: we previously assumed 'serverclose_wq' could be null (see line 1895)

The patch which introduced the serverclose workqueue used the wrong
oredering in error paths in init_cifs() for freeing it on errors.

Fixes: 173217bd7336 ("smb3: retrying on failed server close")
Cc: stable@vger.kernel.org
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: David Howells <dhowell@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1872,12 +1872,12 @@ init_cifs(void)
 					   WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
 	if (!serverclose_wq) {
 		rc = -ENOMEM;
-		goto out_destroy_serverclose_wq;
+		goto out_destroy_deferredclose_wq;
 	}
 
 	rc = cifs_init_inodecache();
 	if (rc)
-		goto out_destroy_deferredclose_wq;
+		goto out_destroy_serverclose_wq;
 
 	rc = init_mids();
 	if (rc)
@@ -1939,6 +1939,8 @@ out_destroy_mids:
 	destroy_mids();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_serverclose_wq:
+	destroy_workqueue(serverclose_wq);
 out_destroy_deferredclose_wq:
 	destroy_workqueue(deferredclose_wq);
 out_destroy_cifsoplockd_wq:
@@ -1949,8 +1951,6 @@ out_destroy_decrypt_wq:
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_destroy_serverclose_wq:
-	destroy_workqueue(serverclose_wq);
 out_clean_proc:
 	cifs_proc_clean();
 	return rc;


