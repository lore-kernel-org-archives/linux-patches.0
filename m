Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C851487DA;
	Thu, 13 Jun 2024 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279797; cv=none; b=kPdWS+6hNCdWCWYVicTa/GxOGoao3xvPMG29eFFXzXywVviMZnB+WtGXL+DWADXeNd2/+/QngeDAQYBa9msiKLmquINAErLZMJBeFkh3dsG8ftd+CIEvEdLm3fmM8X7UwxjwbhNYLs9NMx1nt2GVCyzDtI+a1MLpJBvQTY+Qaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279797; c=relaxed/simple;
	bh=WA0PjgWwKx7kVApIphAj20DnD+Vmhm4KHCYjbZaK1RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBk4cS8aXETebbTGZwYXlYNtfmsngizGuBIfryJ5P0I0YT89WBnRuSVeHuXjlcfvcgtvOoiuEcoP+tZl+euPDTBQumFd6pEFHTlqTrJJY9KnnRZCk/qXN7Row9s0pjN2SkHx6L1SMT8ILoeRoxqng0aZ23jDSNiL98k5p2gtPUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duQ7UJmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duQ7UJmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B158BC4AF1A;
	Thu, 13 Jun 2024 11:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279797;
	bh=WA0PjgWwKx7kVApIphAj20DnD+Vmhm4KHCYjbZaK1RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duQ7UJmPsB1DHG7ehJSKX01yEqDhCSSktWsR+OlxJ5vCxtyWSuthu5Qbom9Dj6wbW
	 DWWrmnslNSEeNCl9VaJB6Mn3iGla5jPisgE9HOBxeVp610aDBrMp1+aNxyT6ETEQJ6
	 mfJynLcmieJtlTJTQyfduUPpC+V7K76hLlmGt4oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lizhe <sensor1010@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/202] cpufreq: exit() callback is optional
Date: Thu, 13 Jun 2024 13:32:17 +0200
Message-ID: <20240613113229.281377839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e727282f56963..c79bbd8cc125c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1600,10 +1600,13 @@ static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
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
@@ -1653,7 +1656,7 @@ static void cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	}
 
 	/* We did light-weight exit earlier, do full tear down now */
-	if (cpufreq_driver->offline)
+	if (cpufreq_driver->offline && cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
 	up_write(&policy->rwsem);
-- 
2.43.0



