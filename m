Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70948F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373BBC433C9;
	Sun, 16 Jul 2023 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539013;
	bh=zRCxc49ZdtsKPK3VpXN5vetKmod5IJ7xsEEHxwIU1OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsQ9d+L13e+rvV7eYnRRFDJErirdxotNKAxEqDc83zXd00319zy1nXO+bO+ie1eGl
	 J+LFgxkP7H8JkMS9ac5cVqrGtCs6ob8cThvpS6gW9bk/gsYPPf1SVuUbfJbBRWwAWz
	 hD7nNTz/SOTkQmboOc2lFuDxKmtsN2tseyr4nx6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 655/800] drm/i915/guc/slpc: Apply min softlimit correctly
Date: Sun, 16 Jul 2023 21:48:28 +0200
Message-ID: <20230716195004.325527685@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 3e49de73fb89272dea01ba420c7ccbcf6b96aed7 ]

The scenario being fixed here is depicted in the following sequence-

modprobe i915
echo 1 > /sys/class/drm/card0/gt/gt0/slpc_ignore_eff_freq
echo 300 > /sys/class/drm/card0/gt_min_freq_mhz (RPn)
cat /sys/class/drm/card0/gt_cur_freq_mhz --> cur == RPn as expected
echo 1 > /sys/kernel/debug/dri/0/gt0/reset --> reset
cat /sys/class/drm/card0/gt_min_freq_mhz --> cached freq is RPn
cat /sys/class/drm/card0/gt_cur_freq_mhz --> it's not RPn, but RPe!!

When SLPC reinitializes, it sets SLPC min freq to efficient frequency.
Even if we disable efficient freq post that, we should restore the cached
min freq (via H2G) for it to take effect.

v2: Clarify commit message (Ashutosh)

Fixes: 95ccf312a1e4 ("drm/i915/guc/slpc: Allow SLPC to use efficient frequency")
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230621014257.1769564-1-vinay.belgaumkar@intel.com
(cherry picked from commit da86b2b13f1d1ca26745b951ac94421f3137539a)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
index 56dbba1ef6684..cc18e8f664864 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
@@ -606,7 +606,7 @@ static int slpc_set_softlimits(struct intel_guc_slpc *slpc)
 		if (unlikely(ret))
 			return ret;
 		slpc_to_gt(slpc)->defaults.min_freq = slpc->min_freq_softlimit;
-	} else if (slpc->min_freq_softlimit != slpc->min_freq) {
+	} else {
 		return intel_guc_slpc_set_min_freq(slpc,
 						   slpc->min_freq_softlimit);
 	}
-- 
2.39.2



