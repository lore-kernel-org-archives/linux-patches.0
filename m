Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4694D2940B;
	Tue, 11 Nov 2025 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824090; cv=none; b=SrAz7DmLsEHHclPpG0QBjlD2UG10qAISl7dOm8gNbn0qwxeanQppG7swLtSXq+/tphMZyJNxVD6YVHdqHxekuxtWsXMpfCPjyIY7GEJ+qLrY5mkoJkF6AaGZ+v9tpCxxV/6RIew/9WKqCssZVCgf/BGkKXAKozDzrLpVaf3OoxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824090; c=relaxed/simple;
	bh=SZvr4YLJH5egMhX5ICy+UhYIGCoDqfw4ZLw3l6DJcF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1tJxbcSuciQZ6Ge7jJrDqEbw7NeeAFhZhfO/THfa9yWl93n8KptSQtd2bECECi/lgBHWswdHbJztydIjMWpF9ZujPH6PnILp5gR9Y+Ao+r8oL94dJj+ZXF7mbeTFl+iawuJphWxRFEOzzmb1Aqc+Rc05g7/46VX9VexSzlgot0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atjWB4pv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atjWB4pv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D746BC16AAE;
	Tue, 11 Nov 2025 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824090;
	bh=SZvr4YLJH5egMhX5ICy+UhYIGCoDqfw4ZLw3l6DJcF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atjWB4pvwpX0R44Qy86Tj1in0CQMXQ04J5NB5nEKGJM+hT7lzFn3aO5FfEG1gJQlY
	 I5cQKDTRnxeNjr3/E6J5wR3HmEw3OYWtt3ENbMIn81IPILjWKox0H+EZk5ogbXyR20
	 uJWMv2xBTDYVYyTqSg/cZmdQmY34R8NUYxVhOQLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/565] wifi: rtw89: renew a completion for each H2C command waiting C2H event
Date: Tue, 11 Nov 2025 09:44:01 +0900
Message-ID: <20251111004535.530919454@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3584445b27387..faa764d5c1a01 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4318,37 +4318,74 @@ void rtw89_core_update_beacon_work(struct work_struct *work)
 
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
index 7be32b83d4d64..36ba2ca255bb0 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -4391,17 +4391,23 @@ struct rtw89_completion_data {
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
index 7894e1a569a2c..ae2c4ff74531a 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7446,6 +7446,8 @@ static int rtw89_h2c_tx_and_wait(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 {
 	int ret;
 
+	lockdep_assert_wiphy(rtwdev->hw->wiphy);
+
 	ret = rtw89_h2c_tx(rtwdev, skb, false);
 	if (ret) {
 		rtw89_err(rtwdev, "failed to send h2c\n");
-- 
2.51.0



