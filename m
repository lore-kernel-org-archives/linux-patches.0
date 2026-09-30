Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FED14E3229;
	Wed, 30 Sep 2026 15:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783421; cv=none; b=o7WzjU64LHNkRAvwrD/YvC+3c+HQzxon5S+pV3MwNQ3tmV3XtERKAI/lInzeFPurtftwUtCveIAzelNR2Fsx5lwjcDh7F60Es/jfzC3dWen2W5A9EZSPcF9a1MVv45uuwlHuLoQAtjONs7340yq3UNd0Zx0GO32ohnIKT55IPfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783421; c=relaxed/simple;
	bh=ols5mxPTZw/eTntJqiHAEGjJFz6Rkyv50z92+kSZeec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHp9/lP7vCqdvHGWDl3naNViha4cSzFhkEDbXQrk+Epcyi0pM9ADouw0bP0tNOb+OB5fdp1clFlFwJ3Tgmf46gFIbn3kC3k3UxWL4jZqmtvoLkaGGB0caBQKBYNlAl8t9vbKNHcNQ9hjHM20TIe1zFfr+Ys8IQCk1yl9SmmIqjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KO54JJPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KO54JJPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212F51F00893;
	Wed, 30 Sep 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783418;
	bh=4RQ82h5RLX4TvD1u2dqUsnlx0PhWBadha4TuaKalqKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KO54JJPrWcjb1ubQHykUpWpPzb4qJCyCIJsXvZokEHwrf1LLLa/ai/kpZEEa2XfEr
	 3Y3+/YhlmKsHwKU1YHc2gugULmW6Z86hor7lUWjIEUFXVH3EXdh/JWYI0HbSdrw5LI
	 c9WcHzLNFVdhvcwN0SJS/B8xyAxwVCwCdAKN+kcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 355/595] firmware: arm_scpi: reject DVFS OPP count above MAX_DVFS_OPPS
Date: Wed, 30 Sep 2026 17:24:08 +0200
Message-ID: <20260930152355.313226115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 32471d84a487c7fd74532bc96be56f8028cf4a3f ]

scpi_dvfs_get_info() already rejected a zero opp_count, but still trusted
any larger value from the SCP firmware. The shared-memory reply only holds
MAX_DVFS_OPPS entries in buf.opps[]; a bigger count over-reads that array
and then sizes the allocated OPP table incorrectly (garbage OPPs / OOB).
The missing upper bound dates back to the original SCPI DVFS support.

Reject zero and out-of-range counts in one check and return -EINVAL.

Fixes: 8cb7cf56c9fe ("firmware: add support for ARM System Control and Power Interface(SCPI) protocol")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/022802f0b38f.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 3a1d77b882f7e..1ff0e759c6be8 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -627,8 +627,8 @@ static struct scpi_dvfs_info *scpi_dvfs_get_info(u8 domain)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!buf.opp_count)
-		return ERR_PTR(-ENOENT);
+	if (!buf.opp_count || buf.opp_count > MAX_DVFS_OPPS)
+		return ERR_PTR(-EINVAL);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.53.0



