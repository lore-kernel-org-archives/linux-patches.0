Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C8632D7D8;
	Tue, 28 Oct 2025 12:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655710; cv=none; b=I1ZxnZBHrQgLIGRjTUerm8hmdO2QsPzRhfEEuBNg2+Dh0lWKBlxdX7C2DHdQpgqD/JmxCz3ePDGFfYE32mSGGEB0Nllt/So13S0X4LYMSjL3TxOCw4UHt6U7JSjRa/bhUSCCc5rFzUsY0VI7pUbIB4JDYopXNj5WsX796wrhcNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655710; c=relaxed/simple;
	bh=up6DAN6s+RjU+k6yEjhEfBrjGGkOEgvJ0auo3biralU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UY6W2Qa5314BvSLIQSwTaM3YVg1ofV7FPH10Qd3iIoce0T5Spm2Wikm/Ne/S66PneRJeJLXCDJR97UM1gnPdqzSwn6N0FcIx6jflP07ZmT3k7z1Vzt5m3a7BA/DDzNYwSYxMvyb/UF4btDKVll2fVyF4Lt4+27xKwtOhj9z+rB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rUW6kJLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rUW6kJLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE876C16AAE;
	Tue, 28 Oct 2025 12:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761655710;
	bh=up6DAN6s+RjU+k6yEjhEfBrjGGkOEgvJ0auo3biralU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUW6kJLstv3SGwHz/k9YO+feDrrQj1grLwSzR9gLYt1r6sG6fLFUBWvGjYdVoqpXv
	 JotjWGYCb95CfQs3j/lZLgjpwdThMauoVUX6hFwbSAR3xyc6ll+j+IO4v6PJcx2pNe
	 JBhVDFoao8YzLpJpxYUCimcuceQSX37n7O9agh+rNRRn0wLwG5ExhD2XkDiHYNCON0
	 bngFzug1K1BhX5xiBqhj7q0sw7425A4m6wnD9C9HFfEDOanqR1JvDOWmvyOne4GKoi
	 g7lyZRfuqC8O7s+6uimaoMS8lxEGhVCn+Y9EQGUCekiLzLHC5omLL6A6YlB521Lv+w
	 m8ghh4E4P7THA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] firmware: arm_scmi: Skip RAW initialization on failure
Date: Tue, 28 Oct 2025 08:48:07 -0400
Message-ID: <20251028124815.1058740-7-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028124815.1058740-1-sashal@kernel.org>
References: <20251028124815.1058740-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 092b9e2ce6dd63d2f36822751a51957412706986 ]

Avoid attempting to initialize RAW mode when the debug subsystem itself
has failed to initialize, since doing so is pointless and emits
misleading error messages.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20251014115346.2391418-3-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make my determination. Let me create a
comprehensive analysis:

## BACKPORT ANALYSIS DECISION

**Backport Status: YES**

---

## COMPREHENSIVE ANALYSIS

### 1. CODE CHANGE ANALYSIS

The commit makes two related changes:

**Change 1** (drivers/firmware/arm_scmi/driver.c:3047-3048):
```c
- if (!info->dbg)
- return -EINVAL;
```
Removes the NULL check from inside `scmi_debugfs_raw_mode_setup()`.

**Change 2** (drivers/firmware/arm_scmi/driver.c:3221):
```c
- if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
+               if (info->dbg &&
IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
```
Adds guard condition to prevent calling the function when `info->dbg` is
NULL.

### 2. SEMANTIC ANALYSIS PERFORMED

**Tools Used:**
- `git log` and `git show` for commit history analysis
- `Grep` for code pattern searches across SCMI subsystem
- `Read` for examining driver code and Kconfig
- Task agent (Explore) for understanding SCMI ecosystem context
- Git blame and tag analysis for version tracking

**Key Findings from Analysis:**

**Impact Scope (from code examination):**
- Function `scmi_debugfs_raw_mode_setup()` is called from only ONE
  location: `scmi_probe()` at line 3222
- Function accesses `info->dbg->top_dentry` at line 3068, which would be
  a **NULL pointer dereference** if the removed check wasn't there
- The calling site now has proper guard, so function is never called
  with NULL dbg

**Caller Analysis:**
- `scmi_probe()` is the driver probe function - called during device
  initialization
- Prior commits in series (2290ab43b9d8e, 289ce7e9a5e1a) fixed NULL
  handling in debug helpers
- This commit completes the debug failure handling by preventing
  pointless RAW init attempt

**Dependency Analysis:**
- RAW mode requires debugfs (CONFIG dependency in Kconfig line 35)
- `scmi_raw_mode_init()` expects valid `top_dentry` parameter (line
  3068)
- If debug setup fails, `info->dbg` is NULL, making RAW mode init
  impossible

### 3. BUG IMPACT ANALYSIS

**Affected Kernel Versions:**
- Introduced: v6.3-rc1 (commit 7063887b53860, January 2023)
- Fixed: v6.18-rc3 (commit 092b9e2ce6dd6, October 2025)
- **Affected range: v6.3 through v6.17**

