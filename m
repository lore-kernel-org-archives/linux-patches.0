Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559E30EF82;
	Wed, 10 Dec 2025 03:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765338581; cv=none; b=mayUK9S1dXwKmRZZbqAgoeK3ILk3xjOna+vZeBYc9KRXuGrwlnUILX+RuIqgBrD1B2Kv/asM0mJ6ytdbqVm8KaxhOfImYERvXWsOpCmhClSeLcuDbd45IVOuSlh0vZLNkR12BCYb2S8YXBh1Zdv1BBODIO1B1DdB0Zrb+ym1DZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765338581; c=relaxed/simple;
	bh=Alrl3JLu37A805PoxAA6JkIgTa1/iH8zV6XBFvcIWyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CICGSKJCJ+t31H7IZe86FdWac0e50r4Ka0aiPNxAiSZ91zz0tP6aQdzvHncOHZNjFSR8UU60+QrN+H6lG+q5eY2TAY4CRvh3oWXy/IuPKPkjrWLONamEZFl/4eLDzs07u2rr7mHhdd72Bl3wK2z414jr8ODmDEF+hXCON94dkto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYo/ck9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYo/ck9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9C9C16AAE;
	Wed, 10 Dec 2025 03:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765338580;
	bh=Alrl3JLu37A805PoxAA6JkIgTa1/iH8zV6XBFvcIWyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYo/ck9gav4BngyhivwEVGww50hmNF99oU25Xk9MKvwG3ftngM9mGh4auSW8bpXQz
	 a6cY55Sj8PDQAXf1q/BzB8XMrRGTJYFqzfCBnuNn04cUbLLhGTWlYKKMghyHcMsc5o
	 6fSibfJd8M3wDKEG+6i10XciPnHJsWx0kIfMVmQFVFssLsIVb+nday7azIR/yXxD8H
	 c8RdVp9jHtnkYcU4VQ4Y33qYMMRLsHqOIRI0JkWUtHIlGJhcMDW4edEEyJ38PuflUa
	 q40zNB9fmpzcemHPAGcAMeTgoHgsHoDNobXBQOfePBfHllisd/QjPKUWETejLJSq1x
	 e6/jC2/It62Nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jinhui Guo <guojinhui.liam@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>,
	openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.18-5.10] ipmi: Fix __scan_channels() failing to rescan channels
Date: Tue,  9 Dec 2025 22:48:52 -0500
Message-ID: <20251210034915.2268617-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210034915.2268617-1-sashal@kernel.org>
References: <20251210034915.2268617-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 6bd30d8fc523fb880b4be548e8501bc0fe8f42d4 ]

channel_handler() sets intf->channels_ready to true but never
clears it, so __scan_channels() skips any rescan. When the BMC
firmware changes a rescan is required. Allow it by clearing
the flag before starting a new scan.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Message-ID: <20250930074239.2353-3-guojinhui.liam@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of IPMI Channel Rescan Fix

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** "ipmi: Fix __scan_channels() failing to rescan channels" -
clear bug fix indication.

**Problem described:**
- `channel_handler()` sets `intf->channels_ready = true` but never
  clears it
- This causes `__scan_channels()` to skip rescans
- When BMC firmware changes, a rescan is required but doesn't happen

**Tags check:**
- No "Cc: stable@vger.kernel.org" tag
- No "Fixes:" tag
- Signed off by IPMI maintainer Corey Minyard

### 2. CODE CHANGE ANALYSIS

The fix adds a `bool rescan` parameter to `__scan_channels()`:

```c
static int __scan_channels(struct ipmi_smi *intf,
                           struct ipmi_device_id *id,
                           bool rescan)
{
    if (rescan) {
        /* Clear channels_ready to force channels rescan. */
        intf->channels_ready = false;
    }
    ...
}
```

**Call site updates:**
- `ipmi_add_smi()`: `__scan_channels(intf, &id, false)` - initial scan
- `__bmc_get_device_id()` after BMC re-registration:
  `__scan_channels(intf, &id, false)` - fresh state
- `__bmc_get_device_id()` when version info changes:
  `__scan_channels(intf, &bmc->fetch_id, true)` - rescan needed

**Bug mechanism:** When BMC firmware changes and `__bmc_get_device_id()`
detects version info differences, it calls `__scan_channels()` to update
channel information. However, since `channels_ready` was already set
`true` from the initial scan, the rescan logic is skipped, leaving stale
channel information.

### 3. CLASSIFICATION

- **Type:** Bug fix (not a feature)
- **Category:** Functional bug in existing driver logic
- **Security:** No security implications

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- 1 file changed: `drivers/char/ipmi/ipmi_msghandler.c`
- ~15 lines of actual changes (mostly parameter additions)
- Localized to the `__scan_channels()` function and its callers

**Risk:** LOW
- The logic is simple and obvious: clear a boolean flag before
  rescanning
