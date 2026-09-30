Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA7A3CB56A;
	Wed, 30 Sep 2026 19:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795922; cv=none; b=hIOoi5vbuDsBbxx9NZx9KHUtui5CZ2mpV/4G6uKR0P4+qx1g/UCZSLhsYtqqj67bRSgYhpHdem+sQftGQz1n2eM80i0ktaa12bG6DFDKf/bjEsBdKaeJbvSJBNVQ3+aIb61f+kehr5uzhJV12YnmrRIkM0g+CmVEW1ZuSBapysM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795922; c=relaxed/simple;
	bh=ylYiPMkUDV9Z+DnV5XoME3WOaJ9NOFpguwbClUSzsLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7WVInnZuD+vRzPCxpjfR2MKAXSaw3V6Hfydd6odaXDfHHOuwtQZfU83XVQ7E6CikSqAh6m4Vge4A7rAptdfqgvTygtujlOeQG/qe0i8U5hK4ubWI4k2743oGyITSZgiFVRDrRilkjWS1rH6/byT4OGJM6u04IAoSguDMb3SfL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWbqYW9A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWbqYW9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051031F00898;
	Wed, 30 Sep 2026 19:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795921;
	bh=lbTNNbDibo34NoGKbbAuxJo8MWbseb5MuwGYBQ1qgB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWbqYW9AU/tYH3tM7jTCm3dCY8EhnbEQGD/8UctaWPYD5BxR2SxnK0FBrdGJy8PiU
	 aO8sUKOnWk+Bv2lGNMbbQKYJwrRjkrduOJa3+alhvbwwKsMmkFEu5wwDnscDZDe9Bk
	 oUIq1ikFsbNrist7pFZ9IhxylLEercvYlCQpg/5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xixin Liu <liuxixin@kylinos.cn>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0731/1193] clk: scpi: bound-check DVFS index in scpi_dvfs_recalc_rate
Date: Wed, 30 Sep 2026 17:23:35 +0200
Message-ID: <20260930152450.492666887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit 70f4b78d560e592cbf3325b162424737d032fc1d ]

dvfs_get_idx() may return an out-of-range index if the SCP firmware is
buggy or returns a stale value. Only negative indexes were rejected, so a
large index walked past info->opps and could treat garbage as a clock rate
(KASAN OOB / wrong frequency to consumers). The missing upper bound dates
back to the original SCPI clock driver.

Treat indexes >= opp count as invalid and return 0, same as idx < 0.

Fixes: cd52c2a4b5c4 ("clk: add support for clocks provided by SCP(System Control Processor)")
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Link: https://patch.msgid.link/04f9ab766e07.v2.1785200642.git.liuxixin@kylinos.cn
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-scpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-scpi.c b/drivers/clk/clk-scpi.c
index 5ab46a537b5d3..71f1e6d61ece3 100644
--- a/drivers/clk/clk-scpi.c
+++ b/drivers/clk/clk-scpi.c
@@ -85,7 +85,7 @@ static unsigned long scpi_dvfs_recalc_rate(struct clk_hw *hw,
 	int idx = clk->scpi_ops->dvfs_get_idx(clk->id);
 	const struct scpi_opp *opp;
 
-	if (idx < 0)
+	if (idx < 0 || idx >= clk->info->count)
 		return 0;
 
 	opp = clk->info->opps + idx;
-- 
2.53.0



