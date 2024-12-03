Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590F62D7BF;
	Tue,  3 Dec 2024 15:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239120; cv=none; b=ZMLdRwJlSrBWlWSKraLKaZb8zt4D4TrhiuSU+0wZNZXqRKzKAP9NHl0KCiTFqXHjUJDFgqKPCKM1bnGwfsAnic2xGDOsU2KYlku2lyCXu+Qn4mW/A2kOJ0T0UzguZbXIHPXjXyrCJRy67eZdoK2Kf5xj4A8CKCik139DzPTpWUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239120; c=relaxed/simple;
	bh=AVpebE2N4bWCa7rlOeTJxz5/0d0aGpZ76Csdp6CMXE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRXqlXhvEv/WrLTs6Csyi6fyB+NKHopAYbLjIk005Kay9X5uW3Cax99I3TQnOrZzR5f/t60IK7mc5T9TKe2K3xCbm/273K3NqdRgnQ8+92Hj1TkW6030uYDP/yXmM4UXKHcJx+zDTtyic4xVzXK5SdKC7YpkD88I/Q5ZRO8gq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLAmrZY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLAmrZY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20E6C4CECF;
	Tue,  3 Dec 2024 15:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239120;
	bh=AVpebE2N4bWCa7rlOeTJxz5/0d0aGpZ76Csdp6CMXE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLAmrZY2oUZFXfo034uQ0tSzPxKhxh0b9NNMNrXcrpge0tqHX99NpXwrdUDdkgPsw
	 D1UyKZzeKQitLFdKRE7CW+aBYVtLRNbwL5Ms49Kpq2xDQOCHZCMpza4AWCv27lKZT4
	 /eaUM/olFGGj9L11m3SXRvo/vfj6hAM8uJzORtpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 479/817] mailbox: arm_mhuv2: clean up loop in get_irq_chan_comb()
Date: Tue,  3 Dec 2024 15:40:51 +0100
Message-ID: <20241203144014.569532122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



