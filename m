Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2854137B2;
	Fri,  4 Sep 2026 05:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500159; cv=none; b=memrf+jR8exEZA6gLF7vCRcMBJUkow7M87ZBE9JbdJJBXys5OWk0Mh/DB3kWAyEVINKojbgLu1lc79K8rvGmILXO2vFblytL2fVdNzPuXeOresbxsbRTL7SJrPqpcFe1pNea33AToMeGybnZ7v2LcAcTxGsL+qLUpjQvUBBlEpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500159; c=relaxed/simple;
	bh=01tZvg9afPDHs4S4ryJWIe/2PD3jMJPqF21ra/bZwJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWU3VUJjE+8RWBeloEogVN77eOJqVntW9yjb+MTOJEbnSP9QDD1JqhY6ikhlUDVimZqKjU90cx3JFo8hLVzkH4YO5POHvRNmpIdaDRSC+bXycE7iBJuPGg0jzvcwb+Gz2gbSXRt8Fs49UtXAA883TXGbsZ1MvnwHgQ3N2bV6SMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBkVVh6e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBkVVh6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BE41F00A3D;
	Fri,  4 Sep 2026 05:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500157;
	bh=lCDssC3pSi/uIdqVk/OxTRKjchOqyvca1NzvW1Hrvi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBkVVh6eZOSEsWX97JOZF+fGd+0Fq+p3bTR+QCNyoWF+4Quv7KiGy8OwxLuOJq0cg
	 yTzmUxnI68D3lUF+r0PnZPhKevIdqnWwvSQcY+9CDzEttkZvWtRg3KYlFSzZRfSEnD
	 0nxPzw+5AnN8Qnpt2zTPao9Oeb0Wk8nDfzZiEGmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 670/713] i3c: renesas: Follow the reset deassert order used in probe
Date: Fri,  4 Sep 2026 07:00:38 +0200
Message-ID: <20260904045818.855691114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 7b15ca2615ec41fb428eb9af71bf3ebc95021201 upstream.

Use the same reset deassert order in the resume and probe paths to avoid
potential failures due to ordering differences.

Fixes: e7218986319b ("i3c: renesas: Add suspend/resume support")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-4-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -1461,17 +1461,17 @@ static int renesas_i3c_resume_noirq(stru
 	struct renesas_i3c *i3c = dev_get_drvdata(dev);
 	int i, ret;
 
-	ret = reset_control_deassert(i3c->presetn);
+	ret = reset_control_deassert(i3c->tresetn);
 	if (ret)
 		return ret;
 
-	ret = reset_control_deassert(i3c->tresetn);
+	ret = reset_control_deassert(i3c->presetn);
 	if (ret)
-		goto err_presetn;
+		goto err_tresetn;
 
 	ret = clk_bulk_enable(i3c->num_clks, i3c->clks);
 	if (ret)
-		goto err_tresetn;
+		goto err_presetn;
 
 	/* Re-store I3C registers value. */
 	renesas_writel(i3c->regs, REFCKCTL,
@@ -1490,10 +1490,10 @@ static int renesas_i3c_resume_noirq(stru
 
 	return 0;
 
-err_tresetn:
-	reset_control_assert(i3c->tresetn);
 err_presetn:
 	reset_control_assert(i3c->presetn);
+err_tresetn:
+	reset_control_assert(i3c->tresetn);
 	return ret;
 }
 


