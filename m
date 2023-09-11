Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E87711710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E8DC433C7;
	Mon, 11 Sep 2023 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445985;
	bh=17aA590RUILvCW7ZTee6V8o1xBhGEfyQL16soezPhLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Jf9npmyw6tUiWYC3nSIdNe5D5rQy91js6LLdv6HtpIDCH5pdpfpnYxV3ZyKvT0+
	 G+hWGMKMxAPTOOwCC8OgQHLgUERRvkEHD16KmNcpeb0WstYEs91ePCLMxyDaFQukr1
	 2dBMnf6oj9FNYS8iAoygArn5lIgnzH0QuDpxCltY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chang <liaochang1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 515/600] cpufreq: Fix the race condition while updating the transition_task of policy
Date: Mon, 11 Sep 2023 15:49:08 +0200
Message-ID: <20230911134648.814056566@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit 61bfbf7951ba561dcbdd5357702d3cbc2d447812 ]

The field 'transition_task' of policy structure is used to track the
task which is performing the frequency transition. Using this field to
print a warning once detect a case where the same task is calling
_begin() again before completing the preivous frequency transition via
the _end().

However, there is a potential race condition in _end() and _begin() APIs
while updating the field 'transition_task' of policy, the scenario is
depicted below:

             Task A                            Task B

        /* 1st freq transition */
        Invoke _begin() {
                ...
                ...
        }
                                        /* 2nd freq transition */
                                        Invoke _begin() {
                                                ... //waiting for A to
                                                ... //clear
                                                ... //transition_ongoing
                                                ... //in _end() for
                                                ... //the 1st transition
                                                        |
        Change the frequency                            |
                                                        |
        Invoke _end() {                                 |
                ...                                     |
                ...                                     |
                transition_ongoing = false;             V
                                                transition_ongoing = true;
                                                transition_task = current;
                transition_task = NULL;
                ... //A overwrites the task
                ... //performing the transition
                ... //result in error warning.
        }

To fix this race condition, the transition_lock of policy structure is
now acquired before updating policy structure in _end() API. Which ensure
that only one task can update the 'transition_task' field at a time.

Link: https://lore.kernel.org/all/b3c61d8a-d52d-3136-fbf0-d1de9f1ba411@huawei.com/
Fixes: ca654dc3a93d ("cpufreq: Catch double invocations of cpufreq_freq_transition_begin/end")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 285ba51b31f60..c8912756fc06d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -450,8 +450,10 @@ void cpufreq_freq_transition_end(struct cpufreq_policy *policy,
 			    policy->cur,
 			    policy->cpuinfo.max_freq);
 
+	spin_lock(&policy->transition_lock);
 	policy->transition_ongoing = false;
 	policy->transition_task = NULL;
+	spin_unlock(&policy->transition_lock);
 
 	wake_up(&policy->transition_wait);
 }
-- 
2.40.1