- No complex interactions or side effects
- The differentiation between initial scan (`false`) and rescan (`true`)
  is well-reasoned

### 5. USER IMPACT

**Affected users:**
- Servers with IPMI/BMC interfaces (common in enterprise/datacenter
  environments)
- Users who update BMC firmware while the system is running

**Impact without fix:**
- After BMC firmware updates, IPMI channel information becomes stale
- System management through IPMI may malfunction
- Users must reboot to get correct channel information

**Severity:** Medium - affects functionality, not crashes or data
corruption

### 6. STABILITY INDICATORS

- Signed off by IPMI subsystem maintainer
- The fix logic is straightforward and verifiable by inspection
- No complex algorithmic changes

### 7. DEPENDENCY CHECK

- Self-contained fix with no dependencies on other commits
- `ipmi_msghandler.c` exists in all stable trees (mature driver)
- The affected functions (`__scan_channels`, `channel_handler`) exist in
  stable kernels

### Risk vs Benefit Assessment

**Benefits:**
- Fixes real-world bug: BMC firmware updates are common maintenance
  operations
- Small, surgical fix with minimal code changes
- IPMI is critical for server management in enterprise environments

**Risks:**
- Very low - the change is obviously correct
- Adding a parameter and clearing a flag is straightforward
- No behavioral changes to working code paths (initial scan unchanged)

### Concerns

1. **No Fixes: tag** - Cannot determine when bug was introduced, making
   it harder to know which stable versions need it
2. **No explicit Cc: stable** - Author didn't request backport
3. **Specific scenario** - Only affects systems where BMC firmware
   changes at runtime

### Conclusion

This commit fixes a legitimate functional bug where IPMI channel
rescanning fails after BMC firmware changes. The fix is:
- **Obviously correct**: Clear a "ready" flag before rescanning
- **Small and contained**: ~15 lines in one file
- **Fixes a real bug**: Users who update BMC firmware encounter this
- **Low risk**: Simple boolean flag manipulation

While it lacks explicit stable tags, the fix is valuable for enterprise
users who rely on IPMI for server management. The change is minimal, the
logic is clear, and it restores expected functionality without
introducing new features.

**YES**

 drivers/char/ipmi/ipmi_msghandler.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index d3f84deee4513..0a886399f9daf 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -599,7 +599,8 @@ static void __ipmi_bmc_unregister(struct ipmi_smi *intf);
 static int __ipmi_bmc_register(struct ipmi_smi *intf,
 			       struct ipmi_device_id *id,
 			       bool guid_set, guid_t *guid, int intf_num);
-static int __scan_channels(struct ipmi_smi *intf, struct ipmi_device_id *id);
+static int __scan_channels(struct ipmi_smi *intf,
+				struct ipmi_device_id *id, bool rescan);
 
 static void free_ipmi_user(struct kref *ref)
 {
@@ -2668,7 +2669,7 @@ static int __bmc_get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc,
 		if (__ipmi_bmc_register(intf, &id, guid_set, &guid, intf_num))
 			need_waiter(intf); /* Retry later on an error. */
 		else
-			__scan_channels(intf, &id);
+			__scan_channels(intf, &id, false);
 
 
 		if (!intf_set) {
@@ -2688,7 +2689,7 @@ static int __bmc_get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc,
 		goto out_noprocessing;
 	} else if (memcmp(&bmc->fetch_id, &bmc->id, sizeof(bmc->id)))
 		/* Version info changes, scan the channels again. */
-		__scan_channels(intf, &bmc->fetch_id);
+		__scan_channels(intf, &bmc->fetch_id, true);
 
 	bmc->dyn_id_expiry = jiffies + IPMI_DYN_DEV_ID_EXPIRY;
 
@@ -3438,10 +3439,17 @@ channel_handler(struct ipmi_smi *intf, struct ipmi_recv_msg *msg)
 /*
  * Must be holding intf->bmc_reg_mutex to call this.
  */
-static int __scan_channels(struct ipmi_smi *intf, struct ipmi_device_id *id)
+static int __scan_channels(struct ipmi_smi *intf,
+				struct ipmi_device_id *id,
+				bool rescan)
 {
 	int rv;
 
+	if (rescan) {
+		/* Clear channels_ready to force channels rescan. */
+		intf->channels_ready = false;
+	}
+
 	if (ipmi_version_major(id) > 1
 			|| (ipmi_version_major(id) == 1
 			    && ipmi_version_minor(id) >= 5)) {
@@ -3656,7 +3664,7 @@ int ipmi_add_smi(struct module         *owner,
 	}
 
 	mutex_lock(&intf->bmc_reg_mutex);
-	rv = __scan_channels(intf, &id);
+	rv = __scan_channels(intf, &id, false);
 	mutex_unlock(&intf->bmc_reg_mutex);
 	if (rv)
 		goto out_err_bmc_reg;
-- 
2.51.0

