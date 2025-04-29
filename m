Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAA1DF73C;
	Tue, 29 Apr 2025 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946307; cv=none; b=XTE8ZdzwHZyqMaZDbB56Icw3F+BpNIkL5xzi62nUsnMwv87ApNPcYOd9HpbpFsKUClNC1P1WpU7P8fWj1P+AkTgi8iXfufA9xl4bh4pBeEko+NdkJiCCq/h+enlS/jrWnT3D+DDaRIyV0Zkl/d1ta3qGNH8WyctTTnRNRZItDhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946307; c=relaxed/simple;
	bh=KkqRLkXccLXVR/9dL3hnWHCoRBfCEBPvzn6lPtK88Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgFk3XxfzJoD5DUmXlDlU91Td/lW0xohR+k4x/h8um4s8JyM171yEi2QhbUSFo2Ig/WGIxSPdvti0BO2WrP/RBw+baA2HMFhbgt3aX2t0d491o5ArYyWLPUkfkleQ3qhk4qJ8bssiaDkzdrt9QFC1XLm02rJHQgc5qkL/Javjzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESsg901/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESsg901/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3374C4CEE3;
	Tue, 29 Apr 2025 17:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946307;
	bh=KkqRLkXccLXVR/9dL3hnWHCoRBfCEBPvzn6lPtK88Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESsg901/oqLuOO5oOm5GdjIGpdW1+J9iWyoBgE+1AEcXHr9NhemIJi8zoA0zFcxr0
	 GZdu/NnrSq3C58k86d2B+7DDTIghNOEKqSPh0wGtSSObntQj7Tmqe2eeaAbvGIck7T
	 BHID5VowNygjQ5njJStJknnkmh/akiDnyd2jUYP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 224/311] objtool, regulator: rk808: Remove potential undefined behavior in rk806_set_mode_dcdc()
Date: Tue, 29 Apr 2025 18:41:01 +0200
Message-ID: <20250429161130.193715176@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 29c578c848402a34e8c8e115bf66cb6008b77062 ]

If 'ctr_bit' is negative, the shift counts become negative, causing a
shift of bounds and undefined behavior.

Presumably that's not possible in normal operation, but the code
generation isn't optimal.  And undefined behavior should be avoided
regardless.

Improve code generation and remove the undefined behavior by converting
the signed variables to unsigned.

Fixes the following warning with an UBSAN kernel:

  vmlinux.o: warning: objtool: rk806_set_mode_dcdc() falls through to next function rk806_get_mode_dcdc()
  vmlinux.o: warning: objtool: .text.rk806_set_mode_dcdc: unexpected end of section

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/2023abcddf3f524ba478d64339996f25dc4097d2.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503182350.52KeHGD4-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rk808-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 7d82bd1b36dfc..1e8142479656a 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -270,8 +270,8 @@ static const unsigned int rk817_buck1_4_ramp_table[] = {
 
 static int rk806_set_mode_dcdc(struct regulator_dev *rdev, unsigned int mode)
 {
-	int rid = rdev_get_id(rdev);
-	int ctr_bit, reg;
+	unsigned int rid = rdev_get_id(rdev);
+	unsigned int ctr_bit, reg;
 
 	reg = RK806_POWER_FPWM_EN0 + rid / 8;
 	ctr_bit = rid % 8;
-- 
2.39.5



