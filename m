Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D776423A7C;
	Tue, 31 Mar 2026 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975234; cv=none; b=Z/SCplsTaKMTfLqoEKUv2YlsZKw2bN+Yc+UNZn466eULSxOL7nnX3aH8oAmEqxCsag4ekmoS1SahaC4OXPkpqdhEZS0Q1CtjO9H9QQ2FV3BsrScf3JLYgzaw1w+lsaTX0z0QOKZFo3tDDNNaR6qSWvMLmb0M5MipfU5eJ8aA6/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975234; c=relaxed/simple;
	bh=uW6r8if7xZ29/Qwg3OUdgVHvwlASKBGyaeiJ8sinMxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPsA+T5+O6Wn9FXtlDwvT4Iq50Jt83WrUC8RxFJcfvX9nQf+ECW4D9TyINMZQ2LwdVi3UwIxAZlWgijAtxkdamd2NDTMoiCWuyfzv7OAAo+08dS4SIJ2V/f1yc9XE5xITwDH5sKlLdzRfcEOsI1Kp7wRkQywhv9fOBR9r3xQZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9FWg/Vi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9FWg/Vi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FEFC19423;
	Tue, 31 Mar 2026 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975234;
	bh=uW6r8if7xZ29/Qwg3OUdgVHvwlASKBGyaeiJ8sinMxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9FWg/Vid3C5uLARfu0onRdw4BcC6ISLYwoOwFGQewkcCkmOfR2uAc2CSe3IJdZqQ
	 7Sbchl6PKvH7czrSkg5dZln1kGK9B2NwAbaivdwuCjHHoyEQrIa2Up5vXeQ/b9g/un
	 /44eJTQKLHpsqgkSQHYIcwqzdmWMvW7zZfnnD/7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.19 215/342] cpufreq: Dont skip cpufreq_frequency_table_cpuinfo()
Date: Tue, 31 Mar 2026 18:20:48 +0200
Message-ID: <20260331161806.889242832@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 8f13c0c6cb75cc4421d5a60fc060e9e6fd9d1097 upstream.

The commit 6db0f533d320 ("cpufreq: preserve freq_table_sorted
across suspend/hibernate") unintentionally made a change where
cpufreq_frequency_table_cpuinfo() isn't getting called anymore
for old policies getting re-initialized.

This leads to potentially invalid values of policy->max and
policy->cpuinfo_max_freq.

Fix the issue by reverting the original commit and adding the condition
for just the sorting function.

Fixes: 6db0f533d320 ("cpufreq: preserve freq_table_sorted across suspend/hibernate")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 6.19+ <stable@vger.kernel.org> # 6.19+
Link: https://patch.msgid.link/65ba5c45749267c82e8a87af3dc788b37a0b3f48.1773998611.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/cpufreq.c    |    9 +++------
 drivers/cpufreq/freq_table.c |    4 ++++
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1421,12 +1421,9 @@ static int cpufreq_policy_online(struct
 		 * If there is a problem with its frequency table, take it
 		 * offline and drop it.
 		 */
-		if (policy->freq_table_sorted != CPUFREQ_TABLE_SORTED_ASCENDING &&
-		    policy->freq_table_sorted != CPUFREQ_TABLE_SORTED_DESCENDING) {
-			ret = cpufreq_table_validate_and_sort(policy);
-			if (ret)
-				goto out_offline_policy;
-		}
+		ret = cpufreq_table_validate_and_sort(policy);
+		if (ret)
+			goto out_offline_policy;
 
 		/* related_cpus should at least include policy->cpus. */
 		cpumask_copy(policy->related_cpus, policy->cpus);
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -360,6 +360,10 @@ int cpufreq_table_validate_and_sort(stru
 	if (policy_has_boost_freq(policy))
 		policy->boost_supported = true;
 
+	if (policy->freq_table_sorted == CPUFREQ_TABLE_SORTED_ASCENDING ||
+	    policy->freq_table_sorted == CPUFREQ_TABLE_SORTED_DESCENDING)
+		return 0;
+
 	return set_freq_table_sorted(policy);
 }
 


