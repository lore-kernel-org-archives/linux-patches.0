Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6201C75E4;
	Mon, 14 Oct 2024 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919332; cv=none; b=FwODYY4gsCH6fnc3QZ9z3pcFNX746iv2GrM4T6e5Of0AmoDjvYj2UO9ji5SP8cIcUzH7YDlwSR+EHOf/baP/aaheoINpP5O8GRuLTnEiL964xBCoAC3fDFcMfZ9itKJrjzTtGeVYbQktCBcFucoEvepF/K3yQuLT5VQ/ny3MWnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919332; c=relaxed/simple;
	bh=p1Tq/pMMWNFgcLI+20+UYnNZ3i68pwIjT8ecwC9d4c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAs77U6VtbXailhscJdooYG0lcJp6o++1KNUAS0kGPnu3uWZ9+2T4+BrlFYEbCsKQjUVnXbDODIHKfYAA5pzVqyb9cDiWR9eQITPlFeLmHGbnvORG9kr5zQeHMy7JLgWfuPr4DqqwkIXtAm46UDcA1k1kqwNJC8zdbT0old/IrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRsNG8Wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRsNG8Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F20DC4CEC3;
	Mon, 14 Oct 2024 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919331;
	bh=p1Tq/pMMWNFgcLI+20+UYnNZ3i68pwIjT8ecwC9d4c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRsNG8WvZuMnBgnJZVHYPPDIMcGdZpde2Oog5GT4gjxJ5OCPawJL9eSRBVmN4FURj
	 p2cZcoPCCYSX8hW0TRRJ8jDvK1liHeAXVCYdeZIJRj/b9Lm1L0hY8d3OpdTowFXj2K
	 o++zw8vW+xr3rxB9hOYl6GW1dXUCUpyXq0CBQJBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.1 580/798] clk: rockchip: fix error for unknown clocks
Date: Mon, 14 Oct 2024 16:18:54 +0200
Message-ID: <20241014141240.788597480@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit 12fd64babaca4dc09d072f63eda76ba44119816a upstream.

There is a clk == NULL check after the switch to check for
unsupported clk types. Since clk is re-assigned in a loop,
this check is useless right now for anything but the first
round. Let's fix this up by assigning clk = NULL in the
loop before the switch statement.

Fixes: a245fecbb806 ("clk: rockchip: add basic infrastructure for clock branches")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[added fixes + stable-cc]
Link: https://lore.kernel.org/r/20240325193609.237182-6-sebastian.reichel@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/rockchip/clk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/clk/rockchip/clk.c
+++ b/drivers/clk/rockchip/clk.c
@@ -438,12 +438,13 @@ void rockchip_clk_register_branches(stru
 				    struct rockchip_clk_branch *list,
 				    unsigned int nr_clk)
 {
-	struct clk *clk = NULL;
+	struct clk *clk;
 	unsigned int idx;
 	unsigned long flags;
 
 	for (idx = 0; idx < nr_clk; idx++, list++) {
 		flags = list->flags;
+		clk = NULL;
 
 		/* catch simple muxes */
 		switch (list->branch_type) {


