Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7209E11723
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92A3C433C8;
	Wed, 20 Sep 2023 12:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213921;
	bh=Tfy/nct77lGBxEWbMXYIM6y12gHTnO0xNo1cz5iN1jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD6JLHJwpkS/Ydxkr2zCO328T54E2eTZOhUCQkjw0U+cBlDoRnOtLyOakn7Rc1VdK
	 kTY6IxW2i6hE4kbqfW2RWfh7PpH0zs2ZDMqpZAs2Lt7prxe+C2jsU3pT8gFGv/F7Vh
	 edZBxEeimocBWsEaK3PEnS4mCFr75BWu+LJ2rNrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/110] media: anysee: fix null-ptr-deref in anysee_master_xfer
Date: Wed, 20 Sep 2023 13:31:44 +0200
Message-ID: <20230920112832.110561959@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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
index aa45b5d263f6b..a1235d0cce92f 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -202,7 +202,7 @@ static int anysee_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
 
 	while (i < num) {
 		if (num > i + 1 && (msg[i+1].flags & I2C_M_RD)) {
-			if (msg[i].len > 2 || msg[i+1].len > 60) {
+			if (msg[i].len != 2 || msg[i + 1].len > 60) {
 				ret = -EOPNOTSUPP;
 				break;
 			}
-- 
2.40.1



