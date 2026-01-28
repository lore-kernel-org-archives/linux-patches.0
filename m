Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C23326927;
	Wed, 28 Jan 2026 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639629; cv=none; b=ZVbMIJfQzOowusgSG0YDLYLIWwf6M2NqyiLkk3Z+rJT3b+EDSCc/NfXRHewin/i8+7v/7KVUBIm8hVrWBRJ2LwBb9hJ6Yj4vm8BKdlDSh0zc4IANB4Vm939Su0DtMUwC4p9TBnAGKcTwsCRuYzUqyuLWr+C5LFuddVUkGi1MYIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639629; c=relaxed/simple;
	bh=keMkaY4XqPcIvLRBPVo/lj1Ecpi9S0ehwNCbG204tYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UzuMGvGMTeOzfpeCpAqKQ+sAYhlzQ5j2q6Bq7m7qJ+OAIpLdX6+3oi+dOTD2e6sL747NI8N8WpH1gjqjw/HgueQFmwqK67xX/bspBJs2A9IEecwpT8XaRAce3QhdY6TSyErPMpsE60SHRIg/MJEUyxrS5U0S93SHSHjiy1jEmW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSyj9OP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSyj9OP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BE7C4CEF7;
	Wed, 28 Jan 2026 22:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769639629;
	bh=keMkaY4XqPcIvLRBPVo/lj1Ecpi9S0ehwNCbG204tYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSyj9OP56wnyWgFvaTs/gklCn3pLd7g4fBZtJb4gdzPaIKdHUuTJEmEDZ2idiKmOf
	 OmpG3f7oK7TpZnOMb46N7CUkEVJuxUDlzYQFxLBNnMF279mnrEZUNYXgkIvJ2sLZjP
	 ucQNgXafV2QK+2DLArbLKmuEx5DnPkrzaJ6/FjxKs1Ho53t1rqQFlOjKqiC+UvpUlg
	 XOOWAr9ZNnmB7w0koFSgWX///TdCr7JewzHOOOBnvO2ZK5hn4Doh8BvD3O00StosC8
	 ZDlJUM5+KPckbLVgPY4EnX03pUSalDQeISr33Odu9CnUmXC2S5CqK73qc1YtwclWXe
	 AQQ4mBjYSEuag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Zhaojuan Guo <zguo@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: target: iscsi: Fix use-after-free in iscsit_dec_session_usage_count()
Date: Wed, 28 Jan 2026 17:33:06 -0500
Message-ID: <20260128223332.2806589-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260128223332.2806589-1-sashal@kernel.org>
References: <20260128223332.2806589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84dc6037390b8607c5551047d3970336cb51ba9a ]

In iscsit_dec_session_usage_count(), the function calls complete() while
holding the sess->session_usage_lock. Similar to the connection usage count
logic, the waiter signaled by complete() (e.g., in the session release
path) may wake up and free the iscsit_session structure immediately.

This creates a race condition where the current thread may attempt to
execute spin_unlock_bh() on a session structure that has already been
deallocated, resulting in a KASAN slab-use-after-free.

To resolve this, release the session_usage_lock before calling complete()
to ensure all dereferences of the sess pointer are finished before the
waiter is allowed to proceed with deallocation.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260112165352.138606-3-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Excellent! Now I have a complete understanding. Let me summarize my
analysis:

## ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly describes:
- **Bug type:** Use-after-free (UAF)
- **Root cause:** `complete()` is called while holding
  `sess->session_usage_lock`, but the waiter (in session release path)
  may wake up and call `kfree(sess)` before the lock is released
- **Detection:** KASAN slab-use-after-free
- **Fix:** Release the lock before calling `complete()`
- **Tags:**
  - `Reported-by:` - indicates a real bug report
  - `Reviewed-by: Mike Christie` - credible reviewer for SCSI/iSCSI
    target code

### 2. CODE CHANGE ANALYSIS

**The bug mechanism:**
1. Thread A calls `iscsit_dec_session_usage_count()`, decrements count
   to 0
2. Thread A calls `complete()` while still holding
   `sess->session_usage_lock`
3. Thread B (waiting in `iscsit_check_session_usage_count()`) wakes up
   from `wait_for_completion()`
4. Thread B continues to `iscsit_close_session()` → `kfree(sess)` at
   line 4519
5. Thread A tries to call `spin_unlock_bh(&sess->session_usage_lock)` on
   freed memory → **UAF**

**The fix:**
- Releases the spinlock *before* calling `complete()`
- Uses early return to avoid double-unlock
- This is a standard pattern for avoiding UAF when completion wakes up a
  free-er

**Size:** +4 lines changed, -1 line changed = 3 net lines. Very small
and surgical.

### 3. CLASSIFICATION

- **Bug fix:** Yes, fixes a clear use-after-free
- **Security:** Use-after-free bugs can potentially be exploited for
  privilege escalation or code execution, though this one is in iSCSI
  target code which requires privileged access to configure
- **Severity:** HIGH - UAF can cause kernel crashes (KASAN detected) and
  potential security issues

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~5 lines (minimal)
- **Files touched:** 1 file (`drivers/target/iscsi/iscsi_target_util.c`)
- **Complexity:** Very low - simply reorders lock release and complete()
  call
- **Subsystem:** iSCSI target - mature, widely used for storage
- **Risk:** Very LOW - the fix is semantically identical (unlock happens
  either way), just changes order

### 5. USER IMPACT

- **Affected users:** Anyone using Linux iSCSI target (LIO) with active
  session teardown
- **Severity if hit:** Kernel crash/panic, or potentially worse
  (security issue)
- **Likelihood:** Race condition, so timing-dependent, but clearly can
  be triggered (reported by Red Hat engineer with KASAN)

### 6. STABILITY INDICATORS

- `Reviewed-by: Mike Christie <michael.christie@oracle.com>` - Mike
  Christie is a well-known SCSI subsystem maintainer/contributor
- `Reported-by:` tag indicates this is a real-world bug
- Accepted by Martin K. Petersen (SCSI maintainer)

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The `session_usage_lock`, `session_waiting_on_uc`, and completion
  structure exist in all stable trees (they're fundamental to iSCSI
  target operation)
- Clean, standalone fix

### CONCLUSION

This commit is an **ideal candidate for stable backport**:

1. **Fixes a real, serious bug:** Use-after-free detected by KASAN,
   reported by Red Hat
2. **Obviously correct:** Standard pattern of "unlock before complete
   when waiter frees the object"
3. **Small and contained:** Only 5 lines changed in one function
4. **No new features:** Pure bug fix
5. **Low risk:** The change is semantically equivalent (lock must be
   released anyway), just changes order
6. **Wide impact:** iSCSI target is widely deployed in enterprise
   storage environments
7. **Reviewed by expert:** Mike Christie is a recognized SCSI expert

The fix follows the well-established pattern seen in many similar fixes
throughout the kernel where a completion must not be signaled while
holding a lock that protects the structure being freed by the waiter.

**YES**

 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5e6cf34929b55..262a3e76b4b1c 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -741,8 +741,11 @@ void iscsit_dec_session_usage_count(struct iscsit_session *sess)
 	spin_lock_bh(&sess->session_usage_lock);
 	sess->session_usage_count--;
 
-	if (!sess->session_usage_count && sess->session_waiting_on_uc)
+	if (!sess->session_usage_count && sess->session_waiting_on_uc) {
+		spin_unlock_bh(&sess->session_usage_lock);
 		complete(&sess->session_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&sess->session_usage_lock);
 }
-- 
2.51.0

