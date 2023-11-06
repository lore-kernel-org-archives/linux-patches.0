Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BED123747
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAMJZACO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC773C433C8;
	Mon,  6 Nov 2023 13:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277031;
	bh=3tPkQp3sH/mvAi8sxHAL7KaxYOYWTyntzb/MXwn/WzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAMJZACO1aNHOD0DMI9a7VNvdwdr3KkrJTtJhYRTObW4ilBKUCsmwmXE66oahRrIn
	 TkSnq2evXFDd88nz6ZFXoM1gojCeofRYt6Ho9snvUFwNGXUSJErfEOS6xgyxmsPqlv
	 2us3WvR0OKbt5ao2KBbBq/ZDnetLFFKW3wT1NWgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 015/128] drm/i915/pmu: Check if pmu is closed before stopping event
Date: Mon,  6 Nov 2023 14:02:55 +0100
Message-ID: <20231106130309.816471000@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

commit 4cbed7702eb775cca22fff6827a549092cb59f61 upstream.

When the driver unbinds, pmu is unregistered and i915->uabi_engines is
set to RB_ROOT. Due to this, when i915 PMU tries to stop the engine
events, it issues a warn_on because engine lookup fails.

All perf hooks are taking care of this using a pmu->closed flag that is
set when PMU unregisters. The stop event seems to have been left out.

Check for pmu->closed in pmu_event_stop as well.

Based on discussion here -
https://patchwork.freedesktop.org/patch/492079/?series=105790&rev=2

v2: s/is/if/ in commit title
v3: Add fixes tag and cc stable

Cc: <stable@vger.kernel.org> # v5.11+
Fixes: b00bccb3f0bb ("drm/i915/pmu: Handle PCI unbind")
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231020152441.3764850-1-umesh.nerlige.ramappa@intel.com
(cherry picked from commit 31f6a06f0c543b43a38fab10f39e5fc45ad62aa2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_pmu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -761,9 +761,18 @@ static void i915_pmu_event_start(struct
 
 static void i915_pmu_event_stop(struct perf_event *event, int flags)
 {
+	struct drm_i915_private *i915 =
+		container_of(event->pmu, typeof(*i915), pmu.base);
+	struct i915_pmu *pmu = &i915->pmu;
+
+	if (pmu->closed)
+		goto out;
+
 	if (flags & PERF_EF_UPDATE)
 		i915_pmu_event_read(event);
 	i915_pmu_disable(event);
+
+out:
 	event->hw.state = PERF_HES_STOPPED;
 }
 


