Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA161863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88887C433D2;
	Wed, 28 Dec 2022 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241282;
	bh=A8WVT7WRXqXhvvoKfoq1Qi4nYTWg7ThAoNgd2nedtXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LdvegJgs0y479QSzTOvZzXtg1U2QN9JgZTRAt1tlIqbL960TSLOPggccLmsWdgwmx
	 VfQkeZOci1LCrtZEU7UF+NKb0iYUu3dp8KwhfnQb5O4q+mWISZzQPzjerHFXidNLXw
	 zezbINTNqHCAwh46HwRx7vlm6z08U9LtpDVfE9Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0228/1146] Input: iqs7222 - protect against undefined slider size
Date: Wed, 28 Dec 2022 15:29:27 +0100
Message-Id: <20221228144336.335003970@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index ddb863bf63ee..32515946bbca 100644
--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2066,7 +2066,7 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222, int sldr_index)
 		sldr_setup[4 + reg_offset] -= 2;
 
 	if (!fwnode_property_read_u32(sldr_node, "azoteq,slider-size", &val)) {
-		if (!val || val > dev_desc->sldr_res) {
+		if (val > dev_desc->sldr_res) {
 			dev_err(&client->dev, "Invalid %s size: %u\n",
 				fwnode_get_name(sldr_node), val);
 			return -EINVAL;
@@ -2081,6 +2081,13 @@ static int iqs7222_parse_sldr(struct iqs7222_private *iqs7222, int sldr_index)
 		}
 	}
 
+	if (!(reg_offset ? sldr_setup[3]
+			 : sldr_setup[2] & IQS7222_SLDR_SETUP_2_RES_MASK)) {
+		dev_err(&client->dev, "Undefined %s size\n",
+			fwnode_get_name(sldr_node));
+		return -EINVAL;
+	}
+
 	if (!fwnode_property_read_u32(sldr_node, "azoteq,top-speed", &val)) {
 		if (val > (reg_offset ? U16_MAX : U8_MAX * 4)) {
 			dev_err(&client->dev, "Invalid %s top speed: %u\n",
-- 
2.35.1



