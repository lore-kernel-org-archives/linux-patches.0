Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739E02E49A8;
	Tue,  8 Jul 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993152; cv=none; b=NV7OhL0xW/caBkTxj4bGKi1pFdgK+pgkrrOQaVVEQqAOgOI/c770C1RrmOk3vjeYxnmTPgdEsJWfhv0W5daRl/X7gRJm4oUbQmascPaWbfSMsf8gI04cmsVPvxiUkz8lvh3hfu3QhmHPn0lWxHzyfoUoAYbCdBLa9YQfW2tw5ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993152; c=relaxed/simple;
	bh=/rEYKvvgtvTk1c1d3lEoCEQY4o301FNGpbk4/FUiMjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDJTwxBa7vvSKgnYgxu4Kauag2WN5DAh5e2cI4BZbVtudrzZA3Z8M/KTS12itouq7L2APofW7LkRutKxpKjV43nGwZy3rVLN/oZSeVPtJX0K7NBR75XZXshi+MrCjDfxhy4uB0hlOJEIAJ++EB24ll/APTAG0mTR8v7IAOhhHQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzC2zrCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzC2zrCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E283C4CEF0;
	Tue,  8 Jul 2025 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993152;
	bh=/rEYKvvgtvTk1c1d3lEoCEQY4o301FNGpbk4/FUiMjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzC2zrCKvZ5UToC9fvgDV/ZMjo81HYy7nzmbEkh39IUGHFUnB8lxH+0duGxarxNpb
	 J9hx/duhXZwgC6lJPv8FPb4NL3l1bPpJsWmCgAoC0qcLB0TnfD8WP68NScZhEEbtkc
	 cdC7k6hSTG5J6wdnIq3CW7P8dh2svLg7AP5l0r8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 206/232] Input: iqs7222 - explicitly define number of external channels
Date: Tue,  8 Jul 2025 18:23:22 +0200
Message-ID: <20250708162246.828055185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff LaBundy <jeff@labundy.com>

commit 63f4970a1219b5256e8ea952096c86dab666d312 upstream.

The number of external channels is assumed to be a multiple of 10,
but this is not the case for IQS7222D. As a result, some CRx pins
are wrongly prevented from being assigned to some channels.

Address this problem by explicitly defining the number of external
channels for cases in which the number of external channels is not
equal to the total number of available channels.

Fixes: dd24e202ac72 ("Input: iqs7222 - add support for Azoteq IQS7222D")
Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/aGHVf6HkyFZrzTPy@nixie71
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -301,6 +301,7 @@ struct iqs7222_dev_desc {
 	int allow_offset;
 	int event_offset;
 	int comms_offset;
+	int ext_chan;
 	bool legacy_gesture;
 	struct iqs7222_reg_grp_desc reg_grps[IQS7222_NUM_REG_GRPS];
 };
@@ -315,6 +316,7 @@ static const struct iqs7222_dev_desc iqs
 		.allow_offset = 9,
 		.event_offset = 10,
 		.comms_offset = 12,
+		.ext_chan = 10,
 		.reg_grps = {
 			[IQS7222_REG_GRP_STAT] = {
 				.base = IQS7222_SYS_STATUS,
@@ -373,6 +375,7 @@ static const struct iqs7222_dev_desc iqs
 		.allow_offset = 9,
 		.event_offset = 10,
 		.comms_offset = 12,
+		.ext_chan = 10,
 		.legacy_gesture = true,
 		.reg_grps = {
 			[IQS7222_REG_GRP_STAT] = {
@@ -2244,7 +2247,7 @@ static int iqs7222_parse_chan(struct iqs
 	const struct iqs7222_dev_desc *dev_desc = iqs7222->dev_desc;
 	struct i2c_client *client = iqs7222->client;
 	int num_chan = dev_desc->reg_grps[IQS7222_REG_GRP_CHAN].num_row;
-	int ext_chan = rounddown(num_chan, 10);
+	int ext_chan = dev_desc->ext_chan ? : num_chan;
 	int error, i;
 	u16 *chan_setup = iqs7222->chan_setup[chan_index];
 	u16 *sys_setup = iqs7222->sys_setup;
@@ -2448,7 +2451,7 @@ static int iqs7222_parse_sldr(struct iqs
 	const struct iqs7222_dev_desc *dev_desc = iqs7222->dev_desc;
 	struct i2c_client *client = iqs7222->client;
 	int num_chan = dev_desc->reg_grps[IQS7222_REG_GRP_CHAN].num_row;
-	int ext_chan = rounddown(num_chan, 10);
+	int ext_chan = dev_desc->ext_chan ? : num_chan;
 	int count, error, reg_offset, i;
 	u16 *event_mask = &iqs7222->sys_setup[dev_desc->event_offset];
 	u16 *sldr_setup = iqs7222->sldr_setup[sldr_index];


