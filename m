Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02537FF40;
	Sat, 12 Sep 2026 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241522; cv=none; b=EcBE2g1e61qdn8QuCVOztrNpJnZM291xUuKIH1k+92EUA4Ctq5FXGnpjhKE+Lyi1OGvEt7q5UiddagvtFSN50ft5LI6C7nyULSqTxT6ttF/UxmMj36XakKLhwYn7LawjAG9Ghbl1gNy+GKE5dzy7YEltMdrkCC9jRmP9yDV9tkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241522; c=relaxed/simple;
	bh=R5daW3iGWApC34YtOadNJFUT2cDRalD6g1K9RrxGNEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLskAlXHHS2uoeyp4p3fzWuxvDqk56iEF8baKDhAaAaE4vW7kbQjTMUq+bzkggeL7O89PnU3F/9Q9gDKK2xh+M6ii+vJpDanKjPk+lPB74wXYj4eD8w+LO31tUe5kv775PPC1N2ojqq1l77Gh3stXelPlwDZsqYyDa5vF3E474k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p83QFZyB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p83QFZyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863FE1F000FF;
	Sat, 12 Sep 2026 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241521;
	bh=+unxYwrLWpntRi6L/zkVsgLEtVIen3aSzqMwgmTM9KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p83QFZyBpCPH8MIhPAyrDDQoaX9wtKb4x4Si0pCdLWbPUseixIrXqdZIAVtdSPFtj
	 og2D9FLPN/4cPz9Ln+rKtc85PFxiXz+wmb5HRePM2yHxEWU1v8gJwSKcIVTMd/nxCQ
	 QuNg2HkaWLT+0OAtN7aBsDOjnBM9CyhIbVhZczMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 110/798] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Sat, 12 Sep 2026 08:55:38 +0200
Message-ID: <20260912065519.481490312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: WenTao Liang <vulab@iscas.ac.cn>

commit f9324d670ae0b88cbfb0aa48fcaefa5baeb8da4c upstream.

In as3722_get_regulator_dt_data(), of_get_child_by_name() acquires a
reference on np, which is then assigned to pdev->dev.of_node. The
function immediately calls of_node_put(np), releasing the reference and
leaving pdev->dev.of_node as a dangling pointer.

Remove the of_node_put(np) call to let the device hold the reference.

Cc: stable@vger.kernel.org
Fixes: bc407334e9a6 ("regulator: as3722: add regulator driver for AMS AS3722")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260626160150.54291-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/as3722-regulator.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/regulator/as3722-regulator.c
+++ b/drivers/regulator/as3722-regulator.c
@@ -599,7 +599,6 @@ static int as3722_get_regulator_dt_data(
 
 	ret = of_regulator_match(&pdev->dev, np, as3722_regulator_matches,
 			ARRAY_SIZE(as3722_regulator_matches));
-	of_node_put(np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Parsing of regulator node failed: %d\n",
 			ret);


