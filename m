Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982DB289E1E;
	Mon, 14 Jul 2025 23:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534390; cv=none; b=LizwLQWycQJa3oIcE+Ft+2PwlOaxWdFgmwMDaISLmZdK4THjHP8QZ/rktbUPIytN/tj4pcFs8ppZpTPDAjHYIqCsy+E7JrlTo88KvDtpua2IZTtV8U75OG6aUFWyazzT/f4ZNlAoV9B3B5cFkLEOJW0NUeyE3B5Pr22uILXJmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534390; c=relaxed/simple;
	bh=C1k9lU7XeTOf/vBkVFi9Mnm79Lv+pfE5K8WGkyuGhDk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvBGL60glswcrg82Vkb9SyQ5kNz5tlzCiJyIJLa1iYQT/JFaZKkaIRTFSq/r5DSM2N4WaYMKe5ErTdhkAqKrboB32ACGI0XdrE6TtHrg9MqOPkZTbJ73PZo01NYSWgrk/S3fHo6SvSeNupp5EsWMhTMzmKatAaNtChVcY2wM/gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mi0r6v7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mi0r6v7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C917AC4CEED;
	Mon, 14 Jul 2025 23:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534388;
	bh=C1k9lU7XeTOf/vBkVFi9Mnm79Lv+pfE5K8WGkyuGhDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mi0r6v7+RhQkRh1NnLeU1tJCxM10UGat3xkaIPE4Pqy+JKu/qULzMzCNm6XgC/MSB
	 SobC0DVVqcuwg+zr9ohFtm0nBopZGs7MFCDI36A9D0Qdp1z7C2Xu5iy5mpmPbmT4Vd
	 17P36s+Xy8w9d7mTpIcz7IxdwxRqTiHOmhv/ilUEKrp9fJz1qgpaCdhfyRUKvqjM4T
	 0SVjXT9SabKe9UGsrLApfAx+q5Xo1Z7pKoTH1FswpK/5Evhp/bezLCLatqwcqmzVOe
	 sDOwpCSrRZZjoVCgWKUlvig1G+VHa2P1YG1RNXQa7qlUYBscBPWUAI23JkrKmFs3/7
	 uItUJ/dC92jkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sgoutham@marvell.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.15 05/15] net: thunderx: avoid direct MTU assignment after WRITE_ONCE()
Date: Mon, 14 Jul 2025 19:06:06 -0400
Message-Id: <20250714230616.3709521-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230616.3709521-1-sashal@kernel.org>
References: <20250714230616.3709521-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 849704b8b2115647e12436e5076b8e7a4944f21a ]

The current logic in nicvf_change_mtu() writes the new MTU to
netdev->mtu using WRITE_ONCE() before verifying if the hardware
update succeeds. However on hardware update failure, it attempts
to revert to the original MTU using a direct assignment
(netdev->mtu = orig_mtu)
which violates the intended of WRITE_ONCE protection introduced in
commit 1eb2cded45b3 ("net: annotate writes on dev->mtu from
ndo_change_mtu()")

Additionally, WRITE_ONCE(netdev->mtu, new_mtu) is unnecessarily
performed even when the device is not running.

Fix this by:
  Only writing netdev->mtu after successfully updating the hardware.
  Skipping hardware update when the device is down, and setting MTU
  directly. Remove unused variable orig_mtu.

This ensures that all writes to netdev->mtu are consistent with
WRITE_ONCE expectations and avoids unintended state corruption
on failure paths.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250706194327.1369390-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**, this commit should be backported to stable kernel trees.

## Extensive Explanation:

### 1. **This fixes a real bug introduced by incomplete conversion to
WRITE_ONCE()**

The commit message clearly identifies that this fixes a violation of
WRITE_ONCE() protection introduced in commit 1eb2cded45b3. Looking at
the code changes:

```c
// BEFORE - Problematic code:
int orig_mtu = netdev->mtu;
WRITE_ONCE(netdev->mtu, new_mtu);  // Uses WRITE_ONCE

if (!netif_running(netdev))
    return 0;

if (nicvf_update_hw_max_frs(nic, new_mtu)) {
    netdev->mtu = orig_mtu;  // Direct assignment - VIOLATES WRITE_ONCE!
    return -EINVAL;
}
```

This mixing of WRITE_ONCE() and direct assignment breaks the memory
ordering guarantees that WRITE_ONCE() is designed to provide,
potentially causing data races.

### 2. **The fix is minimal and correct**

The fixed code properly ensures all MTU writes use WRITE_ONCE():

```c
// AFTER - Fixed code:
if (netif_running(netdev) && nicvf_update_hw_max_frs(nic, new_mtu))
    return -EINVAL;

WRITE_ONCE(netdev->mtu, new_mtu);  // Only update after HW success
```

The fix:
- Removes the problematic revert path entirely
- Only updates MTU after confirming hardware update succeeds
- Maintains WRITE_ONCE() consistency throughout

### 3. **This affects stable kernels v6.10+**

From my analysis:
- Commit 1eb2cded45b3 that introduced WRITE_ONCE() annotations was
  merged in v6.10-rc1
- This means all stable kernels from v6.10 onwards have the incomplete
  WRITE_ONCE() conversion
- The thunderx driver's error path was missed in that mass conversion

### 4. **The bug has real potential for causing issues**

While the commit message doesn't explicitly state observed failures, the
inconsistent use of WRITE_ONCE() can cause:
- Data races when MTU is read concurrently without locks (using
  READ_ONCE())
- Potential for seeing stale or partially updated MTU values
- Violation of the memory ordering guarantees the kernel depends on

### 5. **Meets all stable kernel criteria**

According to stable kernel rules, this commit:
- ✓ Fixes a bug (data race/memory ordering issue)
- ✓ Is minimal (12 lines changed)
- ✓ Has been reviewed and accepted upstream
- ✓ Doesn't add new features
- ✓ The fix is obviously correct

### 6. **Historical context from similar commits**

Looking at the reference commits provided:
- Similar commit #1 (1eb2cded45b3) with "Backport Status: NO" was the
  mass conversion that introduced WRITE_ONCE() - this was a large change
  touching 153 files
- However, this current commit is different - it's a targeted bug fix
  for an error path that was missed

The fact that the mass conversion wasn't backported doesn't mean
individual bug fixes for violations shouldn't be backported.

### Recommendation:

This commit should be submitted to stable maintainers for inclusion in
v6.10+ stable branches with appropriate Fixes: tag referencing commit
1eb2cded45b3.

 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index aebb9fef3f6eb..1be2dc40a1a63 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1578,7 +1578,6 @@ int nicvf_open(struct net_device *netdev)
 static int nicvf_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct nicvf *nic = netdev_priv(netdev);
-	int orig_mtu = netdev->mtu;
 
 	/* For now just support only the usual MTU sized frames,
 	 * plus some headroom for VLAN, QinQ.
@@ -1589,15 +1588,10 @@ static int nicvf_change_mtu(struct net_device *netdev, int new_mtu)
 		return -EINVAL;
 	}
 
-	WRITE_ONCE(netdev->mtu, new_mtu);
-
-	if (!netif_running(netdev))
-		return 0;
-
-	if (nicvf_update_hw_max_frs(nic, new_mtu)) {
-		netdev->mtu = orig_mtu;
+	if (netif_running(netdev) && nicvf_update_hw_max_frs(nic, new_mtu))
 		return -EINVAL;
-	}
+
+	WRITE_ONCE(netdev->mtu, new_mtu);
 
 	return 0;
 }
-- 
2.39.5

