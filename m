Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5AF2AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C6EC433C7;
	Wed, 20 Sep 2023 12:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211639;
	bh=Wjz9aPbIIiSZlblQWVow/IfseY8NTe139YKSUEQfTHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nkc1dS3/GC33eT/K+f5KeHolNeENnVOMozua5DmRMn9FKoOcBdVy0MtwNriAt63fg
	 jK/iklH6TXjCtJlgpvgLQPM9CZcCcJT2hOsP5ZsvARgaXPRSud30wuOqnfS89R2qJr
	 fQG82UEcYSm9tlG0Zcjl7v0pC6ZUZEHZoPBcM+KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 168/186] media: anysee: fix null-ptr-deref in anysee_master_xfer
Date: Wed, 20 Sep 2023 13:31:11 +0200
Message-ID: <20230920112842.957885690@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit c30411266fd67ea3c02a05c157231654d5a3bdc9 ]

In anysee_master_xfer, msg is controlled by user. When msg[i].buf
is null and msg[i].len is zero, former checks on msg[i].buf would be
passed. Malicious data finally reach anysee_master_xfer. If accessing
msg[i].buf[0] without sanity check, null ptr deref would happen.
We add check on msg[i].len to prevent crash.

Similar commit:
commit 0ed554fd769a
("media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()")

Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil: add spaces around +]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 20ee7eea2a91e..83af86505363b 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -211,7 +211,7 @@ static int anysee_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
 
 	while (i < num) {
 		if (num > i + 1 && (msg[i+1].flags & I2C_M_RD)) {
-			if (msg[i].len > 2 || msg[i+1].len > 60) {
+			if (msg[i].len != 2 || msg[i + 1].len > 60) {
 				ret = -EOPNOTSUPP;
 				break;
 			}
-- 
2.40.1



