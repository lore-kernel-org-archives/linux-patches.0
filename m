Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC70C52F86;
	Mon,  8 Jan 2024 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBaNT3j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC41C433C7;
	Mon,  8 Jan 2024 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728644;
	bh=MIfRmZ+bNJpWh/MsFzIm0CdgDvJsRRO//j+xYiHES/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBaNT3j5zkFzB+J8a0/4BFqoRmRf4l+AEMdiU3Ib1C7XuTB8XU0okAd2FA8XPoYUV
	 a0JRJQiBuiAkPh66HaCEMOF5tjua5XcubinVHwN6fHHUy26pXCxGyfrlEUlkUV4CL0
	 Y3ufBX0xHJK9FiFa05GD58LH7GDzstXTUmAF+PB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.1 142/150] genirq/affinity: Only build SMP-only helper functions on SMP kernels
Date: Mon,  8 Jan 2024 16:36:33 +0100
Message-ID: <20240108153517.744485766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

commit 188a569658584e93930ab60334c5a1079c0330d8 upstream.

allnoconfig grew these new build warnings in lib/group_cpus.c:

  lib/group_cpus.c:247:12: warning: ‘__group_cpus_evenly’ defined but not used [-Wunused-function]
  lib/group_cpus.c:75:13: warning: ‘build_node_to_cpumask’ defined but not used [-Wunused-function]
  lib/group_cpus.c:66:13: warning: ‘free_node_to_cpumask’ defined but not used [-Wunused-function]
  lib/group_cpus.c:43:23: warning: ‘alloc_node_to_cpumask’ defined but not used [-Wunused-function]

Widen the #ifdef CONFIG_SMP block to not expose unused helpers on
non-SMP builds.

Also annotate the preprocessor branches for better readability.

Fixes: f7b3ea8cf72f ("genirq/affinity: Move group_cpus_evenly() into lib/")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221227022905.352674-6-ming.lei@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/group_cpus.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/lib/group_cpus.c
+++ b/lib/group_cpus.c
@@ -9,6 +9,8 @@
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
+#ifdef CONFIG_SMP
+
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
 {
@@ -327,7 +329,6 @@ static int __group_cpus_evenly(unsigned
 	return done;
 }
 
-#ifdef CONFIG_SMP
 /**
  * group_cpus_evenly - Group all CPUs evenly per NUMA/CPU locality
  * @numgrps: number of groups
@@ -422,7 +423,7 @@ struct cpumask *group_cpus_evenly(unsign
 	}
 	return masks;
 }
-#else
+#else /* CONFIG_SMP */
 struct cpumask *group_cpus_evenly(unsigned int numgrps)
 {
 	struct cpumask *masks = kcalloc(numgrps, sizeof(*masks), GFP_KERNEL);
@@ -434,4 +435,4 @@ struct cpumask *group_cpus_evenly(unsign
 	cpumask_copy(&masks[0], cpu_possible_mask);
 	return masks;
 }
-#endif
+#endif /* CONFIG_SMP */


