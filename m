Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7201C01;
	Wed, 11 Feb 2026 12:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813079; cv=none; b=M8Yfk8GqXlv7XlEFvtvo1LAnvBcjouWBXQb2V6lMGcFcMomvJxX5ZsLDOgdUE4m3fADkl17aTFr3chMaJ/oGqllLR6x9Ts9jfADQM+0ASHq0bEWQkyu+d5tqaGod+6HqmVmjRnDv0RoohTm6SOKJxqL1RXJWtKV1PUdCiYaCeg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813079; c=relaxed/simple;
	bh=l0V/FCET+0rvVQKB3/QX35+eDmPdeP5Awk2zBwIw7b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UeeukuCnZgMVTSARjNFydmdxTw3h2J4e3nsJG/+S31XLiHmZxM036Gs0syMnbi3nbfleK9izIPwyq3mFoINHvnoxp0yxWkNy2IMF090S610wOuF9+U+t2DsP0ODZ1OQknBvoTXaSSsNMPoPcuZERuactfOXkRaJSlQq8PranIBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhHp5q/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhHp5q/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E5C4CEF7;
	Wed, 11 Feb 2026 12:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813079;
	bh=l0V/FCET+0rvVQKB3/QX35+eDmPdeP5Awk2zBwIw7b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhHp5q/KWykIJXEJaPG9fGFep8L7S2un/8Rgym8Q/T2LAknzOK1EjeaofLiVfA9Ra
	 8xeocTlfEiJByjdQfpO1LDAnajXYryAY2nPUwPrhqWV43vz54fj0wFcd5kWNp+80q3
	 YXWv7kldz/FZoTUU4vbsmqs2QNzJhQtSllc9lWu1Q7f/NY60/Fc82CQ09OqsSLvjp9
	 t7gweeWh8ldblN63Qv1X0grMl0WmhUEBCs6U7cpqVLxwuCl/3baW30/aB5Ffmxl0cD
	 EfJkexy44jP7yzNZhS4Ln9IxC83nf5EhZcWug6DYVvQ7PYVSyaoAXOxf8254GPuV5L
	 3z9kukYuIFrhw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	arnd@arndb.de
Subject: [PATCH AUTOSEL 6.19-5.10] xenbus: Use .freeze/.thaw to handle xenbus devices
Date: Wed, 11 Feb 2026 07:30:13 -0500
Message-ID: <20260211123112.1330287-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit e08dd1ee49838750a514e83c0aa60cd12ba6ecbb ]

The goal is to fix s2idle and S3 for Xen PV devices.  A domain resuming
from s3 or s2idle disconnects its PV devices during resume.  The
backends are not expecting this and do not reconnect.

