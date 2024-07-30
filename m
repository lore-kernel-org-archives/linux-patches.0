Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E706189907;
	Tue, 30 Jul 2024 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358737; cv=none; b=FdM/Ua+i3O7ucKwkxZdpQ7GVidND0AaUvsKk/rslLjPKNidS1WYAdK7P+jV/Vewv4jDxJhMhnR7TJgvgmt1mWlu8gcIAvmeQtNS5Tpc8fviTlm73VhxRQH2QiNgDjZLV4qr7oLCqKgFPXs+PSheraMzc5BbtN9EaqkT8pK3BBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358737; c=relaxed/simple;
	bh=vdQcpiBNTTbAc3HrSrHzecZBmSvwMTIMMKrpQ3FD+90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5S5dsGJqcNWKgmEzT4E4AZ2G84n/kapKn54TWjU5ejyqjwbb7MAUxM6AmqPQ9ytGSW4AYDuuIJVyGd238ojwC7JZ2Niflbt5tP4NB1ws9yD0OPv+6fZoTAzpYCqiZZRwikLtnsG4OZ2+W9DTmXeUipedN+uVKwx4Dk5KdpQ1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIYCvDou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIYCvDou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C40C4AF0A;
	Tue, 30 Jul 2024 16:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358737;
	bh=vdQcpiBNTTbAc3HrSrHzecZBmSvwMTIMMKrpQ3FD+90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIYCvDouUeldQiZ2Sdv8uFA8Sh/81ZOla0uA1xoayGCY4EcBWkE4Gtp+eFymHKG4y
	 DS7jORiBxIw87b1hIaXIw28aoZhiJyp851cDlRQc2NM1xHXVg58lnw8Is5xITMbsyP
	 EXb36J8Siif104mavNgN25mCtHz7r7Uu9v5NUL5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowell@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 390/568] cifs: fix potential null pointer use in destroy_workqueue in init_cifs error path
Date: Tue, 30 Jul 2024 17:48:17 +0200
Message-ID: <20240730151655.107373926@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1885,12 +1885,12 @@ init_cifs(void)
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
@@ -1952,6 +1952,8 @@ out_destroy_mids:
 	destroy_mids();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_serverclose_wq:
+	destroy_workqueue(serverclose_wq);
 out_destroy_deferredclose_wq:
 	destroy_workqueue(deferredclose_wq);
 out_destroy_cifsoplockd_wq:
@@ -1962,8 +1964,6 @@ out_destroy_decrypt_wq:
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_destroy_serverclose_wq:
-	destroy_workqueue(serverclose_wq);
 out_clean_proc:
 	cifs_proc_clean();
 	return rc;


