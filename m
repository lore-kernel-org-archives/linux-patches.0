Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D716925A642;
	Mon,  9 Jun 2025 13:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476747; cv=none; b=eWMy/niKPXIwweHtG1z9Ez7O8nuBFC28gE8xUVIhmA04mIl1InzjUtGWndrZkLbCUm71nr5Tc6nD9FeuFkfKorcF3y9izuGDXRHUPy1LDw2qWlutGqrPHTxC+vuJX09kR2gcNCpavKNUgjF2A1s9lBK+1TSquhJnR7+g4tNQuxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476747; c=relaxed/simple;
	bh=tFUG8HzIW//IN/0rdoNVAb1477sL9Oo8/9Wu4zkkaoQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsDx68EN0/A9wWeV6wIoF3Ye1EGnvPYXh1GLxKkkoxHz+f0OEUckzp0YW0uwWAU3QpgXbITnqdvlKXclDcmdxSJagYAMbbNst9vzfIEcDDAok00oqmuaz5fy+g6p0BPMw9ia+T3/oiBIbjGZo3KnAfOaNr/RW5Ug1FpT5XStIM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4JVEa62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4JVEa62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3298C4CEED;
	Mon,  9 Jun 2025 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476747;
	bh=tFUG8HzIW//IN/0rdoNVAb1477sL9Oo8/9Wu4zkkaoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4JVEa62HD9cHC+Vaj43Ah7PgalhTMCr9EPVlTVCmKgfi7t1xyF97sl83cepf7YkP
	 idAMgfdbu6cyVYAyJLkBxfDkiyA1gez0SkJolm1w844RUdLsaWb+YNvB/dzS/gwvOc
	 aOghlGLlQ4ZB4xj2Ua2RU8QvNkk1hDJRDF4odKQEIGowBOGR7Swxa1NC9S2vGt5A+B
	 kwtLgqt48S9hNgbdzbqNJghl6A1YYvYK4VpHsZrIeaAwVMyvH2kPLfvvlBQCM1V4dz
	 v1h6dl2wK/U0+26L8Dg5z5qbdtKN8Jqw51KZhSgH8H9mKkZJSdNlCww+dJRLyL3g19
	 6PFZbtV/0qdnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenyuan Yang <chenyuan0y@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	richardcochran@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 19/29] misc: tps6594-pfsm: Add NULL pointer check in tps6594_pfsm_probe()
Date: Mon,  9 Jun 2025 09:45:00 -0400
Message-Id: <20250609134511.1342999-19-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134511.1342999-1-sashal@kernel.org>
References: <20250609134511.1342999-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a99b598d836c9c6411110c70a2da134c78d96e67 ]

The returned value, pfsm->miscdev.name, from devm_kasprintf()
could be NULL.
A pointer check is added to prevent potential NULL pointer dereference.
This is similar to the fix in commit 3027e7b15b02
("ice: Fix some null pointer dereference issues in ice_ptp.c").

This issue is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://lore.kernel.org/r/20250311010511.1028269-1-chenyuan0y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Analysis

### 1. Bug Fix Nature
This commit fixes a clear NULL pointer dereference vulnerability. The
`devm_kasprintf()` function can return NULL on memory allocation
failure, and the code was not checking this return value before using
`pfsm->miscdev.name`. This would lead to a NULL pointer dereference when
`misc_register(&pfsm->miscdev)` is called at line 302.

### 2. Code Analysis
Looking at the specific changes in `drivers/misc/tps6594-pfsm.c`:

**Before the fix (lines 282-283):**
```c
pfsm->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "pfsm-%ld-0x%02x",
                                    tps->chip_id, tps->reg);
```

**After the fix (lines 282-286):**
```c
pfsm->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "pfsm-%ld-0x%02x",
                                    tps->chip_id, tps->reg);
+if (!pfsm->miscdev.name)
+    return -ENOMEM;
```

The fix adds essential NULL pointer checking that prevents potential
kernel crashes.

### 3. Comparison with Similar Commits
This fix follows the exact same pattern as the reference commits marked
as "Backport Status: YES":

- **Similar Commit #1 (ipmi)**: Same issue with `devm_kasprintf()` not
  being checked
- **Similar Commit #2 (mfd: tps6594)**: Same issue, even in the same
  TPS6594 subsystem
- **Similar Commit #4 (ice)**: Same issue, explicitly referenced in the
  commit message

All these similar commits were deemed suitable for backporting because
they fix the same fundamental issue.

### 4. Risk Assessment
- **Minimal risk**: The fix is a simple 2-line addition that only adds
  error checking
- **No side effects**: The change doesn't alter functionality, only
  prevents crashes
- **Contained scope**: Only affects the TPS6594 PFSM driver
  initialization path
- **No architectural changes**: Doesn't modify any interfaces or major
  logic

### 5. Stability Criteria Met
- ✅ **Important bug fix**: Prevents kernel NULL pointer dereference
  crashes
- ✅ **Minimal and contained**: Only 2 lines added for error checking
- ✅ **Low regression risk**: Cannot introduce new issues, only prevents
  crashes
- ✅ **Clear fix**: Addresses a well-defined problem with obvious
  solution

### 6. Driver Context
The TPS6594 PFSM driver was introduced in kernel v6.10, making it a
relatively recent addition. The driver handles power management for TI
PMIC devices, making reliability crucial for system stability.

### 7. Static Analysis Tool Finding
The commit message mentions this was found by static analysis, which
indicates it's a real potential issue that could manifest under memory
pressure conditions.

This commit clearly meets all the criteria for stable tree backporting:
it's a small, contained fix for an important potential crash bug with
minimal risk of regression.

 drivers/misc/tps6594-pfsm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/misc/tps6594-pfsm.c b/drivers/misc/tps6594-pfsm.c
index 0a24ce44cc37c..6db1c9d48f8fc 100644
--- a/drivers/misc/tps6594-pfsm.c
+++ b/drivers/misc/tps6594-pfsm.c
@@ -281,6 +281,9 @@ static int tps6594_pfsm_probe(struct platform_device *pdev)
 	pfsm->miscdev.minor = MISC_DYNAMIC_MINOR;
 	pfsm->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "pfsm-%ld-0x%02x",
 					    tps->chip_id, tps->reg);
+	if (!pfsm->miscdev.name)
+		return -ENOMEM;
+
 	pfsm->miscdev.fops = &tps6594_pfsm_fops;
 	pfsm->miscdev.parent = dev->parent;
 	pfsm->chip_id = tps->chip_id;
-- 
2.39.5

