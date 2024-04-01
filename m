Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B12481C6;
	Mon,  1 Apr 2024 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986785; cv=none; b=KTza+YZGOVq8/PFJyXckuVdrRALJkWqUiaisi4W+TpgMuQePaxMAM6rj9VK/dYxEcjuvJIch6YUde/VuP0/+/cG+6H02OJwb9ftR+qAJcH1wMj73Z6HSZXHPJd7g2NSzA6LBrCwnMXKIAcgkrhMm6odGGA7puOUhC8kqrap1aKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986785; c=relaxed/simple;
	bh=hRug/QPMx+aqn3HedK8WQ90rozSa7LGLvHTJu/jlIkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueeQTwO8AlTkiD76DoVq502lrdeGZFtZpvoYzJhjJ1gxrSsoXBKXg5gyvKnjRIkXSwPFc9gkL7I9jufZ2t+q81pUdJcWlN5iOSMvkVYQdKbl2VzhkmVUsZ/Zq9LaDbZAOgqkyKpMt4TU08YQp454pBIumR9Xb+E3WZAnIPkwB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElDgd4OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElDgd4OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B575C433F1;
	Mon,  1 Apr 2024 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986785;
	bh=hRug/QPMx+aqn3HedK8WQ90rozSa7LGLvHTJu/jlIkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElDgd4OQmioq486Sl60KsQhOg7tkZvTzXHz7ZuuwDUH4HLQSao6AnxbFQnST8JhPI
	 puw1UCt8mjLIK+ngR6ugWAu3+MVhsHPiVHe1zBDzZd9Fovr8neDOKikC/odPFduqZl
	 ifOh3CtWGMk+alyFDqs3Jzc5MM3i7ACbyydtqhcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivnandan Kumar <quic_kshivnan@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 067/399] cpufreq: Limit resolving a frequency to policy min/max
Date: Mon,  1 Apr 2024 17:40:33 +0200
Message-ID: <20240401152551.186820594@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index afda5f24d3ddc..320fab7d2e940 100644
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



