Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B0E1CAA85;
	Wed, 19 Feb 2025 09:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955992; cv=none; b=iAkpIZOHStelwI6iEBSzAiBN+SaV5IYm9qtWXTVSL59aagJ4zmJm4SYmUqBcSukFCJMPE3b6e+hOcXVSewt0fE9VefpWbjEa2lzm2xQj/3lX6z65gamcWeH3McKuZAsZwuZr7ctF90wEYIA6P/J0L0oPhDdhhd11DKLS0UI05LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955992; c=relaxed/simple;
	bh=rYM5KOVQ9C60tAMZmg8/xTqKIwPnDRu3idP2qDZpyMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppQms05GCB1k60gpZHP0iOyKbwRBV5/7NOKj2KkThR+aJPRaD3Y5+79IWfCMtKqC+Tiu6RulPjSdfo5Tr88AVQX69bwZ+lV1veOuU7BQR6ERnHB7BqevI9s8JdGP7XpyIjrb5AxZ3kpEEB/guGmKz7yLnklodCZDkcDC1/rcTOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftnYotOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftnYotOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BB5C4CED1;
	Wed, 19 Feb 2025 09:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955992;
	bh=rYM5KOVQ9C60tAMZmg8/xTqKIwPnDRu3idP2qDZpyMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftnYotOZuOtVlR4iBq33iIBP3zOQjmlWADiWqNNftf0u0wHGMtCeg8OkkqfVuI5Q9
	 D0sIKeNH5CO+2y/j+ans321r3o+VNmtMrX1BR1TIpLNw1WHiXbzJTvBL4KCnJhv0S4
	 STvyEjmbao5D9uyfeFJGSaNjo/9IZ29/UaT9gqgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/578] OPP: Add dev_pm_opp_find_freq_exact_indexed()
Date: Wed, 19 Feb 2025 09:20:32 +0100
Message-ID: <20250219082654.003386645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit a5893928bb179d67ca1d44a8f66c990480ba541d ]

The indexed version of the API is added for other floor and ceil, add
the same for exact as well for completeness.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b44b9bc7cab2 ("OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c     | 28 ++++++++++++++++++++++++++++
 include/linux/pm_opp.h | 11 +++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 1483d10627fba..e1d9eddf26833 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -641,6 +641,34 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact);
 
+/**
+ * dev_pm_opp_find_freq_exact_indexed() - Search for an exact freq for the
+ *					 clock corresponding to the index
+ * @dev:	Device for which we do this operation
+ * @freq:	frequency to search for
+ * @index:	Clock index
+ * @available:	true/false - match for available opp
+ *
+ * Search for the matching exact OPP for the clock corresponding to the
+ * specified index from a starting freq for a device.
+ *
+ * Return: matching *opp , else returns ERR_PTR in case of error and should be
+ * handled using IS_ERR. Error return values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
+ *
+ * The callers are required to call dev_pm_opp_put() for the returned OPP after
+ * use.
+ */
+struct dev_pm_opp *
+dev_pm_opp_find_freq_exact_indexed(struct device *dev, unsigned long freq,
+				   u32 index, bool available)
+{
+	return _find_key_exact(dev, freq, index, available, _read_freq, NULL);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_exact_indexed);
+
 static noinline struct dev_pm_opp *_find_freq_ceil(struct opp_table *opp_table,
 						   unsigned long *freq)
 {
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index a13a1705df57b..23e4e4eaaa427 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -124,6 +124,10 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 					      unsigned long freq,
 					      bool available);
 
+struct dev_pm_opp *
+dev_pm_opp_find_freq_exact_indexed(struct device *dev, unsigned long freq,
+				   u32 index, bool available);
+
 struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					      unsigned long *freq);
 
@@ -268,6 +272,13 @@ static inline struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct dev_pm_opp *
+dev_pm_opp_find_freq_exact_indexed(struct device *dev, unsigned long freq,
+				   u32 index, bool available)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					unsigned long *freq)
 {
-- 
2.39.5



