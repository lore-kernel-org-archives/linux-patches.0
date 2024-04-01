Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEB5BA3F;
	Mon,  1 Apr 2024 17:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990866; cv=none; b=o21oxdMUgMFGSYZX61NilOjQz39LT4ebK+mEYlMhTHR9sGFIFwom/56oyLLJerihBaDHtxN5oqSbVC1o0mKaSSc+GZQ+tpaORB0XWfaaL/xAR2CbSTOZhdhadRJcSi5qpYoImSH/X/5PHvPq+bxLQZdCwqyILh6HSYfR1wOF6P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990866; c=relaxed/simple;
	bh=RFmApErE2ViLL9EusVr5fnVSCrkiFaQddYIlpN0dVTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xjd51jYUVawlHMx7232SdF5CS3iY3YWiSjfpXyEOrt56195/6cz4ypj3H5DDraiGErTvTBWiMvbNBybMsvrB1gMyhX40/pMwI70MvqB4aU5haZ/FYynFnxHISrpZgmEzFD0fM2rGcuXNuymF018ryBfg3U5sDacElaxZhfayPcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1IZRFAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1IZRFAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86BDC433C7;
	Mon,  1 Apr 2024 17:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990866;
	bh=RFmApErE2ViLL9EusVr5fnVSCrkiFaQddYIlpN0dVTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1IZRFAKQK1qLxuuHCv8EUF9MyiKcONR9GupRyaM5kVA9N9NV/bUazjK7vtqT52XB
	 Evnm2d7E7EoestebTylrGCpspOvJx+cSZIMoc9VEPHTmXFqHM5mNMb2zWMvMMMF21K
	 DLcutjzHiRB5Y3vnn0me4/FXLf8pe+swP4XhD/ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivnandan Kumar <quic_kshivnan@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/272] cpufreq: Limit resolving a frequency to policy min/max
Date: Mon,  1 Apr 2024 17:44:01 +0200
Message-ID: <20240401152532.115646528@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index d5595d57f4e53..9d208648c84d5 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -1023,6 +1023,18 @@ static inline int cpufreq_table_find_index_c(struct cpufreq_policy *policy,
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
@@ -1056,7 +1068,8 @@ static inline int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
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



