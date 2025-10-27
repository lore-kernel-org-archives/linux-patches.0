Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B8A327783;
	Mon, 27 Oct 2025 19:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592816; cv=none; b=McsF4xYZCjdfDX9YdMf6oVRqHFdf8s1Cex9a8dWIoobNR6AHlZ/88B+kGLyOb9gk+sCRPE60hK9HkcFNkqpsyHYGJJdsj2twowPNU0WpGH5kN/Z/DQhp1FCBoSoEa1lY1BHBnVOTReEx8tHzW6a7cxnTDHb736wcDFtB8lRBZeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592816; c=relaxed/simple;
	bh=e//pXbggMeZT+jiF3tRbhgGQmqDcazqzScQFp3E07+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7cNBu8NP3iNny0ST60NLMY7yojgrUDuNbKqKsDsGiijixQfw759QD+Z3aqr+RzfwJb3djIS10ktY5tCmWG112tFxmIe9BRhKUsdHODyNC6KfrEDBoG5P2ei/YL2WkC7Hp+xGIMDaZak1A8JDfOa5HcFLP6I5IOVK5VCyfGrByY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4/iZlzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4/iZlzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E3DC116D0;
	Mon, 27 Oct 2025 19:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592816;
	bh=e//pXbggMeZT+jiF3tRbhgGQmqDcazqzScQFp3E07+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4/iZlzpX6/fgSYlKDHfvYIxw5MrkdFC+u4bGSyeiqWVwwHQnwxoSnCLQ74UDH1Gr
	 X5x6rXRQ1qBWxNU7igRZQv+3t3fwuG9LLmyRTNdXI0fr4ctG9iw0FDyfynU/NHm20q
	 Pila3pETd1e9CTN6a9EeBrpIEbyYcb04berKLcg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/117] PM: EM: Slightly reduce em_check_capacity_update() overhead
Date: Mon, 27 Oct 2025 19:35:48 +0100
Message-ID: <20251027183454.556926052@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit a8e62726ac0dd7b610c87ba1a938a5a9091c34df ]

Every iteration of the loop over all possible CPUs in
em_check_capacity_update() causes get_cpu_device() to be called twice
for the same CPU, once indirectly via em_cpu_get() and once directly.

Get rid of the indirect get_cpu_device() call by moving the direct
invocation of it earlier and using em_pd_get() instead of em_cpu_get()
to get a pd pointer for the dev one returned by it.

This also exposes the fact that dev is needed to get a pd, so the code
becomes somewhat easier to follow after it.

No functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/1925950.tdWV9SEqCh@rjwysocki.net
Stable-dep-of: 1ebe8f7e7825 ("PM: EM: Fix late boot with holes in CPU topology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/energy_model.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -769,7 +769,8 @@ static void em_check_capacity_update(voi
 		}
 		cpufreq_cpu_put(policy);
 
-		pd = em_cpu_get(cpu);
+		dev = get_cpu_device(cpu);
+		pd = em_pd_get(dev);
 		if (!pd || em_is_artificial(pd))
 			continue;
 
@@ -793,7 +794,6 @@ static void em_check_capacity_update(voi
 		pr_debug("updating cpu%d cpu_cap=%lu old capacity=%lu\n",
 			 cpu, cpu_capacity, em_max_perf);
 
-		dev = get_cpu_device(cpu);
 		em_adjust_new_capacity(dev, pd);
 	}
 


