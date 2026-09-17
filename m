Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E1549D584;
	Thu, 17 Sep 2026 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670625; cv=none; b=RDtV28Am3gLdFLOe8s4lazqTJA3wqoTFFL/BUOfYNyBcEnt7138xvRsuIp/qZFDK1prRLASlDmr1YVBBXaO8i3yPdAEuQjd9GQfrS1dJJNFy6fJrAI/dUwnXJz0+lgUVEp6lsXPgH3fUN1l1EI9EQNh7ZWiPH/D3uIlrO4AFxns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670625; c=relaxed/simple;
	bh=/T2pT2s3+/ESEDXf28Ybvac37VcLiMWwYEr76JSJBRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6JKprukiQ6qTDio0DBVXpYVy5qlim1E3zfdFv8TmebUi/UNu2Qdr98iWpm+QsNcf044jJRoMVhuGw/gyCCJR4V7pVDJwJIgQDM/23uM6QA4vZRaQVencLUmEhpnhOSvpl6716JH+A6EPAYYfp6nKNS2ZTouusUwRsd4VybT3eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRo+zNRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRo+zNRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A8D1F000FF;
	Thu, 17 Sep 2026 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670624;
	bh=qOoVWMlcXa5APTqlO5JkSTd6EdICCi37ASmgYvQNlY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRo+zNRAPmexhrA7pQrey3HWNY0U50bxoBRGBMmUeK9VVfDG7PBZt6i1oMIyW0Wlz
	 KNdFC8TkM300m3Qecglou6g8R3+WN4kiRloZx8kjRDIiWgSr0DiUjjcRbtHvoY86oU
	 SaYexHi7w4boa0XDmuAjT593YxQ7A8O4WctlbBAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0684/1102] powerpc/kexec_file: Use inclusive range checks in add_usable_mem()
Date: Thu, 17 Sep 2026 16:10:27 +0100
Message-ID: <20260917151557.429144010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c6755be4838d6ccd641effbcdc3d917b82631ff9 ]

add_usable_mem() adds usable memory ranges for the kdump kernel.

The ranges are inclusive, but the partial overlap check uses exclusive
comparisons. This skips ranges with base == loc_end or end == loc_base.
Use inclusive comparisons instead.

Fixes: 7c64e21a1c5a ("powerpc/kexec_file: Restrict memory usage of kdump kernel")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260809162403.18142-2-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/file_load_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
index cb14de058de23..c1a56b6773ce1 100644
--- a/arch/powerpc/kexec/file_load_64.c
+++ b/arch/powerpc/kexec/file_load_64.c
@@ -296,7 +296,7 @@ static int add_usable_mem(struct umem_info *um_info, u64 base, u64 end)
 		loc_end = um_info->ranges[i].end;
 		if (loc_base >= base && loc_end <= end)
 			add = true;
-		else if (base < loc_end && end > loc_base) {
+		else if (base <= loc_end && end >= loc_base) {
 			if (loc_base < base)
 				loc_base = base;
 			if (loc_end > end)
-- 
2.53.0



