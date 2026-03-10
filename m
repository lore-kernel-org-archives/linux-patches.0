Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D1A386C02;
	Tue, 10 Mar 2026 11:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141662; cv=none; b=IFPS34H58BxM1xTb7i3B62Tv3UbpnbL8UVyGpbM+0PIwH4xM8eKy4jSu9VAux6stitclKzIIms2pK7J4cc+684cUr5bgp5un2ABCGtLHoccZqpIIsg86JMC9VXky0JdoJ1/w89coiSjtmxUHyf4+/EExwYhQCh8Y1eIhg/F7+8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141662; c=relaxed/simple;
	bh=C+eWog7JoMIEXV5o4imtsRWCvpVE3z/HqZkN7rheiCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0wuJ8YCHEMT/QnyXxi0HjjebRlmAt3F6SxVEaI0RWRkYLNM4okvsX7wZmutlX86Xv8h6zpHDmHIn/81Xh1EPB9YPbLLDDYq1L0mewf6dir+XEIVUiWHYkgKWKL0ery3fIh9WT+5uGRQ1MsOAumzMTFwxUCrcC1lPLvLi4gGfoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTzE9cov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTzE9cov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85107C2BC9E;
	Tue, 10 Mar 2026 11:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141662;
	bh=C+eWog7JoMIEXV5o4imtsRWCvpVE3z/HqZkN7rheiCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTzE9covShyotfRXRA+kvCkRFaxsH4IqUjw9tKTP5YWfxshKosyhE+LHPJRYSaT30
	 /adH+m+1ULOX4VlVmAhbGcBpeLpgub9wfNiZ3dRwVo30bpPkmmfcafQN+lvzMverSk
	 tuqjkuXaYRrgw5dq+jW7feVgDQdKPJNWWMhcUaSZ7M6IpyrWF/ncRpuPg84gQJVgIb
	 /21cJez7SLvmTielt2W/L1N/RyhuTYAqr4QmMj1s+6TtMfRnR4nSi0I18X6QhtdGtr
	 0MEigU5NSO4ywX7oY/BAUPaaZ8CAXJfYB3KIFrECSrAfG4I+xwQzOaq6c0YRtjU6sR
	 Dm3QYRuuJqpCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/314] accel/amdxdna: Prevent ubuf size overflow
Date: Tue, 10 Mar 2026 07:14:48 -0400
Message-ID: <e6adbc28f1d395eaf9713f40d46c2197bce26bc7.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 03808abb1d868aed7478a11a82e5bb4b3f1ca6d6 ]

The ubuf size calculation may overflow, resulting in an undersized
allocation and possible memory corruption.

Use check_add_overflow() helpers to validate the size calculation before
allocation.

Fixes: bd72d4acda10 ("accel/amdxdna: Support user space allocated buffer")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260217192815.1784689-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ubuf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ubuf.c b/drivers/accel/amdxdna/amdxdna_ubuf.c
index 9e3b3b055caa8..62a478f6b45fb 100644
--- a/drivers/accel/amdxdna/amdxdna_ubuf.c
+++ b/drivers/accel/amdxdna/amdxdna_ubuf.c
@@ -7,6 +7,7 @@
 #include <drm/drm_device.h>
 #include <drm/drm_print.h>
 #include <linux/dma-buf.h>
+#include <linux/overflow.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 
@@ -176,7 +177,10 @@ struct dma_buf *amdxdna_get_ubuf(struct drm_device *dev,
 			goto free_ent;
 		}
 
-		exp_info.size += va_ent[i].len;
+		if (check_add_overflow(exp_info.size, va_ent[i].len, &exp_info.size)) {
+			ret = -EINVAL;
+			goto free_ent;
+		}
 	}
 
 	ubuf->nr_pages = exp_info.size >> PAGE_SHIFT;
-- 
2.51.0

