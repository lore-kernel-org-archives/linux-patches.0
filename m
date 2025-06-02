Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1419E222561;
	Mon,  2 Jun 2025 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873276; cv=none; b=b5qdG7pGBdcDxpg3t3f4OLbU1TS/rWYWTHxu7J80gb+geENDqQxfd6IgfLiyi0Sb1al6ZvtQ9g4B/p9iotaf2VWd/O6iGR7A08UbnyqnP0RgjOoPazo+zBNaJAg4js9cj8IwrQNdiTB/kY74kT7gwrVqCGObr5+JbfJl7nu7sdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873276; c=relaxed/simple;
	bh=3ukin6vij1BsPtuGkUHtLWfn4BWC3Hxh4OsAIA77zpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1iSLGcgi0gt0SLZazVmYI+nQxpA2UwGE8hPAdnBuoDYEmi+8TFzWYw08ZFUaxRz1+6n4CrfttgTdSkPsR9fWUNil75qjOrofjYyTYwxl0lEDBpVqqbeT+qIvK4THlsVHwJfavgpQCQZYIo2sER+mt2xuaWbwucE2t7W1FN1Vc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1brvMk3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1brvMk3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2608DC4CEEB;
	Mon,  2 Jun 2025 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873274;
	bh=3ukin6vij1BsPtuGkUHtLWfn4BWC3Hxh4OsAIA77zpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1brvMk3IpA3FUSm1/OU346+aNHHVy3/BKDHc8B5QrBIiIGL4lqNFRwXSGWaKRTh99
	 dhwNHbJGIjcwjYe94zP72jOk+FsPg2kT51hjDmhAPiKCG+zFKWbCiUwaglxD7HvK/m
	 +3ZxWBFAXW5ZqsbHeDrOFy94Q1RpIXwK4GVHgCHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/444] bpf: Return prog btf_id without capable check
Date: Mon,  2 Jun 2025 15:42:35 +0200
Message-ID: <20250602134344.584642053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 07651ccda9ff10a8ca427670cdd06ce2c8e4269c ]

Return prog's btf_id from bpf_prog_get_info_by_fd regardless of capable
check. This patch enables scenario, when freplace program, running
from user namespace, requires to query target prog's btf.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250317174039.161275-3-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f089a61630111..5a8c5a4ef1134 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4442,6 +4442,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	info.recursion_misses = stats.misses;
 
 	info.verified_insns = prog->aux->verified_insns;
+	if (prog->aux->btf)
+		info.btf_id = btf_obj_id(prog->aux->btf);
 
 	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
@@ -4588,8 +4590,6 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		}
 	}
 
-	if (prog->aux->btf)
-		info.btf_id = btf_obj_id(prog->aux->btf);
 	info.attach_btf_id = prog->aux->attach_btf_id;
 	if (attach_btf)
 		info.attach_btf_obj_id = btf_obj_id(attach_btf);
-- 
2.39.5



