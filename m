Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55AA2E0415;
	Mon,  6 Oct 2025 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774777; cv=none; b=rPMzISGGo0QBvtNZP04YzCP0lrZvrqme/hF3Pnl/BXz6nQJJd6PGUYn/X65yDp/VJj6NyZAEfQiWKg+6FcrsFjQ/bHEROU5Enfs7T3YR2ptstdlQXmR6mZjMr3Q2OORd4bqPLPFQ46RRGXNEh0qThGmzkZOYpZJyzW7DeledrCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774777; c=relaxed/simple;
	bh=dnE33TLBHAu72emN264L3RZGkWGUBJdc69XVpAlzANs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GxHZZ7fgQ9sMMPjgkIXraOaD/F0QzQ+HygnDDBSWwVmDUY+G2KJ+CFcroVnaTHqHe/rhXluQVwUJF52fNg+x4uqbUDvvsEQP5jWqt78/3VK5E5ObtVv79lCz/OtpV7yHxOycddOSIPEOc6Oq1RkEGsgT9QQ0hBTfpLca7zWsIEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGIvcioJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGIvcioJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4991C4CEF5;
	Mon,  6 Oct 2025 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774777;
	bh=dnE33TLBHAu72emN264L3RZGkWGUBJdc69XVpAlzANs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGIvcioJzA0t2e0slHblDbPS+unXBA/MN9ih4znSrOcsQTpS1F9H8PrdfC0dUvRJ9
	 KL0D/aJ+3iYUDBiZ/QSWj+T4iS4eZgha77DHVdSIk07/mM/Dq01UhXKAjk9tLg5oBM
	 lGLfj5h588EcfRoNzIGyH9h0+03nL4/dWlIw4RAtEAZb98muglC57yIqnndvdGdwwa
	 /RZjItzJilFTOm1u+oxG0ze55qQmx+QycaUCaDcilyyN/LoI/5gvdOrm2U4FMj7oF+
	 wvk4V+xbK37tybA6AlYGo5iYKQy5z+SjXTz0qpZilUQ1xuc1TJ3FUmwmWQPjJ901l7
	 EATXYJAsdG7HA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>,
	eparis@redhat.com,
	audit@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.6] audit: record fanotify event regardless of presence of rules
Date: Mon,  6 Oct 2025 14:17:58 -0400
Message-ID: <20251006181835.1919496-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Guy Briggs <rgb@redhat.com>

[ Upstream commit ce8370e2e62a903e18be7dd0e0be2eee079501e1 ]

When no audit rules are in place, fanotify event results are
unconditionally dropped due to an explicit check for the existence of
any audit rules.  Given this is a report from another security
sub-system, allow it to be recorded regardless of the existence of any
audit rules.

To test, install and run the fapolicyd daemon with default config.  Then
as an unprivileged user, create and run a very simple binary that should
be denied.  Then check for an event with
	ausearch -m FANOTIFY -ts recent

Link: https://issues.redhat.com/browse/RHEL-9065
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

### Executive Summary
This commit fixes a significant security audit gap where fanotify access
control decisions are silently dropped when no audit rules are
configured. This is a critical bug for compliance and security
monitoring, especially for systems using fapolicyd or other fanotify-
based security tools.

---

## Detailed Analysis

### 1. Code Change Analysis

**File**: `include/linux/audit.h`
**Function**: `audit_fanotify()` (line 528-532)
**Change**:
```c
- if (!audit_dummy_context())  // Checks if audit rules are configured
+ if (audit_enabled)             // Checks if audit subsystem is enabled
```

**What this means**:
- `audit_dummy_context()`: Returns `true` when there's no audit context
  OR no audit rules configured
- `audit_enabled`: Global flag indicating if the audit subsystem is
  enabled

**Effect**: fanotify events are now logged whenever audit is enabled,
regardless of whether specific audit rules exist.

### 2. Historical Context

