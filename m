Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95B95680;
	Wed, 23 Jul 2025 00:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753232358; cv=none; b=YcUPLfmwW/R7M4nLDz5wotIrAKdDygVr4NfRK1WAcoPVkVCXlKYTvxUQkTZjm9PgSp5xMrNkRVyDc8+gf3F0M2tevuUa+U3R+KfIwcnqhZXsbosfGJp9V1P4/rj3AqEvZNpl2mjtL+7aqcjFgZa6XKFFHwLp2phxyyZRkUAmoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753232358; c=relaxed/simple;
	bh=iliY3dH9H+r0GsYhAfrCue/1gSYXXq38oFDrKAbeCp0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qJtA43z8mrZKXMZ2sW7/ylDbxPsV6ncW0HnVQofR6rltdhWp5EH0/KOl7EUj80mTKyDzLd9Ms9wuw46fiB/2B8pYzZFVN1UUuMySSi562lxNU2WbdVDTaRHI9eOAkCPg7JOXsDQ7b/3AfeXkCmiRKJ5rYNxJYEQ4bSP2nDxD3Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4Jo9yq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4Jo9yq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125E1C4CEEB;
	Wed, 23 Jul 2025 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753232358;
	bh=iliY3dH9H+r0GsYhAfrCue/1gSYXXq38oFDrKAbeCp0=;
	h=From:To:Cc:Subject:Date:From;
	b=f4Jo9yq1AI8EVUlrBSNzKcARuCoBtHm/pEecQ7jwpSu7CF1rZ/X5wModIrM2kIYRM
	 hmHXl0HK20dGCEjMWbWfRtuICdWbOSi8mvLrpdoGRTe4gXY9OGhhvEHaUka2lNwCOc
	 4YOVIl0o9IKE4qHAPKR/YBWCfvbxgYmoDj1R6WEZmyixHu2bw3T+HWLZTlp+eawExr
	 J+sWDai/183wEUNYFYciMVeMA7Rz5vNmxRl0AuKNw+rucVrm8tQKRI+z67158Q3zNB
	 m7tkxzAr5CpwcJGX1ni0mGYSxE95KPOuLmPOcrdwwOb1stZGOVzaSNfdc6zGs3ax7x
	 cTWUXfzIjliKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"David S . Miller" <davem@davemloft.net>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 5.15 1/2] ethernet: intel: fix building with large NR_CPUS
Date: Tue, 22 Jul 2025 20:59:12 -0400
Message-Id: <20250723005914.1023567-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 24171a5a4a952c26568ff0d2a0bc8c4708a95e1d ]

With large values of CONFIG_NR_CPUS, three Intel ethernet drivers fail to
compile like:

In function ‘i40e_free_q_vector’,
    inlined from ‘i40e_vsi_alloc_q_vectors’ at drivers/net/ethernet/intel/i40e/i40e_main.c:12112:3:
  571 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
include/linux/rcupdate.h:1084:17: note: in expansion of macro ‘BUILD_BUG_ON’
 1084 |                 BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096);    \
drivers/net/ethernet/intel/i40e/i40e_main.c:5113:9: note: in expansion of macro ‘kfree_rcu’
 5113 |         kfree_rcu(q_vector, rcu);
      |         ^~~~~~~~~

The problem is that the 'rcu' member in 'q_vector' is too far from the start
of the structure. Move this member before the CPU mask instead, in all three
drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Compilation Failure Fix**: This fixes a build-time compilation
   failure that occurs with large values of CONFIG_NR_CPUS. The error
   prevents the kernel from building successfully, which is a
   significant issue for systems configured with high CPU counts.

2. **Root Cause**: The issue stems from the `kfree_rcu()` macro in
   `include/linux/rcupdate.h:1084` which includes a
   `BUILD_BUG_ON(offsetof(typeof(*(ptr)), rhf) >= 4096)` check. This
   compile-time assertion ensures that the RCU head field is within the
   first 4096 bytes of the structure.

3. **Simple and Safe Fix**: The fix is straightforward - it moves the
   `struct rcu_head rcu` member earlier in the structure, placing it
   before the `cpumask_t affinity_mask` member. This is a safe change
   because:
   - It only reorders structure members
   - The RCU head doesn't need to be at any specific location
     functionally
   - Moving it earlier reduces the offset from the structure start
   - No functional code changes are required

4. **Affects Multiple Drivers**: The issue affects three Intel ethernet
   drivers (i40e, ixgbe, fm10k), all of which are fixed identically by
   moving the rcu member earlier in their respective q_vector
   structures.

5. **Configuration-Dependent Bug**: This bug only manifests with large
   CONFIG_NR_CPUS values (likely >= 512 or higher), where the
   `cpumask_t` type becomes large enough to push the rcu member beyond
   the 4096-byte offset limit. Systems with high core counts are
   becoming more common in production environments.

6. **No Risk of Regression**: The change is minimal and doesn't alter
   any functionality. It's purely a structural reordering that maintains
   all existing behavior while fixing the compilation issue.

7. **Meets Stable Criteria**: This fix clearly meets the stable kernel
   criteria as it:
   - Fixes a real bug (compilation failure)
   - Is minimal and contained
   - Has no risk of introducing new issues
   - Affects users with legitimate configurations

The commit is an excellent candidate for stable backporting as it fixes
a real compilation issue that prevents kernel builds on systems with
large CPU counts, and the fix is trivial with no risk of regression.

 drivers/net/ethernet/intel/fm10k/fm10k.h | 3 ++-
 drivers/net/ethernet/intel/i40e/i40e.h   | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k.h b/drivers/net/ethernet/intel/fm10k/fm10k.h
index 6119a41088381..65a2816142d96 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k.h
@@ -189,13 +189,14 @@ struct fm10k_q_vector {
 	struct fm10k_ring_container rx, tx;
 
 	struct napi_struct napi;
+	struct rcu_head rcu;	/* to avoid race with update stats on free */
+
 	cpumask_t affinity_mask;
 	char name[IFNAMSIZ + 9];
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dbg_q_vector;
 #endif /* CONFIG_DEBUG_FS */
-	struct rcu_head rcu;	/* to avoid race with update stats on free */
 
 	/* for dynamic allocation of rings associated with this q_vector */
 	struct fm10k_ring ring[] ____cacheline_internodealigned_in_smp;
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index a143440f3db62..223d5831a5bbe 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -961,6 +961,7 @@ struct i40e_q_vector {
 	u16 reg_idx;		/* register index of the interrupt */
 
 	struct napi_struct napi;
+	struct rcu_head rcu;	/* to avoid race with update stats on free */
 
 	struct i40e_ring_container rx;
 	struct i40e_ring_container tx;
@@ -971,7 +972,6 @@ struct i40e_q_vector {
 	cpumask_t affinity_mask;
 	struct irq_affinity_notify affinity_notify;
 
-	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[I40E_INT_NAME_STR_LEN];
 	bool arm_wb_state;
 	bool in_busy_poll;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 737590a0d849e..09f7a3787f272 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -458,9 +458,10 @@ struct ixgbe_q_vector {
 	struct ixgbe_ring_container rx, tx;
 
 	struct napi_struct napi;
+	struct rcu_head rcu;	/* to avoid race with update stats on free */
+
 	cpumask_t affinity_mask;
 	int numa_node;
-	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[IFNAMSIZ + 9];
 
 	/* for dynamic allocation of rings associated with this q_vector */
-- 
2.39.5

