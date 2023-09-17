Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A404A6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3FFC433CA;
	Sun, 17 Sep 2023 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981127;
	bh=jeVkVFJaM9h8UIqwaIqQ9/9iZB7ECAUA9LQzgdH8AqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiHHrGce3VIsC0hnIIrftwKZGjZzMX/ughyme5ruzDZeBJP9dqtgEJRbaRhLmlwoL
	 BCQw0jLqJJNHBOzl0HNEUJAdrQBBYOaEV25KLafh2RsP3hXS3T63Xiy+jtZdarTnRK
	 H1AAz3jXeCF1xHrLLrYYXpSHns3/zeo1KetQKKZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 009/511] ksmbd: fix out of bounds in smb3_decrypt_req()
Date: Sun, 17 Sep 2023 21:07:16 +0200
Message-ID: <20230917191114.058105987@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit dc318846f3dd54574a36ae97fc8d8b75dd7cdb1e ]

smb3_decrypt_req() validate if pdu_length is smaller than
smb2_transform_hdr size.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21589
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7983e8c9c89d0..f5506853ac0fa 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8649,7 +8649,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
 	int rc = 0;
 
-	if (buf_data_size < sizeof(struct smb2_hdr)) {
+	if (pdu_length < sizeof(struct smb2_transform_hdr) ||
+	    buf_data_size < sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
 		       pdu_length);
 		return -ECONNABORTED;
-- 
2.40.1