b3e96c0c7562 ("xen: use freeze/restore/thaw PM events for suspend/
resume/chkpt") changed xen_suspend()/do_suspend() from
PMSG_SUSPEND/PMSG_RESUME to PMSG_FREEZE/PMSG_THAW/PMSG_RESTORE, but the
suspend/resume callbacks remained.

.freeze/restore are used with hiberation where Linux restarts in a new
place in the future.  .suspend/resume are useful for runtime power
management for the duration of a boot.

The current behavior of the callbacks works for an xl save/restore or
live migration where the domain is restored/migrated to a new location
and connecting to a not-already-connected backend.

Change xenbus_pm_ops to use .freeze/thaw/restore and drop the
.suspend/resume hook.  This matches the use in drivers/xen/manage.c for
save/restore and live migration.  With .suspend/resume empty, PV devices
are left connected during s2idle and s3, so PV devices are not changed
and work after resume.

Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Acked-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20251119224731.61497-2-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a thorough understanding. Let me summarize my complete
analysis.

---

## Complete Analysis

### 1. Commit Message Analysis

The commit explicitly states its goal: **fix s2idle and S3 for Xen PV
devices**. The problem is clearly described: when a Xen domain resumes
from S3 or s2idle, PV devices are disconnected and the backends refuse
to reconnect, leaving them broken.

The commit references the 2011 commit `b3e96c0c7562` which changed
`do_suspend()` in `manage.c` to use
`PMSG_FREEZE`/`PMSG_THAW`/`PMSG_RESTORE` instead of
`PMSG_SUSPEND`/`PMSG_RESUME`, but the xenbus frontend PM callbacks were
never updated to match — they still had `.suspend`/`.resume` populated.

### 2. Code Change Analysis

The change modifies only the `xenbus_pm_ops` structure in
`xenbus_probe_frontend.c`:

**Before:**
```150:156:drivers/xen/xenbus/xenbus_probe_frontend.c
static const struct dev_pm_ops xenbus_pm_ops = {
        .suspend        = xenbus_dev_suspend,
        .resume         = xenbus_frontend_dev_resume,
        .freeze         = xenbus_dev_suspend,
        .thaw           = xenbus_dev_cancel,
        .restore        = xenbus_dev_resume,
};
```

**After (proposed):**
```c
static const struct dev_pm_ops xenbus_pm_ops = {
        .freeze         = xenbus_dev_suspend,
        .thaw           = xenbus_dev_cancel,
        .restore        = xenbus_frontend_dev_resume,
};
```

Three changes:
1. **Remove `.suspend = xenbus_dev_suspend`**: During S3/s2idle, the PM
   core dispatches `PM_EVENT_SUSPEND` to `.suspend`. By removing it, PV
   devices are no longer disconnected during S3/s2idle.
2. **Remove `.resume = xenbus_frontend_dev_resume`**: No reconnection
   attempt during S3/s2idle resume (nothing was disconnected, so nothing
   needs reconnecting).
3. **Change `.restore` from `xenbus_dev_resume` to
   `xenbus_frontend_dev_resume`**: This fixes a second bug -
   `xenbus_frontend_dev_resume` properly handles the case where
   xenstored runs locally (`XS_LOCAL`) by deferring the resume via a
   work queue. The old `xenbus_dev_resume` would hang in that case
   during restore.

### 3. PM Dispatch Verification

The PM core's `pm_op()` function in `drivers/base/power/main.c` confirms
the dispatch logic:
- `PM_EVENT_SUSPEND` → `.suspend` (used for real S3/s2idle)
- `PM_EVENT_FREEZE` → `.freeze` (used by Xen save/restore via
  `do_suspend()`)
- `PM_EVENT_THAW` → `.thaw` (Xen cancelled restore)
- `PM_EVENT_RESTORE` → `.restore` (Xen successful restore)

The Xen save/restore/migration path in `drivers/xen/manage.c`
exclusively uses `PMSG_FREEZE`/`PMSG_THAW`/`PMSG_RESTORE`:

```117:117:drivers/xen/manage.c
        err = dpm_suspend_start(PMSG_FREEZE);
```

```147:147:drivers/xen/manage.c
        dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
```

This confirms: Xen save/restore uses `.freeze`/`.thaw`/`.restore`, NOT
`.suspend`/`.resume`. The removal of `.suspend`/`.resume` does not
affect Xen save/restore at all.

### 4. Bug Mechanism

The bug is a **functional regression** dating back to the original 2011
commit `b3e96c0c7562`:
- `do_suspend()` was changed to use `PMSG_FREEZE`
- But `xenbus_pm_ops` kept `.suspend`/`.resume` populated
- When S3/s2idle is used (which triggers `PMSG_SUSPEND`→`.suspend`),
  `xenbus_dev_suspend` is called, which disconnects PV devices
- On resume, `xenbus_frontend_dev_resume` tries to reconnect, but the
  backend doesn't expect the disconnect and refuses to reconnect
- **Result: PV devices are broken after S3/s2idle**

### 5. Self-Containedness

Despite the Message-ID suggesting patch 2 of a series (`-2-`), this
commit is entirely self-contained:
- It modifies only one data structure
- All referenced functions already exist in the codebase
- No new code is introduced
- It does not depend on other patches

### 6. Risk Assessment

**Very low risk:**
- The change removes behavior (empties `.suspend`/`.resume`), which is
  strictly less likely to cause regression than adding behavior
- During S3/s2idle, devices simply stay connected — the safest possible
  behavior
- The `.restore` change to `xenbus_frontend_dev_resume` is strictly an
  improvement (adds XS_LOCAL handling that was already done for
  `.resume`)
- Change is only 3 lines in one structure
- Acked by Xen subsystem maintainer (Juergen Gross)
- Also signed off by Juergen Gross as the committer

### 7. Impact

- **Who is affected**: All Xen PV guests attempting S3/s2idle
- **Severity**: HIGH - PV devices completely break after resume, meaning
  network and block devices stop working
- **User visibility**: Very visible - domain becomes unusable after
  suspend/resume

### 8. Stable Tree Applicability

- The affected code (`xenbus_pm_ops` structure) has been stable since
  2011/2013
- All referenced functions exist in all maintained stable trees
- The patch applies cleanly (trivial change to a stable structure)
- This fixes a longstanding functional bug affecting real use cases

### 9. Classification

This is a **bug fix** for broken S3/s2idle on Xen PV domains, with an
additional fix for potential hang during restore with local xenstored.
It meets all stable criteria:
- Obviously correct and well-reviewed (Acked-by subsystem maintainer)
- Fixes a real, user-facing bug (broken PV devices)
- Important issue (complete loss of PV device functionality)
- Very small and contained (3 lines in one structure)
- No new features or APIs

**YES**

 drivers/xen/xenbus/xenbus_probe_frontend.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe_frontend.c b/drivers/xen/xenbus/xenbus_probe_frontend.c
index 6d1819269cbe5..199917b6f77ca 100644
--- a/drivers/xen/xenbus/xenbus_probe_frontend.c
+++ b/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -148,11 +148,9 @@ static void xenbus_frontend_dev_shutdown(struct device *_dev)
 }
 
 static const struct dev_pm_ops xenbus_pm_ops = {
-	.suspend	= xenbus_dev_suspend,
-	.resume		= xenbus_frontend_dev_resume,
 	.freeze		= xenbus_dev_suspend,
 	.thaw		= xenbus_dev_cancel,
-	.restore	= xenbus_dev_resume,
+	.restore	= xenbus_frontend_dev_resume,
 };
 
 static struct xen_bus_type xenbus_frontend = {
-- 
2.51.0

