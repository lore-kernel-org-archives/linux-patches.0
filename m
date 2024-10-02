Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94601CFEB3;
	Wed,  2 Oct 2024 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879210; cv=none; b=uXef5yQSx4Swvxd4LJ/5Tc9g/8er/p7tGaUtNT7F/3F9hgLE2oZ2rkYWwV92V+VWmnUQXQCaP59mDBMrgzJmanIT7ojiOzUa6wlaDWwfQ01J7uqukMXnzRMnh121exN7c5IiYWJ7UiGhWrt5xovKgVRaPAQB9Y3eEU2ntI4sE0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879210; c=relaxed/simple;
	bh=S+OGtZeO6pDfqJfM7nOvAm+dAcCKqt1XQHEwSe0IuNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0R4pH8o8e8OsOy7KyPjvGAtHWiN6P++fFe6x6F/d+cv9IZ2BD5crJgZarWmtnyr3QypqkFgnx/4A6lpucQqrwLxz6yZ2uSdRprg1m/VS7DL4jjgF9/txUyvgd/oNZpnz1UbZzlecCHxZJ32HblBqgU+NAovoeN7RX//wPN7MPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz0ziNNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz0ziNNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1534EC4CEC2;
	Wed,  2 Oct 2024 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879209;
	bh=S+OGtZeO6pDfqJfM7nOvAm+dAcCKqt1XQHEwSe0IuNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz0ziNNZRLIEQjEUXkLRrUu2eQlIi+hiIsKiITlVek6avAfdsyYsWikqLMQi//Oja
	 +iv/l9fkdBT/lrJvgjTOwNmx6qsQzEadNYw4fQ6IfSiR1cZIuDAUOjlzBAw3y6Kdr/
	 S9qSI7OBjp6JB38VW6HMuggvOm2rnNRjgM84PkQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/538] perf/arm-cmn: Ensure dtm_idx is big enough
Date: Wed,  2 Oct 2024 14:54:40 +0200
Message-ID: <20241002125753.650493217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3926586685cb4..7d5e8cb96e9bf 100644
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
@@ -565,7 +568,7 @@ static void arm_cmn_debugfs_init(struct arm_cmn *cmn, int id) {}
 
 struct arm_cmn_hw_event {
 	struct arm_cmn_node *dn;
-	u64 dtm_idx[4];
+	u64 dtm_idx[DIV_ROUND_UP(CMN_MAX_NODES_PER_EVENT * 2, 64)];
 	s8 dtc_idx[CMN_MAX_DTCS];
 	u8 num_dns;
 	u8 dtm_offset;
-- 
2.43.0



