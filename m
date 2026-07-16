Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DE53C4565;
	Thu, 16 Jul 2026 13:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210131; cv=none; b=FaPZWbKwzKwzj1jCpy7J4lexL/9DczurR494Ld6gLjeksIllbk6zHUxUpkISqasRR3+Ak/q1Up/OZgRNxzDlOtSM7MnVtluA9gkftL7340BuyVWIie9TGEP3OMopUt1Yn5bseBje6o6pt04mHJmnwzquUCygst2VjDsFtUPnnSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210131; c=relaxed/simple;
	bh=SZzcWYut3hgkbxgbn29daAmCnj8Xs05el6ayPdoqC4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGecnJGwEReFXu1Ox3qpv54W7Sie3Sdoj9T2nwLyECymTNUGNYrTc5lRGHGaDxKxjMZ5JsDjkPY8QDb4O89s8/lCugKxfURxGP0ZDxVWgmNrb+n3Jy47rC1aVOSa437tC9GIsez6ZWDvR9TWxuXOeyusyPu/LzAk6VanDV85qts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGKxpknM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGKxpknM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686BA1F000E9;
	Thu, 16 Jul 2026 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210129;
	bh=Y2uERwtEPWWdjhonIzpsGlEEYvCTNbSPRBX1METZi5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGKxpknMghncErQLPUDIL1HTtfMRvPZIH7/GfdAuSd+IbWvC4mK6gjNXmrSKB7068
	 S8D9WnQzVl9cYGteD3lBclOCGYiES/q0vAas52/m0R+yLaJISxJNUhm/k2xiJ4Rz++
	 2beIDIdqBxMiOTpMclLNoouOa6sEJIJxKWMGjz78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 406/518] regulator: scmi: fix of_node refcount leak in scmi_regulator_probe()
Date: Thu, 16 Jul 2026 15:31:14 +0200
Message-ID: <20260716133056.719537706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit fa11039d6cdff84584a3ef8cc1f5e1b56e045da2 upstream.

scmi_regulator_probe() calls of_find_node_by_name() which takes a
reference on the returned device node. On the error path where
process_scmi_regulator_of_node() fails, the function returns without
calling of_node_put() on the child node, leaking the reference.

Add of_node_put(np) on the error path to properly release the
reference.

Cc: stable@vger.kernel.org
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260527104850.872415-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/scmi-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -345,8 +345,10 @@ static int scmi_regulator_probe(struct s
 	for_each_child_of_node_scoped(np, child) {
 		ret = process_scmi_regulator_of_node(sdev, ph, child, rinfo);
 		/* abort on any mem issue */
-		if (ret == -ENOMEM)
+		if (ret == -ENOMEM) {
+			of_node_put(np);
 			return ret;
+		}
 	}
 	of_node_put(np);
 	/*


