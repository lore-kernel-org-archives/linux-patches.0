Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB2222D66;
	Thu, 12 Dec 2024 16:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019758; cv=none; b=f0i5M872eQsju/VuxKx6mYCVJkNzont4fr01UgjATLvPJ5jy0ui6g3yf6IRMn6KlZwiwLtm0okDbtc3h+ipdIuD1JfD4HDk2Az0eRISyJfZxME/3S3311PS1nA1m6AjvtwNpoIOnBhM1WZH7aENwTnl+fNMGoyQmZAaNOGbC6Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019758; c=relaxed/simple;
	bh=ulHDexjqr47yWkrTZO2X1k9ELmzbOkcynC+pQGn89BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8V4eCowOri45duZY1HSrz9PoyRG2frCQBilyK0hYTkIwgP0V0l7Hs/JJd3mQv/d9on15sVBZSyWFynx9jgdPbWQqZE+MMATtSrZDPfW9zaXsCc0l3D4drbkI7d7laWwxx+v+PSJdSS2SAb1cQix5vN/MHBura8L4n5PSt4cs+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFKvO91F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFKvO91F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DEFC4CECE;
	Thu, 12 Dec 2024 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019758;
	bh=ulHDexjqr47yWkrTZO2X1k9ELmzbOkcynC+pQGn89BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFKvO91F7AOHa4XELd9XB8jaJgN6rq5A8uRwO8/nSqMPXawO/rcBf/y5Hnw3UYjua
	 8/BJF7jop/n5MR6sOaMLjCxN9zGrz6UFTEOeO9L+e9gEVPXJv/0o8iOSqEC3Dr+dxJ
	 SORsdq7ofE9jfStDPyJ1fNhybA3QALcJs+8ncBqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 260/772] mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()
Date: Thu, 12 Dec 2024 15:53:25 +0100
Message-ID: <20241212144400.657271733@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec21dcdbde72..cff7c343ee082 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -500,7 +500,7 @@ static const struct mhuv2_protocol_ops mhuv2_data_transfer_ops = {
 static struct mbox_chan *get_irq_chan_comb(struct mhuv2 *mhu, u32 __iomem *reg)
 {
 	struct mbox_chan *chans = mhu->mbox.chans;
-	int channel = 0, i, offset = 0, windows, protocol, ch_wn;
+	int channel = 0, i, j, offset = 0, windows, protocol, ch_wn;
 	u32 stat;
 
 	for (i = 0; i < MHUV2_CMB_INT_ST_REG_CNT; i++) {
@@ -510,9 +510,9 @@ static struct mbox_chan *get_irq_chan_comb(struct mhuv2 *mhu, u32 __iomem *reg)
 
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



