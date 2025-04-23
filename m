Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9395219DF4C;
	Wed, 23 Apr 2025 14:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419800; cv=none; b=VxgviDpQwMkwzcdH6essAHSSQvqKu3Qj0qrM7P3hKzhf2ek4uTaEMDJVF3gOhbQ9j2QPwxWy1dx6+MpLrHHgCvPr2sEmBgXhBMh+Bhp7X+AwroZRKFn7n2hjb99S/uium8KSaXHXncd5S+Aa4XXMF1P/RzPThcN1Fv7mIBcmrnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419800; c=relaxed/simple;
	bh=Kgh6ZJIj5DOxQKM6+OumIXGOsg9hXoPRkF+CZBmELBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQnpAF1eyVo9dpZolnPKsD0hAjnRIhO6YEN+AAADQi/jLVT9oZuRzCF6SvtR9Hz08Jts0VU0fSRaaTI7HuJdm0Y5Mhel3FGXBLxDZN1QKRzAOtIiN/uM732bG3UCgSWHYFwGBNncGreQk1Ipj0DaRY0W/dW1wmDPYBTJ0RvKo7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5s/hJy/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5s/hJy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C68AC4CEE2;
	Wed, 23 Apr 2025 14:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419800;
	bh=Kgh6ZJIj5DOxQKM6+OumIXGOsg9hXoPRkF+CZBmELBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5s/hJy/Vz8TNzU8Zoz/KjWFOHgFz4/XvnROlE/TPLXenckw5Vt3fijMNerxwA8Uk
	 hN91D7xjpTIMaeoQYN07XLJd4OzlNhK3z6lodx/omR0T0IMiSsEYLY6AeEutvDi3hh
	 /6sAbvtcT2DEzZvKB6PoI9kTig8X7DYjEp7FbFXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/393] drm/i915/dg2: wait for HuC load completion before running selftests
Date: Wed, 23 Apr 2025 16:38:20 +0200
Message-ID: <20250423142643.428844721@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit c3015eb6e25a735ab77591573236169eab8e2e3a ]

On DG2, submissions to VCS engines tied to a gem context are blocked
until the HuC is loaded. Since some selftests do use a gem context,
wait for the HuC load to complete before running the tests to avoid
contamination.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10564
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240410201505.894594-1-daniele.ceraolospurio@intel.com
Stable-dep-of: 9d3d9776bd3b ("drm/i915: Disable RPG during live selftest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/i915/selftests/i915_selftest.c    | 36 ++++++++++++++++---
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/selftests/i915_selftest.c b/drivers/gpu/drm/i915/selftests/i915_selftest.c
index ee79e0809a6dd..fee76c1d2f450 100644
--- a/drivers/gpu/drm/i915/selftests/i915_selftest.c
+++ b/drivers/gpu/drm/i915/selftests/i915_selftest.c
@@ -154,6 +154,30 @@ __wait_gsc_proxy_completed(struct drm_i915_private *i915)
 		pr_warn(DRIVER_NAME "Timed out waiting for gsc_proxy_completion!\n");
 }
 
+static void
+__wait_gsc_huc_load_completed(struct drm_i915_private *i915)
+{
+	/* this only applies to DG2, so we only care about GT0 */
+	struct intel_huc *huc = &to_gt(i915)->uc.huc;
+	bool need_to_wait = (IS_ENABLED(CONFIG_INTEL_MEI_PXP) &&
+			     intel_huc_wait_required(huc));
+	/*
+	 * The GSC and PXP mei bringup depends on the kernel boot ordering, so
+	 * to account for the worst case scenario the HuC code waits for up to
+	 * 10s for the GSC driver to load and then another 5s for the PXP
+	 * component to bind before giving up, even though those steps normally
+	 * complete in less than a second from the i915 load. We match that
+	 * timeout here, but we expect to bail early due to the fence being
+	 * signalled even in a failure case, as it is extremely unlikely that
+	 * both components will use their full timeout.
+	 */
+	unsigned long timeout_ms = 15000;
+
+	if (need_to_wait &&
+	    wait_for(i915_sw_fence_done(&huc->delayed_load.fence), timeout_ms))
+		pr_warn(DRIVER_NAME "Timed out waiting for huc load via GSC!\n");
+}
+
 static int __run_selftests(const char *name,
 			   struct selftest *st,
 			   unsigned int count,
@@ -228,14 +252,16 @@ int i915_mock_selftests(void)
 
 int i915_live_selftests(struct pci_dev *pdev)
 {
+	struct drm_i915_private *i915 = pdev_to_i915(pdev);
 	int err;
 
 	if (!i915_selftest.live)
 		return 0;
 
-	__wait_gsc_proxy_completed(pdev_to_i915(pdev));
+	__wait_gsc_proxy_completed(i915);
+	__wait_gsc_huc_load_completed(i915);
 
-	err = run_selftests(live, pdev_to_i915(pdev));
+	err = run_selftests(live, i915);
 	if (err) {
 		i915_selftest.live = err;
 		return err;
@@ -251,14 +277,16 @@ int i915_live_selftests(struct pci_dev *pdev)
 
 int i915_perf_selftests(struct pci_dev *pdev)
 {
+	struct drm_i915_private *i915 = pdev_to_i915(pdev);
 	int err;
 
 	if (!i915_selftest.perf)
 		return 0;
 
-	__wait_gsc_proxy_completed(pdev_to_i915(pdev));
+	__wait_gsc_proxy_completed(i915);
+	__wait_gsc_huc_load_completed(i915);
 
-	err = run_selftests(perf, pdev_to_i915(pdev));
+	err = run_selftests(perf, i915);
 	if (err) {
 		i915_selftest.perf = err;
 		return err;
-- 
2.39.5



