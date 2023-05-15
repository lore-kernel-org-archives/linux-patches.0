Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC85FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8338C433D2;
	Mon, 15 May 2023 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171153;
	bh=kE5+B/7B+reYXJLIbpmzLdsl8D3qkORxgVffGdIODuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kV9JkOoBDM6KyYSb539y7LH3CMKuo2JdxhpowdXAZDy2cUKPJ2vw8FcCdgsjR4sc
	 uTaftuj2KbOdOugPPOSGMCB69p+8Ku2ls3imd1w5wvboPBG+kQTu9luK7CprZjsNtr
	 MnOQpAo0cKtQU9aKycOXii5CTkJBKg5ISNkontos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.2 118/242] ksmbd: block asynchronous requests when making a delay on session setup
Date: Mon, 15 May 2023 18:27:24 +0200
Message-Id: <20230515161725.447131272@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
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

[ Upstream commit b096d97f47326b1e2dbdef1c91fab69ffda54d17 ]

ksmbd make a delay of 5 seconds on session setup to avoid dictionary
attacks. But the 5 seconds delay can be bypassed by using asynchronous
requests. This patch block all requests on current connection when
making a delay on sesstion setup failure.

Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-20482
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ae0610c95e33c..51e95ea37195b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1863,8 +1863,11 @@ int smb2_sess_setup(struct ksmbd_work *work)
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
 
-- 
2.39.2



