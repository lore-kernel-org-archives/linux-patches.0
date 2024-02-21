Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACB479DAB;
	Wed, 21 Feb 2024 13:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522233; cv=none; b=X5fGe5x43A//hK+Yqqc4pqJkQGTRuYMQXsTGWem26d+zZRM/euG57ahN5Jat6nU4yAO+xx93sxtNCHBCNMmM0YRLhhcvVaQzhpyJlwLms3gdc0fJpG4VgbU7DNHbZuISg4d300E9TZYLXtLQXzFzSFyBC62u8UAU9ZYTYOHalQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522233; c=relaxed/simple;
	bh=S0NnrlO3UpWjqIsyP4x1dcIF5OEjRb0Y0RNtXnonzjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0cFRVPNC5MV3Df7oNDyX+zbqyUq20vpd2113/A7gis7O1NJP189msQccqkHJ00Dd6xiGSwJ/LbafoRtzVFFL5hsXChxaEdGI3awdXyWFeOvriOUAGEHLTrBYRoPRABpKekMvh0Y/02L1Jnl2qwyHwBwqLSfw7V+jBj2KL3CIqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LC1gR2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LC1gR2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86961C433B1;
	Wed, 21 Feb 2024 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522233;
	bh=S0NnrlO3UpWjqIsyP4x1dcIF5OEjRb0Y0RNtXnonzjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LC1gR2ku28r1rHcYviKF45nq8gQke5nIh31M8WNZT6OW3u5PRb/sXlls2PM0mw54
	 h41iAcHoECLks9iK2tU9vyksAnZ5Gh1masrJriFhn/32E5llkPPzkzhE5OsBAUz3jy
	 lQ11dcgAtumzxLGIoiJtir5KC2xOxi99WF30QIKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/476] PM / devfreq: Fix buffer overflow in trans_stat_show
Date: Wed, 21 Feb 2024 14:02:40 +0100
Message-ID: <20240221130011.999916709@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 08e23d05fa6dc4fc13da0ccf09defdd4bbc92ff4 ]

Fix buffer overflow in trans_stat_show().

Convert simple snprintf to the more secure scnprintf with size of
PAGE_SIZE.

Add condition checking if we are exceeding PAGE_SIZE and exit early from
loop. Also add at the end a warning that we exceeded PAGE_SIZE and that
stats is disabled.

Return -EFBIG in the case where we don't have enough space to write the
full transition table.

Also document in the ABI that this function can return -EFBIG error.

Link: https://lore.kernel.org/all/20231024183016.14648-2-ansuelsmth@gmail.com/
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218041
Fixes: e552bbaf5b98 ("PM / devfreq: Add sysfs node for representing frequency transition information.")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-class-devfreq |    3 +
 drivers/devfreq/devfreq.c                     |   59 +++++++++++++++++---------
 2 files changed, 43 insertions(+), 19 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -52,6 +52,9 @@ Description:
 
 			echo 0 > /sys/class/devfreq/.../trans_stat
 
+		If the transition table is bigger than PAGE_SIZE, reading
+		this will return an -EFBIG error.
+
 What:		/sys/class/devfreq/.../available_frequencies
 Date:		October 2012
 Contact:	Nishanth Menon <nm@ti.com>
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1653,7 +1653,7 @@ static ssize_t trans_stat_show(struct de
 			       struct device_attribute *attr, char *buf)
 {
 	struct devfreq *df = to_devfreq(dev);
-	ssize_t len;
+	ssize_t len = 0;
 	int i, j;
 	unsigned int max_state;
 
@@ -1662,7 +1662,7 @@ static ssize_t trans_stat_show(struct de
 	max_state = df->profile->max_state;
 
 	if (max_state == 0)
-		return sprintf(buf, "Not Supported.\n");
+		return scnprintf(buf, PAGE_SIZE, "Not Supported.\n");
 
 	mutex_lock(&df->lock);
 	if (!df->stop_polling &&
@@ -1672,33 +1672,54 @@ static ssize_t trans_stat_show(struct de
 	}
 	mutex_unlock(&df->lock);
 
-	len = sprintf(buf, "     From  :   To\n");
-	len += sprintf(buf + len, "           :");
-	for (i = 0; i < max_state; i++)
-		len += sprintf(buf + len, "%10lu",
-				df->profile->freq_table[i]);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "     From  :   To\n");
+	len += scnprintf(buf + len, PAGE_SIZE - len, "           :");
+	for (i = 0; i < max_state; i++) {
+		if (len >= PAGE_SIZE - 1)
+			break;
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%10lu",
+				 df->profile->freq_table[i]);
+	}
+	if (len >= PAGE_SIZE - 1)
+		return PAGE_SIZE - 1;
 
-	len += sprintf(buf + len, "   time(ms)\n");
+	len += scnprintf(buf + len, PAGE_SIZE - len, "   time(ms)\n");
 
 	for (i = 0; i < max_state; i++) {
+		if (len >= PAGE_SIZE - 1)
+			break;
 		if (df->profile->freq_table[i]
 					== df->previous_freq) {
-			len += sprintf(buf + len, "*");
+			len += scnprintf(buf + len, PAGE_SIZE - len, "*");
 		} else {
-			len += sprintf(buf + len, " ");
+			len += scnprintf(buf + len, PAGE_SIZE - len, " ");
 		}
-		len += sprintf(buf + len, "%10lu:",
-				df->profile->freq_table[i]);
-		for (j = 0; j < max_state; j++)
-			len += sprintf(buf + len, "%10u",
-				df->stats.trans_table[(i * max_state) + j]);
+		if (len >= PAGE_SIZE - 1)
+			break;
+
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%10lu:",
+				 df->profile->freq_table[i]);
+		for (j = 0; j < max_state; j++) {
+			if (len >= PAGE_SIZE - 1)
+				break;
+			len += scnprintf(buf + len, PAGE_SIZE - len, "%10u",
+					 df->stats.trans_table[(i * max_state) + j]);
+		}
+		if (len >= PAGE_SIZE - 1)
+			break;
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%10llu\n", (u64)
+				 jiffies64_to_msecs(df->stats.time_in_state[i]));
+	}
 
-		len += sprintf(buf + len, "%10llu\n", (u64)
-			jiffies64_to_msecs(df->stats.time_in_state[i]));
+	if (len < PAGE_SIZE - 1)
+		len += scnprintf(buf + len, PAGE_SIZE - len, "Total transition : %u\n",
+				 df->stats.total_trans);
+
+	if (len >= PAGE_SIZE - 1) {
+		pr_warn_once("devfreq transition table exceeds PAGE_SIZE. Disabling\n");
+		return -EFBIG;
 	}
 
-	len += sprintf(buf + len, "Total transition : %u\n",
-					df->stats.total_trans);
 	return len;
 }
 


