Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F93208CF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XptvboDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E562FC433C8;
	Tue, 31 Oct 2023 17:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774418;
	bh=OY6dltYYOQWATzViVI5jzZHOYdxxFcY9PqyEtQmpX7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XptvboDmELFQN7+nS2l1Q2Ppu/8qI8N1zCS9uRr2Z16MV5BkKfgODMErSZfVs3uuF
	 8l8/Y7jcPc4KWjPYYlKl5tE6lf9mCW9cdiIloOA4DOa7YV2ji3iRAwDk/XSu2ppFkM
	 kcnTX7NiL+Hc61ZEjUEeLmmVZB1ZzlAw5+yyxAZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.5 040/112] drm/i915/pmu: Check if pmu is closed before stopping event
Date: Tue, 31 Oct 2023 18:00:41 +0100
Message-ID: <20231031165902.571074261@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -832,9 +832,18 @@ static void i915_pmu_event_start(struct
 
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
 


