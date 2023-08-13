Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFF89446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15562C433C8;
	Sun, 13 Aug 2023 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962429;
	bh=RNMx4+Gd8POU/JnylrV5ver8PgqAcKBXdCAcNSH4D58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um9Bi5iSohqbCHoJzt+bP52NYOGyNpPlhdrSsZWIQlJVWL8Jk29JhGPgj2OaQkZwa
	 jvSB/8pLGVMM47Lzbdg2KEZ6vofASdm2VFo7w33rIekzulyvnXtDFwNES+4nPpj/Id
	 J9y8w3Tu0BWhWHMAmbgRwcMnwl4HSRXL5k3tQX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 006/149] ksmbd: fix wrong next length validation of ea buffer in smb2_set_ea()
Date: Sun, 13 Aug 2023 23:17:31 +0200
Message-ID: <20230813211718.952813323@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
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

commit 79ed288cef201f1f212dfb934bcaac75572fb8f6 upstream.

There are multiple smb2_ea_info buffers in FILE_FULL_EA_INFORMATION request
from client. ksmbd find next smb2_ea_info using ->NextEntryOffset of
current smb2_ea_info. ksmbd need to validate buffer length Before
accessing the next ea. ksmbd should check buffer length using buf_len,
not next variable. next is the start offset of current ea that got from
previous ea.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21598
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2340,9 +2340,16 @@ next:
 			break;
 		buf_len -= next;
 		eabuf = (struct smb2_ea_info *)((char *)eabuf + next);
-		if (next < (u32)eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
+		if (buf_len < sizeof(struct smb2_ea_info)) {
+			rc = -EINVAL;
 			break;
+		}
 
+		if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
+				le16_to_cpu(eabuf->EaValueLength)) {
+			rc = -EINVAL;
+			break;
+		}
 	} while (next != 0);
 
 	kfree(attr_name);


