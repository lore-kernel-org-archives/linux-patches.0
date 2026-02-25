Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5501FE45D;
	Wed, 25 Feb 2026 01:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983420; cv=none; b=NjZhe1OE8oQzxmpLAS0Yfhkq5A1/PwpSqZpUmkC63Unkyv772WYkQEXs6I3Cft1JypYii9S9v93h3DsBMjASTsNiBKEuM7Cz6PzgASMKNtivc1DsyVpf+vb0ek/8Gw8Xj9Za2lv7DpGFIlDOPHv/FSCVi8HuJkc0+WHSCYwr1V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983420; c=relaxed/simple;
	bh=zVsoVHZDpThTWMq6ZyohVCKJmjm1WttEXvH9UkdmX0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtrJe0jjlu4JnBYG/PkzWynlyWyGqxI/ENua2wRs6BvvbnvB85E33eAbPU3iIj15R9I+1DeHnIk5aAB6cgo4wmMD6WoqUNhvl+tW9A48Mhns9XJ/CxXlQUIJ0HeFFxBmqEjRJnchD4SPP9csHUKXpDRu8uHa9+TGYV0s4iLm7ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VefnVm4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VefnVm4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775B1C19423;
	Wed, 25 Feb 2026 01:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983420;
	bh=zVsoVHZDpThTWMq6ZyohVCKJmjm1WttEXvH9UkdmX0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VefnVm4b2HjleDNXen90XEMZGnsGn6l5vM5+PuWBdyOTTQyzivt9FM3I+W0QCQ2B6
	 4xnZLiiWGnRiLf808QV5tOddm0M0pbMWjhlmqfxW9KjfBiqtJHiasZkwCrya0UU9A3
	 bE33p0IQCmuLz/mTIvM+DB9sfA8Rq95+hvN8r4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 541/781] clk: bm1880: convert from divider_round_rate() to divider_determine_rate()
Date: Tue, 24 Feb 2026 17:20:50 -0800
Message-ID: <20260225012413.066303376@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 463b97bef0c9fb02b743d6b9f0d698cae81a1d9f ]

The divider_round_rate() function is now deprecated, so let's migrate
to divider_determine_rate() instead so that this deprecated API can be
removed.

Note that when the main function itself was migrated to use
determine_rate, this was mistakenly converted to:

    req->rate = divider_round_rate(...)

This is invalid in the case when an error occurs since it can set the
rate to a negative value.

Fixes: 64613d7fb42f ("clk: bm1880: convert from round_rate() to determine_rate()")
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-bm1880.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/clk/clk-bm1880.c b/drivers/clk/clk-bm1880.c
index dac190bc6e19a..d2617fe16d2e4 100644
--- a/drivers/clk/clk-bm1880.c
+++ b/drivers/clk/clk-bm1880.c
@@ -629,10 +629,7 @@ static int bm1880_clk_div_determine_rate(struct clk_hw *hw,
 		return 0;
 	}
 
-	req->rate = divider_round_rate(hw, req->rate, &req->best_parent_rate,
-				       div->table, div->width, div->flags);
-
-	return 0;
+	return divider_determine_rate(hw, req, div->table, div->width, div->flags);
 }
 
 static int bm1880_clk_div_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.51.0



