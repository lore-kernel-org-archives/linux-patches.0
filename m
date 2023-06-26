Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57BE134CE
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2689DC433C0;
	Mon, 26 Jun 2023 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803847;
	bh=vVWoUSN831JSi8Ng2jjyfRjOKZ67+eBu8bLbQszSAYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKh2yWuQ5hS9sTk7We43nMVmsocfOvapVF2hErXOGASPFnL3HM1QX7SxTB8rUGDqp
	 xICzsvVkpzlhtQYbJldLdfWxIxmTjICbmIODWNHpFTI4lTOL6E/KBY3YFdY9nTES9j
	 iKAeI/Ms3wuekwe19j9+8+4CKAnnr9oip95B2E4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coverity Scan <scan-admin@coverity.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 198/199] ksmbd: fix uninitialized pointer read in smb2_create_link()
Date: Mon, 26 Jun 2023 20:11:44 +0200
Message-ID: <20230626180814.416899622@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

commit df14afeed2e6c1bbadef7d2f9c46887bbd6d8d94 upstream.

There is a case that file_present is true and path is uninitialized.
This patch change file_present is set to false by default and set to
true when patch is initialized.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Reported-by: Coverity Scan <scan-admin@coverity.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5560,7 +5560,7 @@ static int smb2_create_link(struct ksmbd
 {
 	char *link_name = NULL, *target_name = NULL, *pathname = NULL;
 	struct path path;
-	bool file_present = true;
+	bool file_present = false;
 	int rc;
 
 	if (buf_len < (u64)sizeof(struct smb2_file_link_info) +
@@ -5593,8 +5593,8 @@ static int smb2_create_link(struct ksmbd
 	if (rc) {
 		if (rc != -ENOENT)
 			goto out;
-		file_present = false;
-	}
+	} else
+		file_present = true;
 
 	if (file_info->ReplaceIfExists) {
 		if (file_present) {


