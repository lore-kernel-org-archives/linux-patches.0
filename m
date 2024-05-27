Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80E81078F;
	Mon, 27 May 2024 19:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836678; cv=none; b=A9ufpWY5rJFKpsGCfqDM86Rcb7Q4olYgl9qGF8qRYAe6++SvKAc3e8PILaqPvw9iwhAkjXjyiOV2jLbZuULR2+orYNtxp3itFFDd9zzSWeVe6XcRV8qDtBYyFEYx5w6jDAXwnM3siFgxF9YDYd4GJ8GW5ebSR29eNzDvQNLu/W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836678; c=relaxed/simple;
	bh=wpwCmWWebkQCyPf9OOrz0ZKl1HraSmKJobsHmAKeMI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/qKVq43LRCfapKMG6r035mspOZbmGxDyt+qzH04TJngA1pxTZ/4RKPaD5zBPE/jn39aIjM6rcW3ZpLwLxS+MP9m1TG+x8WwYqkABHL66oMwcPJULDApWiXM71M/jOvbnmYGexPQF5lvUjj6SqYgkT5vG+lSCGKpaSEHSC6l9bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5HBzAzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5HBzAzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2966DC2BBFC;
	Mon, 27 May 2024 19:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836677;
	bh=wpwCmWWebkQCyPf9OOrz0ZKl1HraSmKJobsHmAKeMI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5HBzAzX9i9QtAUWG8UCbQ8nFDm/UBj+qSGWfl+6DDbPpWhXI0ZFIjO1nlEBJi5N9
	 s8DWQilrjidenT8zIX3sM3sxfFbG/Hjm2VqVZaH2Zg/Y+YqWwdWrnfU3QrEmLshx2L
	 W6pfXX6kQSfp0DPpaLMMsEQ2JwPGMC1+DYMAOeaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lizhe <sensor1010@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 146/427] cpufreq: exit() callback is optional
Date: Mon, 27 May 2024 20:53:13 +0200
Message-ID: <20240527185615.533116746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 66e10a19d76ab..fd9c3ed21f49c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1679,10 +1679,13 @@ static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
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
@@ -1740,7 +1743,7 @@ static void cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	}
 
 	/* We did light-weight exit earlier, do full tear down now */
-	if (cpufreq_driver->offline)
+	if (cpufreq_driver->offline && cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
 	up_write(&policy->rwsem);
-- 
2.43.0



