Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3EE244186;
	Mon,  2 Feb 2026 21:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068826; cv=none; b=pBVI1G4Xr+tSB0mvUbe0NkXaurxHKXrqzDkimjrxCIlHXS4q8OqJh5CAhekRuFfjCdHpdBQPbNChK3umMIYdCIHVQJaNTm9625GULFd6vSY5x1apJvv/+XinJecc7se/Q/dxbTzDvPCJMoT12c/KBgGyr8qnWy5+vNY7O8ie5JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068826; c=relaxed/simple;
	bh=XPLLLQzpIAooc5kDBIwtZy3yzmxAdYstw8fdD46YujE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jj1df0UYQXBcfwIOm64Ts+jsab82aXEwjyOn7YqYEj1ONyC6FlSb0cu9QH19gLlcUouTNyWE/muGIgoA0huPMzAg/4E4aBNVl8jhAdZTNeDNQ2M7+WkCInZMxLRZb5RgBOyCLvWo/0W0DHVbrSjUacSlnawnIHGx8V0gTkQ+N6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p9Vndd7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p9Vndd7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649F5C19421;
	Mon,  2 Feb 2026 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068826;
	bh=XPLLLQzpIAooc5kDBIwtZy3yzmxAdYstw8fdD46YujE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9Vndd7KeVU5/UE2/ZbXb1o85k1stDQHIXvOrExJgkC/jmPDinuAR5PEhkl+QRb/T
	 60uUv+tnki9OiuArDEINBlo4rRPAskIDPiurDgNMhYg3Xk+5orX0yfaqjYY1/58rUZ
	 sd54XJ/SqMahDqgnAyq6Tn5gEsqT43dtImlleYPVYzsOthppvS/HNOld65pAqR32BO
	 LeL35kiur+hqqBsqi/0DdrwmwKRilM9bLT0DPQ0SSDLsm7/Xny2nobw97+9HM9bPb2
	 1GYF0DZAYpvvfEgjczXCPBvIr088retb8AgB6l4oQQW9CRVG0fqbKkJDkKwTuUyJ51
	 45V873pQ+YQaw==
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
Subject: [PATCH AUTOSEL 6.18-5.10] scsi: target: iscsi: Fix use-after-free in iscsit_dec_conn_usage_count()
Date: Mon,  2 Feb 2026 16:46:05 -0500
Message-ID: <20260202214643.212290-10-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 9411a89e9e7135cc459178fa77a3f1d6191ae903 ]

In iscsit_dec_conn_usage_count(), the function calls complete() while
holding the conn->conn_usage_lock. As soon as complete() is invoked, the
waiter (such as iscsit_close_connection()) may wake up and proceed to free
the iscsit_conn structure.

If the waiter frees the memory before the current thread reaches
spin_unlock_bh(), it results in a KASAN slab-use-after-free as the function
attempts to release a lock within the already-freed connection structure.

Fix this by releasing the spinlock before calling complete().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reported-by: Zhaojuan Guo <zguo@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260112165352.138606-2-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the race condition analysis perfectly:
1. `iscsit_check_conn_usage_count(conn)` waits for usage count to become
   0
2. Once it returns (after `complete()` is called), it immediately calls
   `iscsit_free_conn(conn)` at line 4363
3. If the decrementer thread hasn't released the spinlock yet, it will
   try to `spin_unlock_bh()` on freed memory

### FINAL ASSESSMENT

**Why this should be backported:**

1. **Fixes a real, reproducible bug:** The commit explicitly mentions
   KASAN detection and has a "Reported-by" tag, confirming this is a
   real issue that was hit in practice.

2. **Serious bug type:** Use-after-free is a critical memory safety bug
   that can cause:
   - Kernel panics/crashes
   - Data corruption
   - Potential security exploits (UAF is a common attack vector)

3. **Obvious correctness:** The fix follows the well-known pattern of
   "unlock before complete" which is the standard way to avoid this
   class of race conditions. The code change is straightforward and the
   logic is preserved.

4. **Small and contained:**
   - Only 6 lines changed
   - Single function modified
   - No new APIs or features
   - Self-contained fix

5. **Low regression risk:** The change only reorders operations (unlock
   before complete instead of after). The same checks are made, same
   operations performed.

6. **Affects production systems:** iSCSI target code is used in
   enterprise storage environments where kernel crashes are
   unacceptable.

7. **Long-standing code:** The affected function has been in the kernel
   since 2011, meaning all stable trees contain this vulnerable code.

8. **Expert review:** Reviewed by Mike Christie (iSCSI maintainer) and
   signed off by Martin K. Petersen (SCSI maintainer).

9. **Clean backport expected:** No dependencies on other commits, the
   fix is self-contained and should apply cleanly to all stable trees.

**Risk assessment:** MINIMAL. The fix is a classic pattern, well-
reviewed, and doesn't change functionality.

**YES**

 drivers/target/iscsi/iscsi_target_util.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 262a3e76b4b1c..c1888c42afdd5 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -813,8 +813,11 @@ void iscsit_dec_conn_usage_count(struct iscsit_conn *conn)
 	spin_lock_bh(&conn->conn_usage_lock);
 	conn->conn_usage_count--;
 
-	if (!conn->conn_usage_count && conn->conn_waiting_on_uc)
+	if (!conn->conn_usage_count && conn->conn_waiting_on_uc) {
+		spin_unlock_bh(&conn->conn_usage_lock);
 		complete(&conn->conn_waiting_on_uc_comp);
+		return;
+	}
 
 	spin_unlock_bh(&conn->conn_usage_lock);
 }
-- 
2.51.0

