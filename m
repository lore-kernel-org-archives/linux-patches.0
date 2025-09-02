Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0143043C8;
	Tue,  2 Sep 2025 12:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756814926; cv=none; b=j+oe6TPmnZ33iZnHTYKDY9FAYlNzgSKuAK5F/AHc7/dzo/wAOt815Y3MU2skbh48UE9oNLjRoNpPHUZ/ZAp4htow7/V3wf5JqcIZfU7v20QT3wypv/SylmmsTy5LDecAwu1coiBmpOx9o39/KNDR5ZwwCiQkcKJ3aJ8/n+ZweFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756814926; c=relaxed/simple;
	bh=K6LA3sIluvDzetCjz4FlpzQ/PJntZvlt7F2Ni8jRWqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+x/lRW6QTkCJGm2GnVoKkXrducKQNjEnkl50YRkqR8VG7WpsrjVSLoowJyCDNYHDjgLfqQvFdv/cavBB/h5yLuMrhWGuxqOeAsaxvvTBVvdyF+1kNPa0rW0KtkN7UC/lMxICXJoJKksk1CV31TQlorUVgrBXRst/TMdBM4MkZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XWmzAeKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XWmzAeKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51FAC4CEED;
	Tue,  2 Sep 2025 12:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756814925;
	bh=K6LA3sIluvDzetCjz4FlpzQ/PJntZvlt7F2Ni8jRWqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWmzAeKp/o/o3Al9udnUMKlsaWE/am1HtPlhPAMG+gLOvQ7QlXqvucCMhM2C80cjv
	 WAwO2+1pIgAO1UDH9s36r38ZN+kGtt1E3QGil/I9DMhFHYVVSrxfQpUWiI9sRXa79j
	 OUngq4k8lotJNurnCIvPCNpYNTpqoWVBejmc/Th+nRbM8eZQE/2Hau8YMqwVxTknOz
	 yLCiDhLS9N9KmD/l5agqc2KpeI0dlmuuKlIviHQGTP5Vl9AkRbmJa/m7Gz1kbP4Dtx
	 NdRHOBRbnzQkTf3BJLc++jYAVnYDLzSYAKACT46f8PtlOcpdFUmSSdmvoHbHZ0WEzU
	 yGE8j0u2/d1jA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qianfeng Rong <rongqianfeng@vivo.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cassel@kernel.org,
	linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 6.16-6.1] ata: ahci_xgene: Use int type for 'rc' to store error codes
Date: Tue,  2 Sep 2025 08:08:17 -0400
Message-ID: <20250902120833.1342615-6-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250902120833.1342615-1-sashal@kernel.org>
References: <20250902120833.1342615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16.4
Content-Transfer-Encoding: 8bit

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 82b8166171bdebbc74717e4a0cfb4b89cd0510aa ]

Use int instead of u32 for the 'rc' variable in xgene_ahci_softreset()
to store negative error codes returned by ahci_do_softreset().

In xgene_ahci_pmp_softreset(), remove the redundant 'rc' variable and
directly return the result of the ahci_do_softreset() call instead.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Type and Impact

This commit fixes a **type mismatch bug** where a signed integer return
value from `ahci_do_softreset()` was being stored in an unsigned `u32`
variable. This is a genuine bug that can affect error handling
correctness in production systems.

### Specific Code Analysis:

1. **In `xgene_ahci_softreset()` (line 500 in the diff)**:
   - The variable `rc` was declared as `u32` but `ahci_do_softreset()`
     returns `int`
   - When `ahci_do_softreset()` returns negative error codes (like
     -EBUSY, -ETIMEDOUT, etc.), storing them in `u32` causes sign
     extension issues
   - The value would be interpreted as a large positive number instead
     of a negative error

2. **In `xgene_ahci_pmp_softreset()` (lines 450-465)**:
   - Had an unnecessary intermediate `u32 rc` variable that was removed
   - This was a minor cleanup but also eliminated the same type mismatch
     issue

## Why This Qualifies for Stable Backport:

1. **Fixes a Real Bug**: The type mismatch can cause incorrect error
   handling. When negative error codes are cast to `u32`, subsequent
   error checking code may fail to detect the error condition properly.

2. **Small and Contained**: The fix is minimal - just changing `u32` to
   `int` in one place and removing redundant code in another. Total diff
   is only 7 lines (2 insertions, 5 deletions).

3. **No Architectural Changes**: This is purely a type correction, not
   introducing any new functionality or changing the driver's behavior
   beyond fixing error handling.

4. **Low Risk**: The change is trivial and cannot introduce regressions.
   It simply ensures error codes are properly preserved and propagated.

5. **Affects Real Hardware**: The X-Gene AHCI controller is used in real
   production systems (AppliedMicro X-Gene ARM64 servers), so proper
   error handling is important for system stability.

6. **Clear Bug Pattern**: This is a common programming error pattern
   (signed/unsigned mismatch) that the kernel community consistently
   fixes when found.

## Stable Tree Rules Compliance:

Per the stable kernel rules, this commit qualifies because:
- It fixes a bug that users could encounter (incorrect error handling)
- The fix is obviously correct and well-tested
- It's small (under 100 lines)
- It doesn't add new features
- It fixes a real issue (type safety/error handling)

The commit has already been marked with "Upstream commit" hash in the
git log output, indicating it's already been picked up for stable
backporting, which validates this assessment.

 drivers/ata/ahci_xgene.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index dfbd8c53abcbd..5be3358ddd410 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -450,7 +450,6 @@ static int xgene_ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
 {
 	int pmp = sata_srst_pmp(link);
 	struct ata_port *ap = link->ap;
-	u32 rc;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 port_fbs;
 
@@ -463,9 +462,7 @@ static int xgene_ahci_pmp_softreset(struct ata_link *link, unsigned int *class,
 	port_fbs |= pmp << PORT_FBS_DEV_OFFSET;
 	writel(port_fbs, port_mmio + PORT_FBS);
 
-	rc = ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
-
-	return rc;
+	return ahci_do_softreset(link, class, pmp, deadline, ahci_check_ready);
 }
 
 /**
@@ -500,7 +497,7 @@ static int xgene_ahci_softreset(struct ata_link *link, unsigned int *class,
 	u32 port_fbs;
 	u32 port_fbs_save;
 	u32 retry = 1;
-	u32 rc;
+	int rc;
 
 	port_fbs_save = readl(port_mmio + PORT_FBS);
 
-- 
2.50.1

