Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11A197A76;
	Thu,  6 Jun 2024 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683228; cv=none; b=nxqPnGj2L8+1ug1cG7x7k3E5sqbYX/MSLH7rwFbkJUJXApIoJ9m13ErSHLMOYHAKDCEUgbI6xWaKRD+xJltuQgobHENikO7GpIO2BECtZj8ONPsvJdmqmHO3ugE2qm1H3OsXuPioI56O3D153rpf7yeqs3Ad0d0fXMEg6iIWpg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683228; c=relaxed/simple;
	bh=uv7PAI8FARV6e1RFF0h85iXpwaGLyrYSFH67NcQhWUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDKFTvVEZL5V6sMre5NSIg+NNR1WtHwceaFqAle9i7gadpZdB6tNpoP+c5drFGFdQnnwieNzqHpNEh0VYCjuify/D4HW/D2PaDeIu+lM+BsqUDm9Rjm5zY3Tpnp1JCqpFezEsnBdr+3nrcMlCgiDZovqx0/yPLtOpDMB8/ZJQ4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DgU++mxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgU++mxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A0DC2BD10;
	Thu,  6 Jun 2024 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683227;
	bh=uv7PAI8FARV6e1RFF0h85iXpwaGLyrYSFH67NcQhWUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgU++mxt/ejKIZh0D7SDz+R+zCuY7L9sUIBJHLBPEomHiIZmf6G7ULGjBNrMmJyKe
	 e3tF95VcBMT7vV2y9y1wnVVyTh0ESukDillzF8ertJsoc3SfDqgvMpLcDNaTQyt+BV
	 4JnoSXlOTB8KlI97dj+oNdIqGr6gJuPyuhotowB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Lizhe <sensor1010@163.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/744] cpufreq: exit() callback is optional
Date: Thu,  6 Jun 2024 15:57:21 +0200
Message-ID: <20240606131737.847175195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9177265d73b47..06e0294a17a8d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1670,10 +1670,13 @@ static void __cpufreq_offline(unsigned int cpu, struct cpufreq_policy *policy)
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
@@ -1731,7 +1734,7 @@ static void cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 	}
 
 	/* We did light-weight exit earlier, do full tear down now */
-	if (cpufreq_driver->offline)
+	if (cpufreq_driver->offline && cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 
 	up_write(&policy->rwsem);
-- 
2.43.0