**Failure Scenario:**
```c
// Before fix - in scmi_probe():
if (scmi_top_dentry) {
    info->dbg = scmi_debugfs_common_setup(info);  // Returns NULL on
failure
    if (!info->dbg)
        dev_warn(dev, "Failed to setup SCMI debugfs.\n");

    if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
        ret = scmi_debugfs_raw_mode_setup(info);  // Called with NULL
dbg!
        if (!coex) {  // Default config
            if (ret)  // ret = -EINVAL
                goto clear_dev_req_notifier;  // PROBE FAILS!
            return 0;
        }
    }
}
```

**Real-World Impact:**
- **Who is affected**: Development/testing systems with
  CONFIG_ARM_SCMI_RAW_MODE_SUPPORT=y
- **When it triggers**: When debugfs initialization fails (no debugfs
  support, memory failure, mount issues)
- **What breaks**: **Entire SCMI driver probe fails** → system may not
  boot
- **Criticality**: SCMI manages power domains, clocks, DVFS, thermal
  sensors - critical for ARM platforms

From Explore agent findings:
- SCMI is used on STM32MP, ARM Juno, NXP i.MX95 platforms
- Controls essential services: CPU frequency, power states, system
  shutdown/reboot
- Kconfig notes it "may be needed early in boot" for power control

**Severity Assessment:**
- **Medium-High for affected configurations**
- Not production issue (RAW mode is debug/testing feature per Kconfig
  line 42)
- But complete driver failure is **unacceptable** for development
  systems
- Misleading error messages make debugging difficult

### 4. ARCHITECTURAL & SIDE EFFECTS

**Architectural Impact:** None
- No data structure changes
- No API modifications
- No changes to core SCMI protocol handling

**Side Effects:** Positive only
- Prevents probe failure when debugfs fails
- Eliminates misleading error messages
- Improves graceful degradation
- No functional changes to success path

### 5. STABLE TREE COMPLIANCE

**Compliance Check:**
✅ **Bug fix**: Yes - fixes probe failure
✅ **Small and contained**: 2 simple changes in 1 file
✅ **Obviously correct**: Guard check before function call
✅ **No new features**: Pure bug fix
✅ **No architectural changes**: Minimal scope
✅ **Low regression risk**: Only affects error path

**Stable Tree Rules Alignment:**
- Fixes important bug (probe failure)
- Self-contained change
- Easy to review and verify
- Part of coordinated fix series (related commits already backported)

### 6. BACKPORT INDICATORS

**Evidence for backporting:**
- **Related commits already backported**: Commit 2290ab43b9d8e (with
  Fixes tag) has been backported to multiple stable trees
  (7056e61a28a83, 4c0f9a50f2e98, fae8405cfddb0, 58d3e2680bea9,
  30c89140a4ddc, 75446183128d2)
- **Part of fix series**: This is patch 3/3 in a coordinated series
  addressing debug initialization failures
- **Fixes merged in mainline**: Present in v6.18-rc3, merged via
  arm/fixes tree (71a5970259c3f)
- **No Cc: stable tag**: But related patches were backported, suggesting
  subsystem maintainers want the series in stable

**Evidence against backporting:**
- No explicit "Fixes:" tag (but commit message clearly states it fixes a
  problem)
- No "Cc: stable@vger.kernel.org" tag
- Only affects debug/testing configuration

### 7. DEPENDENCY CHECK

**Depends on:**
- None - independent fix
- Works better with commits 2290ab43b9d8e and 289ce7e9a5e1a (already
  backported)

**Required by:**
- None identified

---

## FINAL RECOMMENDATION

**YES - This commit SHOULD be backported to stable kernel trees.**

**Justification:**

1. **Fixes probe failure**: When debugfs fails + RAW mode enabled
   (without coex), entire SCMI driver fails to load, breaking critical
   platform services

2. **Completes backported series**: Related fixes (2290ab43b9d8e,
   289ce7e9a5e1a) already backported to stable. This commit completes
   the debug failure handling

3. **Low risk, high correctness**: Minimal change, obviously correct
   logic (guard before function call)

4. **Stable tree compliant**: Small, contained, bug-fix-only change with
   no architectural impact

5. **Affects supported feature**: CONFIG_ARM_SCMI_RAW_MODE_SUPPORT
   exists in stable kernels since v6.3

6. **Graceful degradation**: Enables proper fallback behavior when debug
   subsystem fails

**Target stable trees:** v6.3+ (where RAW mode was introduced)

**Priority:** Medium - affects development/testing systems, not
production, but fixes complete driver failure

 drivers/firmware/arm_scmi/driver.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index bd56a877fdfc8..85392228d1739 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -3044,9 +3044,6 @@ static int scmi_debugfs_raw_mode_setup(struct scmi_info *info)
 	u8 channels[SCMI_MAX_CHANNELS] = {};
 	DECLARE_BITMAP(protos, SCMI_MAX_CHANNELS) = {};
 
-	if (!info->dbg)
-		return -EINVAL;
-
 	/* Enumerate all channels to collect their ids */
 	idr_for_each_entry(&info->tx_idr, cinfo, id) {
 		/*
@@ -3218,7 +3215,7 @@ static int scmi_probe(struct platform_device *pdev)
 		if (!info->dbg)
 			dev_warn(dev, "Failed to setup SCMI debugfs.\n");
 
-		if (IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
+		if (info->dbg && IS_ENABLED(CONFIG_ARM_SCMI_RAW_MODE_SUPPORT)) {
 			ret = scmi_debugfs_raw_mode_setup(info);
 			if (!coex) {
 				if (ret)
-- 
2.51.0

