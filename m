Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950A61C3051;
	Mon, 14 Oct 2024 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917432; cv=none; b=Tim4BZdFQn4+ewtWasnuN77yXI0F6XV34Ivd/gIVsVdMM5a8uqJwoPLcCcUWB4RCYFl7s8pwXjeXJU4EaYmAqCwgZx1660uUOs0cecCP6tN+Y9BSm5HS4WrW3RoY8KU8a0g/P7J94Arl4GhlXzB1yfnegVxI++ipeD84S38iUAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917432; c=relaxed/simple;
	bh=n8NF/GEb9WKyWVgR7XzpX7XxyOaqm7UD8uZ8tElvfsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiGTdv79Spe+/Sq5H+c8oCdv4NKL0hpaawUkm80sX621mnL3I0ZfIX+4BlukNtQDUhYOlCg80P+hsCAX4YmnWz6Qw43ooO9TtQX1h7T3tVqEO+9Wedp8QewoVP3U7EVlq3rKjNFQdQNAh6NM2L+44c0VYl427HuSlGvI/FOJ88o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDZXovbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDZXovbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04851C4CEC3;
	Mon, 14 Oct 2024 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917432;
	bh=n8NF/GEb9WKyWVgR7XzpX7XxyOaqm7UD8uZ8tElvfsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDZXovbj9FfqDEfwbOWUJH+iTJWYrI3s25zK20oBSFfS5Fd3t3kLt9RLwz6VRDWDr
	 t1/k5stx996YaDEHHnB+MjsfHF9X/3q2RiazWjfxqzzZWIdTIrSzwAXQr+f6ST+HeQ
	 ghSPSpc53KhoroQlnE1tG/s16+Gk1DyILK4vXtuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/798] perf/arm-cmn: Ensure dtm_idx is big enough
Date: Mon, 14 Oct 2024 16:09:48 +0200
Message-ID: <20241014141219.284959199@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 359414b33e00bae91e4eabf3e4ef8e76024c7673 ]

While CMN_MAX_DIMENSION was bumped to 12 for CMN-650, that only supports
up to a 10x10 mesh, so bumping dtm_idx to 256 bits at the time worked
out OK in practice. However CMN-700 did finally support up to 144 XPs,
and thus needs a worst-case 288 bits of dtm_idx for an aggregated XP
event on a maxed-out config. Oops.

Fixes: 23760a014417 ("perf/arm-cmn: Add CMN-700 support")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/e771b358526a0d7fc06efee2c3a2fdc0c9f51d44.1725296395.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 60bca69bb3592..0d68da9dc358c 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -35,6 +35,9 @@
 #define CMN_MAX_XPS			(CMN_MAX_DIMENSION * CMN_MAX_DIMENSION)
 #define CMN_MAX_DTMS			(CMN_MAX_XPS + (CMN_MAX_DIMENSION - 1) * 4)
 
+/* Currently XPs are the node type we can have most of; others top out at 128 */
+#define CMN_MAX_NODES_PER_EVENT		CMN_MAX_XPS
+
 /* The CFG node has various info besides the discovery tree */
 #define CMN_CFGM_PERIPH_ID_01		0x0008
 #define CMN_CFGM_PID0_PART_0		GENMASK_ULL(7, 0)
@@ -556,7 +559,7 @@ static void arm_cmn_debugfs_init(struct arm_cmn *cmn, int id) {}
 
 struct arm_cmn_hw_event {
 	struct arm_cmn_node *dn;
-	u64 dtm_idx[4];
+	u64 dtm_idx[DIV_ROUND_UP(CMN_MAX_NODES_PER_EVENT * 2, 64)];
 	s8 dtc_idx[CMN_MAX_DTCS];
 	u8 num_dns;
 	u8 dtm_offset;
-- 
2.43.0



