Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439411649B3;
	Mon, 29 Jan 2024 17:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548439; cv=none; b=QuOFEtkT7i261ylKpI5gmzohtppZuw+Bv5+0+7qRMhmgeQ5gNp5aUR7O7aeJANFQdBAwUAdYsz9JnHp8a04uqtrC57aPgcyLbeuFgAvnQOcEbUTPMkt83eDZD5P83lLA+EpcIwd+GCPwc75hQt75/7X/ilVEWFwo/hz/iw5iHvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548439; c=relaxed/simple;
	bh=JwNJfUmkAOYhu7yahD7VzzbF6r8+zQSOTG5NKGYiq7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThPbD4YhVaOUpGl+9Ar2L/14wu5IXHiFpehdcxW8lQDw/6JQCabp6Cg8VNQknQ/e9xKWBQgD8Qd9Mns3MOycNKC6OfkCLZNUUHPVGyL+I0z3/xjgfg9MgeBietfkuhObehBzy5vn3b5wpFLdUFYjCQISPMJiYMMWlGzQOk6UARA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozwNTQ/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozwNTQ/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C551C433C7;
	Mon, 29 Jan 2024 17:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548439;
	bh=JwNJfUmkAOYhu7yahD7VzzbF6r8+zQSOTG5NKGYiq7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozwNTQ/Lm+7SXKiQkS2Lm2l1lwfojay/2dIE7eUFFnVUGcnP69Chi1iGqc04SQVzb
	 dFdj8I7BnElkdu/9n2ffYx+9cnmlrQuE9g6j8zxIIn63AkoYZoiVGB7bCVsIcoCPL7
	 PszkJohLvVP7D1YcVrhymvZfdGjXWX+M0yQrvok8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.6 044/331] PM / devfreq: Fix buffer overflow in trans_stat_show
Date: Mon, 29 Jan 2024 09:01:48 -0800
Message-ID: <20240129170016.229333594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 08e23d05fa6dc4fc13da0ccf09defdd4bbc92ff4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
@@ -1688,7 +1688,7 @@ static ssize_t trans_stat_show(struct de
 			       struct device_attribute *attr, char *buf)
 {
 	struct devfreq *df = to_devfreq(dev);
-	ssize_t len;
+	ssize_t len = 0;
 	int i, j;
 	unsigned int max_state;
 
@@ -1697,7 +1697,7 @@ static ssize_t trans_stat_show(struct de
 	max_state = df->max_state;
 
 	if (max_state == 0)
-		return sprintf(buf, "Not Supported.\n");
+		return scnprintf(buf, PAGE_SIZE, "Not Supported.\n");
 
 	mutex_lock(&df->lock);
 	if (!df->stop_polling &&
@@ -1707,31 +1707,52 @@ static ssize_t trans_stat_show(struct de
 	}
 	mutex_unlock(&df->lock);
 
-	len = sprintf(buf, "     From  :   To\n");
-	len += sprintf(buf + len, "           :");
-	for (i = 0; i < max_state; i++)
-		len += sprintf(buf + len, "%10lu",
-				df->freq_table[i]);
+	len += scnprintf(buf + len, PAGE_SIZE - len, "     From  :   To\n");
+	len += scnprintf(buf + len, PAGE_SIZE - len, "           :");
+	for (i = 0; i < max_state; i++) {
+		if (len >= PAGE_SIZE - 1)
+			break;
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%10lu",
+				 df->freq_table[i]);
+	}
+	if (len >= PAGE_SIZE - 1)
+		return PAGE_SIZE - 1;
 
-	len += sprintf(buf + len, "   time(ms)\n");
+	len += scnprintf(buf + len, PAGE_SIZE - len, "   time(ms)\n");
 
 	for (i = 0; i < max_state; i++) {
+		if (len >= PAGE_SIZE - 1)
+			break;
 		if (df->freq_table[i] == df->previous_freq)
-			len += sprintf(buf + len, "*");
+			len += scnprintf(buf + len, PAGE_SIZE - len, "*");
 		else
-			len += sprintf(buf + len, " ");
-
-		len += sprintf(buf + len, "%10lu:", df->freq_table[i]);
-		for (j = 0; j < max_state; j++)
-			len += sprintf(buf + len, "%10u",
-				df->stats.trans_table[(i * max_state) + j]);
+			len += scnprintf(buf + len, PAGE_SIZE - len, " ");
+		if (len >= PAGE_SIZE - 1)
+			break;
+
+		len += scnprintf(buf + len, PAGE_SIZE - len, "%10lu:",
+				 df->freq_table[i]);
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
 


