Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0AF196D8C;
	Thu,  6 Jun 2024 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683243; cv=none; b=NNLY9EtsZhgGBND7nNCHGbxr/iyvuXQpiNGAaBVuaOsHBtClWQlsfgo87RfMY7XnA1ANFRz+dnbDEcnQ2ygFNsLWIj2wJgilMSXpxDKLCd81XevcIIJKzgs+NGhRNeGShAsXllauGUxw3Fz8645K6sNqouVx4L1LC1yS5heZL9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683243; c=relaxed/simple;
	bh=qYpQ+EiC/NcIWVNUg49i4a09zzvIh6o/+kzQm3R6IOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYxMyy4dIZiHzWzoLf6Tsk585+P7s5pBsT+SpKblRpuzLMmxgMX+jow2/Z+KYhHp/m8EEB/2+YM5Ei0FhE8KsWk/IF+UqPGYfK0s1yL+aiDNh4l7xla7mtbS5sJuKgee0B/b6WKB+CySn50+k4odPIKXiVuV5FdQ1zTh+d7BSFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8SpoPJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8SpoPJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05DAC2BD10;
	Thu,  6 Jun 2024 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683243;
	bh=qYpQ+EiC/NcIWVNUg49i4a09zzvIh6o/+kzQm3R6IOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8SpoPJlGTAun/popmtL1boVtmpRBIVqOvZuNAf4SzHKXaJPYzOr4xtBDlewZgiPl
	 lUGYBXRLxitWqtz6Ymf0ncE2XQV7mfv56XejqMj6c+cse4sx0Le7bwafk46weQuxMC
	 1MDXCIOxXZ1bRTL1nDBAL3Lw/YXh5cwSKXAQMx1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lizhe <sensor1010@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/473] cpufreq: exit() callback is optional
Date: Thu,  6 Jun 2024 16:00:49 +0200
Message-ID: <20240606131703.905926470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit b8f85833c05730d631576008daaa34096bc7f3ce ]

The exit() callback is optional and shouldn't be called without checking
a valid pointer first.

Also, we must clear freq_table pointer even if the exit() callback isn't
present.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Fixes: 91a12e91dc39 ("cpufreq: Allow light-weight tear down and bring up of CPUs")
Fixes: f339f3541701 ("cpufreq: Rearrange locking in cpufreq_remove_dev()")
Reported-by: Lizhe <sensor1010@163.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 91efa23e0e8f3..04d89cf0d71df 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1619,10 +1619,13 @@ static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
 	 */
 	if (cpufreq_driver->offline) {
 		cpufreq_driver->offline(policy);
-	} else if (cpufreq_driver->exit) {
-		cpufreq_driver->exit(policy);
-		policy->freq_table = NULL;
+		return;
 	}
+
+	if (cpufreq_driver->exit)
+		cpufreq_driver->exit(policy);
+
+	policy->freq_table = NULL;
 }
 
 static int cpufreq_offline(unsigned int cpu)
@@ -1680,7 +1683,7 @@ static void cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	}
 
 	/* We did light-weight exit earlier, do full tear down now */
-	if (cpufreq_driver->offline)
+	if (cpufreq_driver->offline && cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
 	up_write(&policy->rwsem);
-- 
2.43.0



