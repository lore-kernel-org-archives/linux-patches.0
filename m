Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FBB1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C630C433C8;
	Mon, 21 Aug 2023 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648362;
	bh=8xTRZ5XLuhoRZTyQDjyxibXpnGim9XrJBV6S11QU528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVzPUB+MzYMxlBiOBMjfplHPMbYHevtn9FN+3UlTBElCYbhmEYrd1gl2W1jQQUmj4
	 nYWUX03HEOdBliuZD5oBItec2RwZBTGfO577UH4xF0vMRkAqbbZLbuhX4zEw2Y6MFE
	 lgo2V/D9V7dfIgg+UEfp+CWZnjmblKnvvDnE0jOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 148/234] drm/i915/guc/slpc: Restore efficient freq earlier
Date: Mon, 21 Aug 2023 21:41:51 +0200
Message-ID: <20230821194135.392732920@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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

[ Upstream commit 5598c9bfdb81f40f2f5d769b342d25bff74b07a6 ]

This should be done before the soft min/max frequencies are restored.
When we disable the "Ignore efficient frequency" flag, GuC does not
actually bring the requested freq down to RPn.

Specifically, this scenario-

- ignore efficient freq set to true
- reduce min to RPn (from efficient)
- suspend
- resume (includes GuC load, restore soft min/max, restore efficient freq)
- validate min freq has been resored to RPn

This will fail if we didn't first restore(disable, in this case) efficient
freq flag before setting the soft min frequency.

v2: Bring the min freq down to RPn when we disable efficient freq (Rodrigo)
Also made the change to set the min softlimit to RPn at init. Otherwise, we
were storing RPe there.

Link: https://gitlab.freedesktop.org/drm/intel/-/issues/8736
Fixes: 55f9720dbf23 ("drm/i915/guc/slpc: Provide sysfs for efficient freq")
Fixes: 95ccf312a1e4 ("drm/i915/guc/slpc: Allow SLPC to use efficient frequency")
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230726010044.3280402-1-vinay.belgaumkar@intel.com
(cherry picked from commit 28e671114fb0f28f334fac8d0a6b9c395c7b0498)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c | 22 +++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
index cc18e8f664864..78822331f1b7f 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
@@ -470,12 +470,19 @@ int intel_guc_slpc_set_ignore_eff_freq(struct intel_guc_slpc *slpc, bool val)
 	ret = slpc_set_param(slpc,
 			     SLPC_PARAM_IGNORE_EFFICIENT_FREQUENCY,
 			     val);
-	if (ret)
+	if (ret) {
 		guc_probe_error(slpc_to_guc(slpc), "Failed to set efficient freq(%d): %pe\n",
 				val, ERR_PTR(ret));
-	else
+	} else {
 		slpc->ignore_eff_freq = val;
 
+		/* Set min to RPn when we disable efficient freq */
+		if (val)
+			ret = slpc_set_param(slpc,
+					     SLPC_PARAM_GLOBAL_MIN_GT_UNSLICE_FREQ_MHZ,
+					     slpc->min_freq);
+	}
+
 	intel_runtime_pm_put(&i915->runtime_pm, wakeref);
 	mutex_unlock(&slpc->lock);
 	return ret;
@@ -602,9 +609,8 @@ static int slpc_set_softlimits(struct intel_guc_slpc *slpc)
 		return ret;
 
 	if (!slpc->min_freq_softlimit) {
-		ret = intel_guc_slpc_get_min_freq(slpc, &slpc->min_freq_softlimit);
-		if (unlikely(ret))
-			return ret;
+		/* Min softlimit is initialized to RPn */
+		slpc->min_freq_softlimit = slpc->min_freq;
 		slpc_to_gt(slpc)->defaults.min_freq = slpc->min_freq_softlimit;
 	} else {
 		return intel_guc_slpc_set_min_freq(slpc,
@@ -755,6 +761,9 @@ int intel_guc_slpc_enable(struct intel_guc_slpc *slpc)
 		return ret;
 	}
 
+	/* Set cached value of ignore efficient freq */
+	intel_guc_slpc_set_ignore_eff_freq(slpc, slpc->ignore_eff_freq);
+
 	/* Revert SLPC min/max to softlimits if necessary */
 	ret = slpc_set_softlimits(slpc);
 	if (unlikely(ret)) {
@@ -765,9 +774,6 @@ int intel_guc_slpc_enable(struct intel_guc_slpc *slpc)
 	/* Set cached media freq ratio mode */
 	intel_guc_slpc_set_media_ratio_mode(slpc, slpc->media_ratio_mode);
 
-	/* Set cached value of ignore efficient freq */
-	intel_guc_slpc_set_ignore_eff_freq(slpc, slpc->ignore_eff_freq);
-
 	return 0;
 }
 
-- 
2.40.1



