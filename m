Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCD91C701E;
	Wed, 19 Feb 2025 08:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955400; cv=none; b=lZH8hXp1z3ABLPjX83wvBoEidSKfcFOnjnl7MJD4AtmBTdMYqsWCBT9yLWtRv7/JgE53W8gutvf/KtH1DYc2uDTeyiMncOjoz2GZWRmudC21v+XY0SfI8UXd9HQKhsroupg4PhXzbahGNFoy5uWREjh5/Imorh5ey6q4qtf3Bn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955400; c=relaxed/simple;
	bh=ngeCIVUCeox26oKewiYDU5I1LwnZM4ZIB99L8SCje70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nasBLUit3uwD4j5azsiwLS1CxhjFdNZk/vPavCJThoDf4EpY6KRaDHiMdhUHrqwBE5KN/PY/OcQdaofrojIC0owR6QC7YftK/Q7jTKLgcoQHh8iIThTVBG5bdmeRz3wLbkNfyKuPoQF7Y1wvCOK5zDu2XIseDRIVShCO10Emuf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gkp50NJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gkp50NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99ADC4CED1;
	Wed, 19 Feb 2025 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955400;
	bh=ngeCIVUCeox26oKewiYDU5I1LwnZM4ZIB99L8SCje70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gkp50NJKOAOiNfIk5kKWOXfBx+FRxrYjHGgZLS4xhtxcnSZXPrpQ7CQk8Zz61tGH
	 sAlyNX7PyI8Qjq5igWJuMYRwyplThc3cOPTgMrq9+auc3VBi7qMJ0xjWznl0YPP42k
	 hK0DAiH+6MfiZuZzAiKZNN2VHik6Qwulo+6qX3Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 224/230] cpufreq/amd-pstate: Remove the goto label in amd_pstate_update_limits
Date: Wed, 19 Feb 2025 09:29:01 +0100
Message-ID: <20250219082610.451028234@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>

commit d364eee14c682b141f4667efc3c65191339d88bd upstream.

Scope based guard/cleanup macros should not be used together with goto
labels. Hence, remove the goto label.

Fixes: 6c093d5a5b73 ("cpufreq/amd-pstate: convert mutex use to guard()")
Signed-off-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250205112523.201101-2-dhananjay.ugwekar@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -796,8 +796,10 @@ static void amd_pstate_update_limits(uns
 	guard(mutex)(&amd_pstate_driver_lock);
 
 	ret = amd_get_highest_perf(cpu, &cur_high);
-	if (ret)
-		goto free_cpufreq_put;
+	if (ret) {
+		cpufreq_cpu_put(policy);
+		return;
+	}
 
 	prev_high = READ_ONCE(cpudata->prefcore_ranking);
 	highest_perf_changed = (prev_high != cur_high);
@@ -807,8 +809,6 @@ static void amd_pstate_update_limits(uns
 		if (cur_high < CPPC_MAX_PERF)
 			sched_set_itmt_core_prio((int)cur_high, cpu);
 	}
-
-free_cpufreq_put:
 	cpufreq_cpu_put(policy);
 
 	if (!highest_perf_changed)


