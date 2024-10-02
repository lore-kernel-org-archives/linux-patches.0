Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAB61D016E;
	Wed,  2 Oct 2024 13:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877379; cv=none; b=Q5MNLQGJA6iJrMqGvYnMueDXJigK1rfdBsvGkWv1XFDIKOdjqstipPoDpFV4JP3eEkRpSfIP5lrRdV44A/Ftclqf8Rrr+UMTKAtBxBfQe9i2H4zHBT7PS5G0NJOj+PDD45Qn6Q1HTlPqSPNvvYaM8elWbS+5/QDVaNxcp0SBSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877379; c=relaxed/simple;
	bh=4pXRf0He6k3p4f1xDkZ0K/JycomVIXmuHiGRJPJBzk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC+gHJW0AZsAOSzQ5QYzv6VIBW0iDo8HHXNH8oFdnLA4lP4roBvquxLnweSNfoMETns/K0LuR+Pkrcm/lLkB8wlu70aupIriKFogJQQORgBjjDnj5NkE+bwDxY/hXRj/8673Zu7aAVcBfwW1v9KMClSW+fYNHNuMKHwkaMEOodM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2S+VV9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2S+VV9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB96FC4CEC2;
	Wed,  2 Oct 2024 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877379;
	bh=4pXRf0He6k3p4f1xDkZ0K/JycomVIXmuHiGRJPJBzk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N2S+VV9G9zF0rYSF9x8vL5oTIsAnJuqI/9qrwF3kJUy6Bc1/O3GrJyrE4FB0ltzlU
	 OrrQ2sGbPZfO/MjOIcTDz9bJ/v5y5DeNViC9GZWRr0RjbmzbE/Zzuwn+BZHQ6Ogv4o
	 ng+R3IiQ/9XFvZZ8TLhITp/ApaGDELIiPg6Jnr+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 060/634] perf/arm-cmn: Ensure dtm_idx is big enough
Date: Wed,  2 Oct 2024 14:52:40 +0200
Message-ID: <20241002125813.476216259@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index f33fd110081c3..058ea798b669b 100644
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



