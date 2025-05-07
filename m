Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9607C1FF5EC;
	Wed,  7 May 2025 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643974; cv=none; b=EwL7wRor8VCpD+569ehOf0GsXH3ZKzb8vUSXiaJ8xEjq9g88cSfi5XwuzJDyyNtNclSKYVdRAe+C5qVZQkwkzVLkNVK4FqThQXpGFeCNvdjj5Ts9QPtsOGEe5+VgM4fK1FxMkBvX+UdnNshP2N2lBH11VySM/YQiFzQOCMNdX1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643974; c=relaxed/simple;
	bh=41LGJQvqxI5N3x86JGozd+uGpSE42mijvbwCGEKfdnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxaxJPnrPzNgAx86ti9eq/bExWv0OFW0lr6ht+bfypdlSHkMts9a11tTPzpAREa0/UXHNuGRsKCm5up1eeQTboAd4rHlEckKUL4bar5yGaiVjb7yPZ181mfHl/CyHis2Sihw/iBzMHp5usjtv64Lb36PNmjE2FulQrUiqx9dTv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdUG3kNr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdUG3kNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046C9C4CEE2;
	Wed,  7 May 2025 18:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643974;
	bh=41LGJQvqxI5N3x86JGozd+uGpSE42mijvbwCGEKfdnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdUG3kNrc3VK5kUxLufnRk7KVGYk+AV3nUP81ndfpb1yGtXINqSLmZrs52mLQy+eS
	 5MVF88QCcZh/OKHalTfF/cksHTMX1MIpsX4o63YEZM8UnCCJn9SwAKn6i6fr0zNH0w
	 6rS0R5C2AGzmqEABR78ff8lxBe+6ps7g45XbhYw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 077/183] cpufreq: Introduce policy->boost_supported flag
Date: Wed,  7 May 2025 20:38:42 +0200
Message-ID: <20250507183827.807134068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 1f7d1bab50e6ae517f8b6699e56d709d61ae13e5 ]

It is possible to have a scenario where not all cpufreq policies support
boost frequencies. And letting sysfs (or other parts of the kernel)
enable boost feature for that policy isn't correct.

Add a new flag, boost_supported, which will be set to true by the
cpufreq core only if the freq table contains valid boost frequencies.

Some cpufreq drivers though don't have boost frequencies in the
freq-table, they can set this flag from their ->init() callbacks.

Once all the drivers are updated to set the flag correctly, we can check
it before enabling boost feature for a policy.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: 3d59224947b0 ("cpufreq: ACPI: Re-sync CPU boost state on system resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/freq_table.c | 4 ++++
 include/linux/cpufreq.h      | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 178e17009a16e..9db21ffc11979 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -367,6 +367,10 @@ int cpufreq_table_validate_and_sort(struct cpufreq_policy *policy)
 	if (ret)
 		return ret;
 
+	/* Driver's may have set this field already */
+	if (policy_has_boost_freq(policy))
+		policy->boost_supported = true;
+
 	return set_freq_table_sorted(policy);
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a604c54ae44da..73024830bd730 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -144,6 +144,9 @@ struct cpufreq_policy {
 	/* Per policy boost enabled flag. */
 	bool			boost_enabled;
 
+	/* Per policy boost supported flag. */
+	bool			boost_supported;
+
 	 /* Cached frequency lookup from cpufreq_driver_resolve_freq. */
 	unsigned int cached_target_freq;
 	unsigned int cached_resolved_idx;
-- 
2.39.5



