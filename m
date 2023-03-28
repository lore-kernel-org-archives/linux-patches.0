Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A62D8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F3BC433D2;
	Tue, 28 Mar 2023 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015519;
	bh=gGn3pTAX8u5w6RkFF1n+LeGZs/Vd8hCJdX3akLwvoNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRzYHHHXF9nJbzmG9aIXbNfux8p5cO8np6AcrbiAFX4HgdXviiEwHC/+jW+Onf0PO
	 vFNWUV05ATAwxYK11IQYRUkCwPJsx7dVSIqINz78FlTry/tZAchCPDqFlfzmjLbvTK
	 ANwDagwync1MOGhK7USKLEBDnGQrjFRXLECbKtTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/224] ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
Date: Tue, 28 Mar 2023 16:41:13 +0200
Message-Id: <20230328142620.532623444@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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

[ Upstream commit 2d74ec97131b1179a373b6d521f195c84e894eb6 ]

Smatch static checker warning:
 fs/ksmbd/smb2pdu.c:7759 smb2_ioctl()
 warn: no lower bound on 'off'

Fix unexpected result that could caused from negative off and bfz.

Fixes: b5e5f9dfc915 ("ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 0f0f1243a9cbf..3bb971831e7ce 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7764,7 +7764,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 		off = le64_to_cpu(zero_data->FileOffset);
 		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
-		if (off > bfz) {
+		if (off < 0 || bfz < 0 || off > bfz) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.2



