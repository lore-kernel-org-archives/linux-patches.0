Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A921A76A9;
	Tue, 30 Jul 2024 17:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360061; cv=none; b=UNzQVosgnjkTyRNWphaQxXzAsr8E2rCS4E054EvQMfVDI5Q/6v3YvpHMXwYUI122jabyAtdqUocdVh79WeqhBrb7fyZtjrcd34qngHJrdRiazqi/K+qXKY5sNg8u87xfFgJr1Yjn6MNV0SQG6wP1xHMY1eC4XdpraghqAluua/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360061; c=relaxed/simple;
	bh=SA2assnotwClmxuNA2vWvuNIvH+Yz3M5ynsGPbxUQ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjP1FYith4ard3PczMa9/hLscIKaESBB5DK6CjINggKfuw1lIjSMz5O6GFRyHH1pr/6tLLjXUzq28FBflR4LsW8vBNzur7ogJMKAkssnWWdlfENiWGvHUeUdRRkwHEfGqg0ucaAWoB4Vh1BFfxQt5xph28lp10vshN/w9l75jvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CICyIJrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CICyIJrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8156CC32782;
	Tue, 30 Jul 2024 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360060;
	bh=SA2assnotwClmxuNA2vWvuNIvH+Yz3M5ynsGPbxUQ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CICyIJrq6pksHv0jS0LRWHWSNJeJKDEZKOWgrQ2td1kK6edSDyqqB+6p8f4uU3vGs
	 aBMloD+xv+dRv5+3+9LKk8ulse+cL84zt8KufyntvzI2E18fGsXZeUbVWT6AFwCcQY
	 zk8dTYIhLDTvzXwu4jcrVEJZmDqhmBnycwUEDPHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ritvik Budhiraja <rbudhiraja@microsoft.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	David Howells <dhowell@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.10 584/809] cifs: fix potential null pointer use in destroy_workqueue in init_cifs error path
Date: Tue, 30 Jul 2024 17:47:40 +0200
Message-ID: <20240730151747.896847130@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1894,12 +1894,12 @@ init_cifs(void)
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
 
 	rc = cifs_init_netfs();
 	if (rc)
@@ -1967,6 +1967,8 @@ out_destroy_netfs:
 	cifs_destroy_netfs();
 out_destroy_inodecache:
 	cifs_destroy_inodecache();
+out_destroy_serverclose_wq:
+	destroy_workqueue(serverclose_wq);
 out_destroy_deferredclose_wq:
 	destroy_workqueue(deferredclose_wq);
 out_destroy_cifsoplockd_wq:
@@ -1977,8 +1979,6 @@ out_destroy_decrypt_wq:
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_destroy_serverclose_wq:
-	destroy_workqueue(serverclose_wq);
 out_clean_proc:
 	cifs_proc_clean();
 	return rc;


