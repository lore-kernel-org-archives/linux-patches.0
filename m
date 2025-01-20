Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341E71DFDA5;
	Mon, 20 Jan 2025 13:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737378733; cv=none; b=so+vzD0kX7hiZsJE0VIc3htQXPUdMZCdv+5ci8bMIvHIxDK/oGChvrPuPBMyYCje++CY/aPS9VxNGF1gA9bnqF70lZtNSIybXCLNCkybNtZBY5K/z0rP4hklcy0hnVsmkTzcQ/HwAHSRuPNXwyDGlYMIaIL2nfaC7P2F7vgyM00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737378733; c=relaxed/simple;
	bh=1dM/JqbDi9bds19lZgDDhhu34d2sR2mWDItkErvDMWo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=bLlROC7Gad5Rpn1ALvXfpmF5aN2rA0DKYkbKxXBZkWNavWh7o55S25zXQuTClTaBG6Wqy0n0NZKnPA24Aa8rttvbf96eZI89jWfkHk7v0QU8g6xzeG7zfi5EF8ElJRHVQLdvC30MCuZ3DtftxHVmRlbMAbM1x6QMZbtMtm+N2vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HPHChaLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HPHChaLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D7CC4CEDD;
	Mon, 20 Jan 2025 13:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737378732;
	bh=1dM/JqbDi9bds19lZgDDhhu34d2sR2mWDItkErvDMWo=;
	h=From:Date:Subject:To:Cc:From;
	b=HPHChaLVNBQFv8ICY/dxzruF4bJQsv0gPSHIoAzqohUXHEcBMF6eso04im7TBVbyZ
	 nqVeyPEQEcoFpNlfysQPck0DanVhwTB1SEb2uJIhHTCLyCjtWlu6lOJJpeHw4Cz3+y
	 Y1KDtBq3dt+a7fh/nntTzA89OMrIpwm56hHJuC+OnSh7MtnH0ogxnOwOuavLCdBApl
	 PgqRjXOfINmNWjMy3oWMmMRssbcCbAWCACS4oc9oSmqe8TRIdRl+9XN2/uTGN+PGPk
	 nzhmdChvvrRTEqMxb8mlz9WiJwIafkVrS26C4KKKgsy8nJsxd2LWhj6Tz2eLrsceUB
	 FCL43Flmq0+Yw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 20 Jan 2025 06:12:01 -0700
Subject: [PATCH] apparmor: Fix checking address of an array in
 accum_label_info()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-apparmor-pointer-bool-conversion-label-v1-1-5957d28ffde6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAKBLjmcC/x2NQQqDMBAAvyJ77kIS2gb7ldJDTFddiNmwESmIf
 zf2OIeZ2aGSMlV4dTsobVxZcgN76yDOIU+E/G0MzriHsc5gKCXoIopFOK+kOIgkjJI30kvGFAZ
 K6KM1zvfPe/QjtFhRGvn3H70/x3ECY9RvaXgAAAA=
X-Change-ID: 20250120-apparmor-pointer-bool-conversion-label-7c1027964c7f
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 kernel test robot <lkp@intel.com>, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1362; i=nathan@kernel.org;
 h=from:subject:message-id; bh=1dM/JqbDi9bds19lZgDDhhu34d2sR2mWDItkErvDMWo=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl93qt23nyjYiLt/9PE5fau2xzTclu1F1VsWffeLS321
 XGRyBN7O0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEorcx/K8Imn5F3/WUSoLF
 C70py8UdT209v2HH2d8ZaR12+m374lsY/lf9yF/Is9peutJk9YGr5ez2vwJ2PfuZwyBmb/3t2N+
 +DRwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

clang warns:

  security/apparmor/label.c:206:15: error: address of array 'new->vec' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]
    206 |         AA_BUG(!new->vec);
        |                ~~~~~~^~~

The address of this array can never be NULL because it is not at the
beginning of a structure. Convert the assertion to check that the new
pointer is not NULL.

Fixes: de4754c801f4 ("apparmor: carry mediation check on label")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501191802.bDp2voTJ-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index afded9996f61..79be2d3d604b 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -203,7 +203,7 @@ static void accum_label_info(struct aa_label *new)
 	long u = FLAG_UNCONFINED;
 	int i;
 
-	AA_BUG(!new->vec);
+	AA_BUG(!new);
 
 	/* size == 1 is a profile and flags must be set as part of creation */
 	if (new->size == 1)

---
base-commit: e6b087676954e36a7b1ed51249362bb499f8c1c2
change-id: 20250120-apparmor-pointer-bool-conversion-label-7c1027964c7f

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

