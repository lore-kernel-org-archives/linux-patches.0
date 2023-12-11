Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCF7FC06;
	Mon, 11 Dec 2023 18:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg7GA/nX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4403DC433CA;
	Mon, 11 Dec 2023 18:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319632;
	bh=dk3tG5QGaH+N+9SOrPR8Eiwzk6Fkr12BE/7EJPKC7Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sg7GA/nX02tqfdrdeDKc/yCnVnWiCoBvVczXUGWRzqPyZbQY87+A1gRUfssDm/3A9
	 g6X++uW6uNJi6WBy9MRH24+WHl1V3bASI0Gkx0Rjehbks2SKsS4VcTdcUiJh/4aaD9
	 RA2TMYnupUcplKpPHjRUimdZXLaDcfkqE3/Pyx4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 170/244] powercap: DTPM: Fix missing cpufreq_cpu_put() calls
Date: Mon, 11 Dec 2023 19:21:03 +0100
Message-ID: <20231211182053.522286720@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Lukasz Luba <lukasz.luba@arm.com>

commit bdefd9913bdd453991ef756b6f7176e8ad80d786 upstream.

The policy returned by cpufreq_cpu_get() has to be released with
the help of cpufreq_cpu_put() to balance its kobject reference counter
properly.

Add the missing calls to cpufreq_cpu_put() in the code.

Fixes: 0aea2e4ec2a2 ("powercap/dtpm_cpu: Reset per_cpu variable in the release function")
Fixes: 0e8f68d7f048 ("powercap/drivers/dtpm: Add CPU energy model based support")
Cc: v5.16+ <stable@vger.kernel.org> # v5.16+
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/dtpm_cpu.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/powercap/dtpm_cpu.c
+++ b/drivers/powercap/dtpm_cpu.c
@@ -140,6 +140,8 @@ static void pd_release(struct dtpm *dtpm
 	if (policy) {
 		for_each_cpu(dtpm_cpu->cpu, policy->related_cpus)
 			per_cpu(dtpm_per_cpu, dtpm_cpu->cpu) = NULL;
+
+		cpufreq_cpu_put(policy);
 	}
 	
 	kfree(dtpm_cpu);
@@ -191,12 +193,16 @@ static int __dtpm_cpu_setup(int cpu, str
 		return 0;
 
 	pd = em_cpu_get(cpu);
-	if (!pd || em_is_artificial(pd))
-		return -EINVAL;
+	if (!pd || em_is_artificial(pd)) {
+		ret = -EINVAL;
+		goto release_policy;
+	}
 
 	dtpm_cpu = kzalloc(sizeof(*dtpm_cpu), GFP_KERNEL);
-	if (!dtpm_cpu)
-		return -ENOMEM;
+	if (!dtpm_cpu) {
+		ret = -ENOMEM;
+		goto release_policy;
+	}
 
 	dtpm_init(&dtpm_cpu->dtpm, &dtpm_ops);
 	dtpm_cpu->cpu = cpu;
@@ -216,6 +222,7 @@ static int __dtpm_cpu_setup(int cpu, str
 	if (ret)
 		goto out_dtpm_unregister;
 
+	cpufreq_cpu_put(policy);
 	return 0;
 
 out_dtpm_unregister:
@@ -227,6 +234,8 @@ out_kfree_dtpm_cpu:
 		per_cpu(dtpm_per_cpu, cpu) = NULL;
 	kfree(dtpm_cpu);
 
+release_policy:
+	cpufreq_cpu_put(policy);
 	return ret;
 }
 


