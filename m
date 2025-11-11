Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D878C2820A0;
	Tue, 11 Nov 2025 01:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824849; cv=none; b=Sonj3oNinsUjg6O/OgjJHoNtclSPpJ2X/gyeDr+SLQ0636WjUfKzenveFxIIw6a04+Sj3w3fS6yd7vUCDYHZrdklqkrAtHCgQDVCXTvLLw5m98SJVFTufEEaOdrEdI5JjWravzRl/FWPRIbEKZ2W/Zy6ZDs9RPufxaLJOev+jDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824849; c=relaxed/simple;
	bh=17Hjf6pqF6OfZhQH9hUzlN0vyI467KudVqFnhypz9cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKkk/0wVx2JlDj6gnfjI0SBsCu/uMsz3INTz3FdGu/u/X3A5QyrMNxPXDE880Necnm3IqGTgpwzQxzw6MMfU6yLmdU8W67eLb19AwPCNOjbcd8fNEbHsvZGn1Bwvjv69djGBCkalGATpvXLW4P/W7zZVCV9mHvLcWn+uYMuA5Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcT7molS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcT7molS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784D7C116B1;
	Tue, 11 Nov 2025 01:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824848;
	bh=17Hjf6pqF6OfZhQH9hUzlN0vyI467KudVqFnhypz9cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcT7molSR6OyW71cOGTSbCouopLVKMMsA6Focq88pgdb70cl6xSeEsFzmtekjxym7
	 t1DUdZ1u4tEPIFSGxbKcObmRiDdY875nU6vEO72B33ErbgEvmEKzeFpA7zOLEdQ97T
	 2OrdLGAFAa42iT2o6PWKUPJhHQIyzzTvc5VZMqbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 584/849] wifi: rtw89: renew a completion for each H2C command waiting C2H event
Date: Tue, 11 Nov 2025 09:42:34 +0900
Message-ID: <20251111004550.539684134@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit bc2a5a12fa6259e190c7edb03e63b28ab480101b ]

Logically before a waiting side which has already timed out turns the
atomic status back to idle, a completing side could still pass atomic
condition and call complete. It will make the following H2C commands,
waiting C2H events, get a completion unexpectedly early. Hence, renew
a completion for each H2C command waiting a C2H event.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250915065343.39023-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 49 ++++++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/core.h | 10 ++++-
 drivers/net/wireless/realtek/rtw89/fw.c   |  2 +
 3 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 2cebea10cb99b..9896c4ab7146b 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4860,37 +4860,74 @@ void rtw89_core_csa_beacon_work(struct wiphy *wiphy, struct wiphy_work *work)
 
 int rtw89_wait_for_cond(struct rtw89_wait_info *wait, unsigned int cond)
 {
-	struct completion *cmpl = &wait->completion;
+	struct rtw89_wait_response *prep;
 	unsigned long time_left;
 	unsigned int cur;
+	int err = 0;
 
 	cur = atomic_cmpxchg(&wait->cond, RTW89_WAIT_COND_IDLE, cond);
 	if (cur != RTW89_WAIT_COND_IDLE)
 		return -EBUSY;
 
-	time_left = wait_for_completion_timeout(cmpl, RTW89_WAIT_FOR_COND_TIMEOUT);
+	prep = kzalloc(sizeof(*prep), GFP_KERNEL);
+	if (!prep) {
+		err = -ENOMEM;
+		goto reset;
+	}
+
+	init_completion(&prep->completion);
+
+	rcu_assign_pointer(wait->resp, prep);
+
+	time_left = wait_for_completion_timeout(&prep->completion,
+						RTW89_WAIT_FOR_COND_TIMEOUT);
 	if (time_left == 0) {
-		atomic_set(&wait->cond, RTW89_WAIT_COND_IDLE);
-		return -ETIMEDOUT;
+		err = -ETIMEDOUT;
+		goto cleanup;
 	}
 
+	wait->data = prep->data;
+
+cleanup:
+	rcu_assign_pointer(wait->resp, NULL);
+	kfree_rcu(prep, rcu_head);
+
+reset:
+	atomic_set(&wait->cond, RTW89_WAIT_COND_IDLE);
+
+	if (err)
+		return err;
+
 	if (wait->data.err)
 		return -EFAULT;
 
 	return 0;
 }
 
+static void rtw89_complete_cond_resp(struct rtw89_wait_response *resp,
+				     const struct rtw89_completion_data *data)
+{
+	resp->data = *data;
+	complete(&resp->completion);
+}
+
 void rtw89_complete_cond(struct rtw89_wait_info *wait, unsigned int cond,
 			 const struct rtw89_completion_data *data)
 {
+	struct rtw89_wait_response *resp;
 	unsigned int cur;
 
+	guard(rcu)();
+
+	resp = rcu_dereference(wait->resp);
+	if (!resp)
+		return;
+
 	cur = atomic_cmpxchg(&wait->cond, cond, RTW89_WAIT_COND_IDLE);
 	if (cur != cond)
 		return;
 
-	wait->data = *data;
-	complete(&wait->completion);
+	rtw89_complete_cond_resp(resp, data);
 }
 
 void rtw89_core_ntfy_btc_event(struct rtw89_dev *rtwdev, enum rtw89_btc_hmsg event)
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2de9505c48ffc..460453e63f844 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4545,17 +4545,23 @@ struct rtw89_completion_data {
 	u8 buf[RTW89_COMPLETION_BUF_SIZE];
 };
 
+struct rtw89_wait_response {
+	struct rcu_head rcu_head;
+	struct completion completion;
+	struct rtw89_completion_data data;
+};
+
 struct rtw89_wait_info {
 	atomic_t cond;
-	struct completion completion;
 	struct rtw89_completion_data data;
+	struct rtw89_wait_response __rcu *resp;
 };
 
 #define RTW89_WAIT_FOR_COND_TIMEOUT msecs_to_jiffies(100)
 
 static inline void rtw89_init_wait(struct rtw89_wait_info *wait)
 {
-	init_completion(&wait->completion);
+	rcu_assign_pointer(wait->resp, NULL);
 	atomic_set(&wait->cond, RTW89_WAIT_COND_IDLE);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index e6f8fab799fc1..7a5d616f7a9b8 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -8679,6 +8679,8 @@ static int rtw89_h2c_tx_and_wait(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 {
 	int ret;
 
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
 	ret = rtw89_h2c_tx(rtwdev, skb, false);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to send h2c\n");
-- 
2.51.0



