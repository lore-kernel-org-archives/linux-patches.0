Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD6921773D;
	Tue,  8 Jul 2025 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992569; cv=none; b=jsxB3QWO62UCLlTdBY9A4T1bz2UOdZfQF6afhIazGseBZyKdBpbJVKW0Q2Qo+Xxthmd+OcFt3CNh9BncidbdtbvHKTvSAK+RSMrBM4oaoDMuBsXYx+4iFEZyWoCYsnfLVMGXJ6DYgbvvs25zDRdcym7p2NyE9g5aVJ2fV9HqBoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992569; c=relaxed/simple;
	bh=vdbwql6KC6mLhrxIRECS27fOgwZOjz04i4/PAuOmvYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnjO5I5bi3tqNJAJ32/ynbpvkPgK7v5xP0jLgZd3jnMBB5ciCdAvhWcWP6DqdIwhSuGkwqBn0Gkl/58ERIgmF1sT20yxn2FBPQWMUXUCxIdzF2zI+zuXb4YHnoGeljeXzLvOPy7bss4ytAOko2lKFd6atTtYIwWTDDJI+i0qEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eT6FyBE4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eT6FyBE4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6585BC4CEED;
	Tue,  8 Jul 2025 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992568;
	bh=vdbwql6KC6mLhrxIRECS27fOgwZOjz04i4/PAuOmvYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT6FyBE4QYYZ/IqeK7SHL9FulN73c6Rg3gwehbPSe6rUGZ+l/qabOVZLndbAJZZ83
	 h/CtOuIrA7hy6QlOj640IuHsYii5o8c/Q7x6xWfCeOYTM1X6LIyMO1Q1q8fUAumMn3
	 /Abpl7T9wuiRmnanspo8Zzd/D22Hn+v1idQo0GeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 114/132] Input: iqs7222 - explicitly define number of external channels
Date: Tue,  8 Jul 2025 18:23:45 +0200
Message-ID: <20250708162233.901296346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


