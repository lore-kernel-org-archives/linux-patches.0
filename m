Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96942168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA15C4339E;
	Mon,  8 May 2023 10:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543386;
	bh=14kBK6PD+BNdBBWGm1NBzVsxFkmZqxS3IZqeaYSiPWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq4LdzbnW0g/DwYqXUPTPzT9D9Sgw8ZRYe93835sRIZJNW9+jGKKpaDpGmfKN6jph
	 TgzTciT0m6eynabAr928+D+4idBLP6HRvRatjhz/fi5xoO/JCB73PghKfqjIMbX1pv
	 4GS6H3oOSgd2en78rpQiuVrI+G2IHzD9so7GjiYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.3 073/694] ksmbd: block asynchronous requests when making a delay on session setup
Date: Mon,  8 May 2023 11:38:28 +0200
Message-Id: <20230508094434.915202833@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit b096d97f47326b1e2dbdef1c91fab69ffda54d17 upstream.

ksmbd make a delay of 5 seconds on session setup to avoid dictionary
attacks. But the 5 seconds delay can be bypassed by using asynchronous
requests. This patch block all requests on current connection when
making a delay on sesstion setup failure.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20482
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1874,8 +1874,11 @@ out_err:
 				try_delay = true;
 
 			sess->state = SMB2_SESSION_EXPIRED;
-			if (try_delay)
+			if (try_delay) {
+				ksmbd_conn_set_need_reconnect(conn);
 				ssleep(5);
+				ksmbd_conn_set_need_negotiate(conn);
+			}
 		}
 	}
 


