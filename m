Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B053216E14;
	Thu, 12 Dec 2024 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022437; cv=none; b=l22hbbAOOHA8qVQ5DpVOC7dPZIz4ZxLBMHRJh6k6UPP7ZqSy6SfdnezdPWKPYk9+HQQ3Yn7mbW9jiTxS6CouohpsOaRv3vjblQS7jJCug2S2iIg5pDygzmQGblVcAoKPlyb2ZxM5hxKTTeeJH4RVZst7z+ZOcVYkXQe59YslfV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022437; c=relaxed/simple;
	bh=EyCv2aR5YVkXq79peq2q8IfUihcbGBWkaLZxkRwAij8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMBmLP7HcpDWKqC1O/TxspkTg59gCB4L+cwY9pnAadQYTmmXs5M4syGL0s5a4qCok+LVQJ4NWNyOa6Z4UWlxpT0C/LIY0hb0kePhnZkVCgj8x53RzEwbp5g45yNiMSxVPdWbDAr35LYMNLbqBb7tKTNAYpjwjtazwC0XvNizJgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvYUKceL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvYUKceL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2BCC4CECE;
	Thu, 12 Dec 2024 16:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022437;
	bh=EyCv2aR5YVkXq79peq2q8IfUihcbGBWkaLZxkRwAij8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvYUKceLYJnv/5Zc1kLzYD+zOBcIwIIVhGGx1KTkQGI9ZiD42QpcYuQ91IdJHFgk4
	 Pe4ve4YqcVJq81vdB7zPkE3MDQy6xjUPykZC3vZ6cQ5b2l+3l19PjQw47wNoW5lrH/
	 cGfFRiSzqYZkpqEoZi6aiqw5hCFlxO36uoFbOGNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/565] mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()
Date: Thu, 12 Dec 2024 15:57:15 +0100
Message-ID: <20241212144320.967013113@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 192a16a3430ca459c4e986f3d10758c4d6b1aa29 ]

Both the inner and outer loops in this code use the "i" iterator.
The inner loop should really use a different iterator.

It doesn't affect things in practice because the data comes from the
device tree.  The "protocol" and "windows" variables are going to be
zero.  That means we're always going to hit the "return &chans[channel];"
statement and we're not going to want to iterate through the outer
loop again.

Still it's worth fixing this for future use cases.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index 68f766621b9b5..9785b2f8ed62f 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -499,7 +499,7 @@ static const struct mhuv2_protocol_ops mhuv2_data_transfer_ops = {
 static struct mbox_chan *get_irq_chan_comb(struct mhuv2 *mhu, u32 __iomem *reg)
 {
 	struct mbox_chan *chans = mhu->mbox.chans;
-	int channel = 0, i, offset = 0, windows, protocol, ch_wn;
+	int channel = 0, i, j, offset = 0, windows, protocol, ch_wn;
 	u32 stat;
 
 	for (i = 0; i < MHUV2_CMB_INT_ST_REG_CNT; i++) {
@@ -509,9 +509,9 @@ static struct mbox_chan *get_irq_chan_comb(struct mhuv2 *mhu, u32 __iomem *reg)
 
 		ch_wn = i * MHUV2_STAT_BITS + __builtin_ctz(stat);
 
-		for (i = 0; i < mhu->length; i += 2) {
-			protocol = mhu->protocols[i];
-			windows = mhu->protocols[i + 1];
+		for (j = 0; j < mhu->length; j += 2) {
+			protocol = mhu->protocols[j];
+			windows = mhu->protocols[j + 1];
 
 			if (ch_wn >= offset + windows) {
 				if (protocol == DOORBELL)
-- 
2.43.0



