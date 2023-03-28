Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979D28BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D162C433D2;
	Tue, 28 Mar 2023 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014881;
	bh=dDUk6bMwc3bUKOEEs3+JmCEZTNU36urNuA3djw5fv8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzSM1zbuayxCYbMz0digMQTGeImy4hnRafGlfCpONTDgN1wGXGBcECiIhJ6FbE9/i
	 wsdmMHb5cPoxr81KvyRR9/SjH5px4pdXxnyNAb7pClQrPqoKDc5VVRVTPZyBZjlO8k
	 5yh/yKlHcelSK+Xg1K17QROzheI0D5EgrjaWrRGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 086/240] ksmbd: add low bound validation to FSCTL_SET_ZERO_DATA
Date: Tue, 28 Mar 2023 16:40:49 +0200
Message-Id: <20230328142623.356299473@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
index 875eecc6b95e7..abe7ea1c8a2f5 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7770,7 +7770,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 
 		off = le64_to_cpu(zero_data->FileOffset);
 		bfz = le64_to_cpu(zero_data->BeyondFinalZero);
-		if (off > bfz) {
+		if (off < 0 || bfz < 0 || off > bfz) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.39.2



