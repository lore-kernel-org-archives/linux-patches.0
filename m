Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547941DF974;
	Wed, 19 Feb 2025 09:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955986; cv=none; b=FXC3hkRRU+kDGBlZablspRWxzx/x4mA48lGiYT/YGhrsV3heqVZFO2Vtih7ljWEYelOhjvSEbc4CI28A9bQoG1ydwMYtUYeGeE4R67Fj3S8lm+tPjaqPlEs3bcUhtshNKy9x0bmYXT98tVcACI9w+f15HUmcbuvP0NJGZaSYhzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955986; c=relaxed/simple;
	bh=Irxe/s1bKTcZoKP9+LGatcIqn7ifHX+PP7zYiV+a1dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt2jNRi4NJk/vTULH47xPEhhNQzw/+bc3HmcYKsFs/neOO9VwUibUn6hTsWgTNEC1NYjlnXsnDSv/5mwWOHqBdxMXGcJ1nIvJoufZe6ZWFhr5b58qwdb4kHerfitW4DSss0t6U+9U8v7xHOll1OsxlkCyhM1zUgu4v9m2gXyAK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnGBr/iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnGBr/iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D424DC4CED1;
	Wed, 19 Feb 2025 09:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955986;
	bh=Irxe/s1bKTcZoKP9+LGatcIqn7ifHX+PP7zYiV+a1dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnGBr/iYzWQp58yUHXnZBPMwRXrjP2ACrdoPzW6kYqTySn0kt6DI45945PY3wpeWm
	 ujob21c8B547BYxWqaTJHb7WeZg7UitJjhDXVaROLIUqE01TUddawv/he9qvANedTv
	 39rwDL7gaGdQxWQpyMbogBvt2+huZ2jTlrHTYwMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/578] OPP: Introduce dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs
Date: Wed, 19 Feb 2025 09:20:30 +0100
Message-ID: <20250219082653.924058832@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 142e17c1c2b48e3fb4f024e62ab6dee18f268694 ]

In the case of devices with multiple clocks, drivers need to specify the
clock index for the OPP framework to find the OPP corresponding to the
floor/ceil of the supplied frequency. So let's introduce the two new APIs
accepting the clock index as an argument.

These APIs use the exising _find_key_ceil() helper by supplying the clock
index to it.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
[ Viresh: Rearranged definitions in pm_opp.h ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: b44b9bc7cab2 ("OPP: fix dev_pm_opp_find_bw_*() when bandwidth table not initialized")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c     | 56 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm_opp.h | 18 ++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 71d3e3ba909a3..8775f9d71f90a 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -653,6 +653,34 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil);
 
+/**
+ * dev_pm_opp_find_freq_ceil_indexed() - Search for a rounded ceil freq for the
+ *					 clock corresponding to the index
+ * @dev:	Device for which we do this operation
+ * @freq:	Start frequency
+ * @index:	Clock index
+ *
+ * Search for the matching ceil *available* OPP for the clock corresponding to
+ * the specified index from a starting freq for a device.
+ *
+ * Return: matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
+ *
+ * The callers are required to call dev_pm_opp_put() for the returned OPP after
+ * use.
+ */
+struct dev_pm_opp *
+dev_pm_opp_find_freq_ceil_indexed(struct device *dev, unsigned long *freq,
+				  u32 index)
+{
+	return _find_key_ceil(dev, freq, index, true, _read_freq, NULL);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil_indexed);
+
 /**
  * dev_pm_opp_find_freq_floor() - Search for a rounded floor freq
  * @dev:	device for which we do this operation
@@ -678,6 +706,34 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 
+/**
+ * dev_pm_opp_find_freq_floor_indexed() - Search for a rounded floor freq for the
+ *					  clock corresponding to the index
+ * @dev:	Device for which we do this operation
+ * @freq:	Start frequency
+ * @index:	Clock index
+ *
+ * Search for the matching floor *available* OPP for the clock corresponding to
+ * the specified index from a starting freq for a device.
+ *
+ * Return: matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
+ *
+ * The callers are required to call dev_pm_opp_put() for the returned OPP after
+ * use.
+ */
+struct dev_pm_opp *
+dev_pm_opp_find_freq_floor_indexed(struct device *dev, unsigned long *freq,
+				   u32 index)
+{
+	return _find_key_floor(dev, freq, index, true, _read_freq, NULL);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor_indexed);
+
 /**
  * dev_pm_opp_find_level_exact() - search for an exact level
  * @dev:		device for which we do this operation
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 3821f50b9b89c..2617f2c51f29d 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -125,9 +125,15 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					      unsigned long *freq);
 
+struct dev_pm_opp *dev_pm_opp_find_freq_floor_indexed(struct device *dev,
+						      unsigned long *freq, u32 index);
+
 struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					     unsigned long *freq);
 
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil_indexed(struct device *dev,
+						     unsigned long *freq, u32 index);
+
 struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
 					       unsigned int level);
 
@@ -261,12 +267,24 @@ static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct dev_pm_opp *
+dev_pm_opp_find_freq_floor_indexed(struct device *dev, unsigned long *freq, u32 index)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct dev_pm_opp *
+dev_pm_opp_find_freq_ceil_indexed(struct device *dev, unsigned long *freq, u32 index)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
 					unsigned int level)
 {
-- 
2.39.5



