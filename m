Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0673A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8099EC433EF;
	Wed, 28 Dec 2022 15:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240964;
	bh=lP2hftc/IGXLm6OvTWqEEbJiePcYt5ggfTLyTNUPeQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JReg1Tv9gUb6pcJsJnIn/xrZ57YjBGzZmXP5ok43XmttthH9RbLYfWjGqNEL3N0Nt
	 LGNmjrUgUzIY8KKrSedPSrZ9/Aj/sqYSpb8twYQu2y7WZgJzkrHxHsg0w+XvekrlGO
	 A5iGuHdaiQD3tzus1sCflPE/9p+MHtQb0mYy5MH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0224/1073] Input: iqs7222 - protect against undefined slider size
Date: Wed, 28 Dec 2022 15:30:12 +0100
Message-Id: <20221228144334.104660573@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff LaBundy <jeff@labundy.com>

[ Upstream commit 2f6fd232978906f6fb054529210b9faec384bd45 ]

Select variants of silicon do not define a default slider size, in
which case the size must be specified in the device tree. If it is
not, the axis's maximum value is reported as 65535 due to unsigned
integer overflow.

To solve this problem, move the existing zero-check outside of the
conditional block that checks whether the property is present.

Fixes: e505edaedcb9 ("Input: add support for Azoteq IQS7222A/B/C")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/Y1SRXEi7XMlncDWk@nixie71
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/iqs7222.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/iqs7222.c b/drivers/input/misc/iqs7222.c
index 350be4f23f50..8fd665874a24 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2024,7 +2024,7 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 
 	error = fwnode_property_read_u32(sldr_node, "azoteq,slider-size", &val);
 	if (!error) {
-		if (!val || val > dev_desc->sldr_res) {
+		if (val > dev_desc->sldr_res) {
 			dev_err(&client->dev, "Invalid %s size: %u\n",
 				fwnode_get_name(sldr_node), val);
 			return -EINVAL;
@@ -2043,6 +2043,13 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222,
 		return error;
 	}
 
+	if (!(reg_offset ? sldr_setup[3]
+			 : sldr_setup[2] & IQS7222_SLDR_SETUP_2_RES_MASK)) {
+		dev_err(&client->dev, "Undefined %s size\n",
+			fwnode_get_name(sldr_node));
+		return -EINVAL;
+	}
+
 	error = fwnode_property_read_u32(sldr_node, "azoteq,top-speed", &val);
 	if (!error) {
 		if (val > (reg_offset ? U16_MAX : U8_MAX * 4)) {
-- 
2.35.1



