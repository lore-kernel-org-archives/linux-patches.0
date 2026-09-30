Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B84F93B9;
	Wed, 30 Sep 2026 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784089; cv=none; b=bqO+V31LM7NgxMsrHHM2LjhchKN0/9JCIA+FVFhuT9WbD7YsiQdtntDjeg9YRrKKIJKcquvawBdEghybsXh4g5SFlVuFTgdbly6L9zFFqo5Qw4OV70k7+zqN8TEEurzjH698fAOPD/lJQWk7xGkct+fHHdXUZUtSWAL3xYQqboc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784089; c=relaxed/simple;
	bh=khQSi/WnZrQuOY4RiDi0yq03J4ursUVgrqOH9ZtPzXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkUVb323OGbHz6i1pXT1xuY8asRBaMzibABhcjZSxEtZnxkzoigQaRxU+XUYltSrntqEWNZozpbpUHxcNU/vHxzLbtpr8qquZsCsuomam0xsQ9H8V0MAK4pWzsCsjbMd2XS80QgTOAW4NWyusVX/9+vzUDJpAFDvsoVxqCVVC+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpJswYpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpJswYpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B131F000FF;
	Wed, 30 Sep 2026 16:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784080;
	bh=dmIfKUMNiLjwtc/PWLtxI1JdL9RNlvBF9AANkGdZUMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpJswYpcLm9+9owd2Rm3cOvQ3DpBS2yFqXcttQdH9Upd3Arrpivc14yaoDSvWoKoO
	 JNJcE9JBSXAmOd70KPbqONslnY13QVVHZLrsfhEErwJJTmPPxZuF0/+P46WrazkRTZ
	 /bhH09hHm/d4jWKu1qxMMSlQkrrSllxYYSVxMrc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/982] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Wed, 30 Sep 2026 17:12:46 +0200
Message-ID: <20260930152417.443464723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7f0c422c7fbfd9294ff9321ada0c63561e5c6ea0 ]

The number of clock cells is not validated in the clock provider's
clk_src_get() callback.  Add the missing check.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe236ec.1777562043.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index d6137379510c1..77365962a15a9 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -285,6 +285,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 	struct clk *clk;
 	int range_check;
 
+	if (clkspec->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
 	switch (clkspec->args[0]) {
 	case CPG_CORE:
 		type = "core";
-- 
2.53.0