**2017** (commit de8cd83e91bc3): fanotify audit logging introduced by
Steve Grubb with `!audit_dummy_context()` check
**2018** (commit 15564ff0a16e2): Similar check added to ANOM_LINK to
prevent "disjointed records when audit is disabled" (GitHub issue #21)
**2025** (commit ce8370e2e62a9): **This fix** - recognizes security
events should be logged regardless of rules
**2025** (commit 654d61b8e0e2f): Companion fix for AUDIT_ANOM_* events
with same rationale

### 3. The Bug's Impact

**Scenario**: System running fapolicyd (file access policy daemon) with:
- Audit subsystem enabled (`audit_enabled = 1`)
- No specific audit rules configured (`audit_dummy_context() = true`)

**Before this fix**:
- fanotify denies file execution
- User receives "permission denied" error
- **ZERO audit trail** of this security decision
- Compliance violation (Common Criteria, PCI-DSS, etc.)
- Security incident investigation impossible

**After this fix**:
- Same access control behavior
- **Audit record created**: `type=FANOTIFY msg=audit(...): resp=2
  fan_type=1 ...`
- Proper security audit trail maintained
- Compliance requirements met

### 4. Why This Matters

**Security Subsystem Integration**: fanotify is a security subsystem
that explicitly requests auditing via the `FAN_AUDIT` flag (see
fs/notify/fanotify/fanotify.c:279-282). When a security subsystem says
"audit this decision," it should be honored.

**Compliance Requirements**: Organizations subject to:
- Common Criteria (explicitly mentioned in original 2017 commit
  de8cd83e91bc3)
- PCI-DSS (requires audit trail of access control decisions)
- SOC 2, ISO 27001, HIPAA (all require security event logging)

Cannot afford missing security events in audit logs.

**Real-world Use Case**: The commit message provides a concrete test
case with fapolicyd:
```bash
# Install fapolicyd with default config
# As unprivileged user, create and run a denied binary
# Check for event:
ausearch -m FANOTIFY -ts recent
```

Without this fix, `ausearch` returns nothing despite the denial
occurring.

### 5. Risk Assessment

**Regression Risk**: **VERY LOW**
- One-line change in a header file
- Only affects logging behavior, not access control logic
- No changes to fanotify permission enforcement
- Pattern already proven in companion commit for ANOM_* events
  (654d61b8e0e2f)

**Side Effects**:
- Slightly increased audit log volume (only when fanotify with FAN_AUDIT
  is actively used)
- This is **intended behavior** - these events were always supposed to
  be logged

**Testing**: Commit message includes specific test procedure using
fapolicyd

### 6. Stable Tree Suitability

**Meets stable kernel criteria**:
- ✅ Fixes important bug affecting users (missing security audit trail)
- ✅ Small, contained change (1 line in 1 file)
- ✅ No architectural changes
- ✅ Minimal regression risk
- ✅ Confined to audit subsystem
- ✅ Fixes unintended consequence of earlier commit
- ✅ Already auto-selected for backport (commit 5b2142179744e by Sasha
  Levin)

**Evidence of importance**:
- Linked to RHEL-9065 (Red Hat identified this as significant)
- Part of a series addressing similar audit gaps (see commit
  654d61b8e0e2f for ANOM_*)
- Affects compliance-critical functionality

### 7. Related Context

This fix is part of a broader pattern recognizing that **security events
should be logged differently than regular audit events**:

**Security events** (should log if `audit_enabled`):
- fanotify access control decisions (this commit)
- AUDIT_ANOM_LINK, AUDIT_ANOM_CREAT security violations (commit
  654d61b8e0e2f)
- Other security subsystem reports

**Regular events** (need `!audit_dummy_context()`, i.e., require rules):
- Syscall auditing
- File access tracking
- Most other audit events

### 8. Code References

- Original fanotify audit introduction: de8cd83e91bc3 (2017)
- Problematic check added: 15564ff0a16e2 (2018)
- This fix: ce8370e2e62a9 (2025)
- Already backported as: 5b2142179744e
- Companion ANOM fix: 654d61b8e0e2f
- fanotify call site: fs/notify/fanotify/fanotify.c:282
- Function definition: include/linux/audit.h:528-532

---

## Recommendation

**STRONG YES** - This commit should be backported to stable kernel
trees.

**Justification**:
1. Fixes critical security audit gap with real-world impact (fapolicyd
   users)
2. Minimal, surgical fix with very low regression risk
3. Already identified as important by Red Hat (RHEL-9065) and auto-
   selected by stable maintainers
4. Essential for compliance requirements (Common Criteria, PCI-DSS,
   etc.)
5. Part of a well-understood pattern of fixes for security event logging
6. No architectural changes, no API changes, no performance impact
7. Missing security audit trails are a serious compliance and incident
   response issue

 include/linux/audit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index a394614ccd0b8..e3f06eba9c6e6 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -527,7 +527,7 @@ static inline void audit_log_kern_module(const char *name)
 
 static inline void audit_fanotify(u32 response, struct fanotify_response_info_audit_rule *friar)
 {
-	if (!audit_dummy_context())
+	if (audit_enabled)
 		__audit_fanotify(response, friar);
 }
 
-- 
2.51.0

