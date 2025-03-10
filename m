Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C798218FDAB;
	Mon, 10 Mar 2025 17:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628783; cv=none; b=npUjm3YcWa5nFp8QskFcfGwDaXe1Vs3xEHg36MjPBhCJi8GJ+UE3aR+ZlHz6lCSM244cVXEl7MERI7hajc94X4XqUqxZ/iZutmgQep6Fwvo+a2A50mAVh/NEdUM9DI7gR1ESimRmi/+yVOoPr397X8zO6M29BM7JBJ+LmKOrk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628783; c=relaxed/simple;
	bh=W4lgmTe3QbyTbcvc75+mfgad79CliRDJMuOYfQ1DIqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7xs/eWBOa/lQcmhEXH7wrLx/ee4aZfy5ZcZI+YqrLXNAPB4Ig1yFPvbQbQXjV58GZIPivLMBQHjYLcG/GdWFDns3d+EkybNStYnP++v9A7ufOhnqpDUqosxGoZQei1rJZ32xD02EPoZMX6ZUudMIPH0avQb9I4b1IWFSfvSxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rEPxk7+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rEPxk7+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5BBC4CEE5;
	Mon, 10 Mar 2025 17:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628783;
	bh=W4lgmTe3QbyTbcvc75+mfgad79CliRDJMuOYfQ1DIqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEPxk7+pqua/dLKGr5tFvoEexEECGnz1k85auAZ+wRKABUdLmufwFiZ0pBZr5v6uI
	 T+7Qm1VBJ/IgZduIjJz40XvHDie/GD3U8qPZlDah8uqp/6XUGWZoPjsNR0ordg0QF1
	 m4d/8YCbgY1BZOCsls74SvrtdI/KSUf9MRInQm9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Gan <ganboing@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/620] clk: analogbits: Fix incorrect calculation of vco rate delta
Date: Mon, 10 Mar 2025 17:58:33 +0100
Message-ID: <20250310170548.226769198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Gan <ganboing@gmail.com>

[ Upstream commit d7f12857f095ef38523399d47e68787b357232f6 ]

In wrpll_configure_for_rate() we try to determine the best PLL
configuration for a target rate. However, in the loop where we try
values of R, we should compare the derived `vco` with `target_vco_rate`.
However, we were in fact comparing it with `target_rate`, which is
actually after Q shift. This is incorrect, and sometimes can result in
suboptimal clock rates. Fix it.

Fixes: 7b9487a9a5c4 ("clk: analogbits: add Wide-Range PLL library")
Signed-off-by: Bo Gan <ganboing@gmail.com>
Link: https://lore.kernel.org/r/20240830061639.2316-1-ganboing@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/analogbits/wrpll-cln28hpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/analogbits/wrpll-cln28hpc.c b/drivers/clk/analogbits/wrpll-cln28hpc.c
index 09ca823563993..d8ae392959969 100644
--- a/drivers/clk/analogbits/wrpll-cln28hpc.c
+++ b/drivers/clk/analogbits/wrpll-cln28hpc.c
@@ -291,7 +291,7 @@ int wrpll_configure_for_rate(struct wrpll_cfg *c, u32 target_rate,
 			vco = vco_pre * f;
 		}
 
-		delta = abs(target_rate - vco);
+		delta = abs(target_vco_rate - vco);
 		if (delta < best_delta) {
 			best_delta = delta;
 			best_r = r;
-- 
2.39.5



