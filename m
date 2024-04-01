Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C108C1E86C;
	Mon,  1 Apr 2024 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989581; cv=none; b=dv4IStNDV8o/ihyV0RhGT9JfBG1OfyP+HUw74MGMdlW0++gMJwIxN2Kv2gVBKazjow22T3zSrrSu94X2lfVMxot4EfStQJ4Typ+hiOCWsCjI1Ixgvt7wwP3R0250c4CVn1OFOLbavanWqszC6N3Dj+BadcW8aG3ccmFWAgGbRvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989581; c=relaxed/simple;
	bh=yQo07kxyelPTYQkQTF1ebvU/j7XkjCr9vwtpfycP1Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnP9CRLFD0iqJCPmsFq6wOPiMW4yiVZa/nZVgJ2x+ULiSAQVOmTmXH8oUZclqCfTKOwplIqJPmvKlv0k7C9j3+HAcV/Rpv9gpyuVErZ8bGg2NlZcOag1fmdafBy61yeE/zlDn8vsbJj4C1fkUcqGih9ge75G40HI2xGQOE/igAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCnzTOdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCnzTOdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DECC433C7;
	Mon,  1 Apr 2024 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989581;
	bh=yQo07kxyelPTYQkQTF1ebvU/j7XkjCr9vwtpfycP1Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCnzTOdA0vAbF/gX3/cODjGnRAjenquw8UjQw4xixskxsnIQwS9RVhYQKbKBk/sMP
	 B6Vff2ohTDLyBgkxlGMTvIRy6s9BWAQMXLMiN1MRqJ2z7yNG5KaeavfBuyZcZM/eaA
	 4jLKdllyIWsVUpUYEDoOw6tfAB63qSyYj0J5EGeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivnandan Kumar <quic_kshivnan@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/396] cpufreq: Limit resolving a frequency to policy min/max
Date: Mon,  1 Apr 2024 17:41:52 +0200
Message-ID: <20240401152549.802478287@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Shivnandan Kumar <quic_kshivnan@quicinc.com>

[ Upstream commit d394abcb12bb1a6f309c1221fdb8e73594ecf1b4 ]

Resolving a frequency to an efficient one should not transgress
policy->max (which can be set for thermal reason) and policy->min.

Currently, there is possibility where scaling_cur_freq can exceed
scaling_max_freq when scaling_max_freq is an inefficient frequency.

Add a check to ensure that resolving a frequency will respect
policy->min/max.

Cc: All applicable <stable@vger.kernel.org>
Fixes: 1f39fa0dccff ("cpufreq: Introducing CPUFREQ_RELATION_E")
Signed-off-by: Shivnandan Kumar <quic_kshivnan@quicinc.com>
[ rjw: Whitespace adjustment, changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cpufreq.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 71d186d6933a5..3a4cefb25ba61 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1021,6 +1021,18 @@ static inline int cpufreq_table_find_index_c(struct cpufreq_policy *policy,
 						   efficiencies);
 }
 
+static inline bool cpufreq_is_in_limits(struct cpufreq_policy *policy, int idx)
+{
+	unsigned int freq;
+
+	if (idx < 0)
+		return false;
+
+	freq = policy->freq_table[idx].frequency;
+
+	return freq == clamp_val(freq, policy->min, policy->max);
+}
+
 static inline int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 						 unsigned int target_freq,
 						 unsigned int relation)
@@ -1054,7 +1066,8 @@ static inline int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 		return 0;
 	}
 
-	if (idx < 0 && efficiencies) {
+	/* Limit frequency index to honor policy->min/max */
+	if (!cpufreq_is_in_limits(policy, idx) && efficiencies) {
 		efficiencies = false;
 		goto retry;
 	}
-- 
2.43.0



