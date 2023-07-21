Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B106920F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354C9C433C8;
	Fri, 21 Jul 2023 19:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967506;
	bh=HObl+iY30lYIWVAQA6PMNMMHJ3XLAcmMnNHdI4emXiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouohvaoeNELCvPw+JfplCXQUhwpoB+uF/fGP7wblsD09lw3fTnvj0UpK8SWup8pL9
	 enW+PPNFMiKSe7UFst/WBILXuw7uZdJrRp0ZFM6nbj8BUBY0YQZBWhEzIpyoTMbkZU
	 3kv2wzjg90x66SdGCBnEw217SYk8vn9DupzNygWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 187/223] cifs: if deferred close is disabled then close files immediately
Date: Fri, 21 Jul 2023 18:07:20 +0200
Message-ID: <20230721160528.860416098@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

commit df9d70c18616760c6504b97fec66b6379c172dbb upstream.

If defer close timeout value is set to 0, then there is no
need to include files in the deferred close list and utilize
the delayed worker for closing. Instead, we can close them
immediately.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -954,8 +954,8 @@ int cifs_close(struct inode *inode, stru
 		cfile = file->private_data;
 		file->private_data = NULL;
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
-		if ((cinode->oplock == CIFS_CACHE_RHW_FLG) &&
-		    cinode->lease_granted &&
+		if ((cifs_sb->ctx->closetimeo && cinode->oplock == CIFS_CACHE_RHW_FLG)
+		    && cinode->lease_granted &&
 		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
 		    dclose) {
 			if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {


