Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2C446AC;
	Mon,  1 Apr 2024 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988040; cv=none; b=jC5E1hHEyGbfg8pBO69LjjRgq7QDBVehJDaKaxUbCCimOvVraNNpd+0eRoL0B8sg15jwG4Q6Ig737P8N0obXwvylXmYt8aDpaLE5XtTu5heWGWb26RAST+naIydkcUq786MaYQg00sNSDV50vfpU87FM6ih72n8RpcUOqH+bzZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988040; c=relaxed/simple;
	bh=UZTgFgDBltt43wF76bSkWnFcOe210tMdqxurbMak2po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xebgy2/T0wvduvCMhvBgn8x0DixPxSSsIm0mbl+f3EZamxAQ50nVY3YyuX2dK1CrCkCozU4Uy52rM9ToQJgmalKcwPOWKyHB+Dp7EHzIl2MP169/tBfd/KHwALmmZFzULf8XfmAqre2H+a+l1OkVXcMWnVI2MH0uRtY2rov4Da0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xw1vFLhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xw1vFLhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DD6C43390;
	Mon,  1 Apr 2024 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988040;
	bh=UZTgFgDBltt43wF76bSkWnFcOe210tMdqxurbMak2po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xw1vFLhea8YB9X6LWIj3foExmsSo8tuReYLYGR7NUxAyOy9o38n67lk/8gWSOOPNv
	 5IPrmplRd0P3WsR4TwqqOq+ClwdJnb9u/ofKVD6sNCdHJLlJBqrVgsug6F2nVDfIn/
	 vTzFYjKLurSQ3rSwaO0NgUdTPd8jLq2mxvDq/1bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivnandan Kumar <quic_kshivnan@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 066/432] cpufreq: Limit resolving a frequency to policy min/max
Date: Mon,  1 Apr 2024 17:40:53 +0200
Message-ID: <20240401152555.094150104@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1c5ca92a0555f..90f8bd1736a2c 100644
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



