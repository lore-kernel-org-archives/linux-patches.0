Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0F81519AA;
	Wed,  5 Feb 2025 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765031; cv=none; b=NIXdNOFyaoj0M+ShomLz3fnRRXKtdtjXe7dOXojsAA1WrRtnCcFt8vd0Hvjej2OI9RhCtDhahGK6CTk9exVAWqGTrRGEeB6h0/lRn8L3SsmU/GAmj+iOj+zPE5JT8iD0VtBkwV3vTah1jSBaqC3K4yK2URKxRtv/1cnZVxx+NQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765031; c=relaxed/simple;
	bh=/nMDwY/5duLAXEJZJvxotu2jYEUkpP2AllbUXFCC+cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q56+ZjcVV9HSb5iHqcto5/cAatT9G9z4nDyOsKh5JrS71OPKeSGgHdcqPS+kUOM6bw+2G6E84GQsup7ZbnJ9hm1Mns7WO1PXvqZpAeQTnzN8qU15Tj8Rg4GiZHO1mcsItZgHmYu2rW8Cx+vfTs9d4Yo7xfrusv44Ip6nP8zvxHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CiW7m5Nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CiW7m5Nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0F6C4CED6;
	Wed,  5 Feb 2025 14:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765030;
	bh=/nMDwY/5duLAXEJZJvxotu2jYEUkpP2AllbUXFCC+cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CiW7m5Nf6vQxACwoSvnTcPROkpYrxhPPi5vQ7z32LkOV4AgLwWLKVN/ZW7o6csHMc
	 19MG+MvnkLQOYr+lkfRxDb5Xqgndb1pwEeXe11cNkhyWAGeA54JeBNtK7vQb4xGO3v
	 I37SOTffb32SnKqlUaHNcyWG0dWZ7dqmuU5Uz2Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Sebastian <sobrus@gmail.com>
Subject: [PATCH 6.13 137/623] cpufreq/amd-pstate: Fix prefcore rankings
Date: Wed,  5 Feb 2025 14:37:59 +0100
Message-ID: <20250205134501.474614588@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit fd604ae6c261c5a56bb977ae99f875bbd7264a3f ]

commit 50a062a76200 ("cpufreq/amd-pstate: Store the boost numerator as
highest perf again") updated the value stored for highest perf to no longer
store the highest perf value but instead the boost numerator.

This is a fixed value for systems with preferred cores and not appropriate
for use ITMT rankings. Update the value used for ITMT rankings to be the
preferred core ranking.

Reported-and-tested-by: Sebastian <sobrus@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219640
Fixes: 50a062a76200 ("cpufreq/amd-pstate: Store the boost numerator as highest perf again")
Reviewed-by: Dhananjay Ugwekar <dhananjay.ugwekar@amd.com>
Link: https://lore.kernel.org/r/20250102141204.3413202-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 66e5dfc711c0c..f6d04eb40af94 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -802,7 +802,7 @@ static void amd_pstate_init_prefcore(struct amd_cpudata *cpudata)
 	 * sched_set_itmt_support(true) has been called and it is valid to
 	 * update them at any time after it has been called.
 	 */
-	sched_set_itmt_core_prio((int)READ_ONCE(cpudata->highest_perf), cpudata->cpu);
+	sched_set_itmt_core_prio((int)READ_ONCE(cpudata->prefcore_ranking), cpudata->cpu);
 
 	schedule_work(&sched_prefcore_work);
 }
-- 
2.39.5



