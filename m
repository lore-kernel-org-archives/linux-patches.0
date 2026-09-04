Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1932E34EF15;
	Fri,  4 Sep 2026 05:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499577; cv=none; b=ZaKEWi3ZvlzZa5wp4ohwwycend4vbDFwu//DOHdnMkCgD0btY6Cl4j7c9ezwtuvudadQBoWqReQDdqijUxS57UzNSGTxIGOvd7Zl16U0wy1MyRjfPwwVfr9OHuPGDDz7/3FaoB1FsYs66LLtYtdKKCCz9BZks9QPndFSb1B+GNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499577; c=relaxed/simple;
	bh=NeY9QT+e12E2Tinpa8wM2m6QQ6z3UiOdpNCIVBrz4vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utLV3mNBYNRPD2JEFGHH5h8TAAZA0eIh5tBYbHN2WERZorcw1cKAIDmybDOZACV5d2KsQLZklcvDlOmSg50vhUxbN6ajHtf+dBQhA0ZSg8yzh+OIqllCE7jJIgmsYSumZmqxvE+cUyiLt3257M6vUSWRuZfXz9cWLFHEYzuxcSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiR+pWu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiR+pWu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F901F00A3D;
	Fri,  4 Sep 2026 05:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499576;
	bh=9SIFT73JTC148j7TxwlJLeP8SkxxDjradddP3szFrT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uiR+pWu1oR6o/t+JO/HLhZrNUvzj5JYYQ9qL3ykzTQ7xJLKrJeYq7vCglFrN+eiD0
	 t0mJ6W38tg8d3Tvjk2nXwajDoHJepZENyHBo/1Hqis1w3zAc+Zsz2asdmxscl5EO7g
	 0Bdly8rYmSmbM1HMuYVsMDwxQg5P0hFI5Pcf2yZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 449/713] regulator: as3722_get_regulator_dt_data: fix premature of_node_put leaving dangling of_node pointer
Date: Fri,  4 Sep 2026 06:56:57 +0200
Message-ID: <20260904045813.894334285@linuxfoundation.org>
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
@@ -600,7 +600,6 @@ static int as3722_get_regulator_dt_data(
 
 	ret = of_regulator_match(&pdev->dev, np, as3722_regulator_matches,
 			ARRAY_SIZE(as3722_regulator_matches));
-	of_node_put(np);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Parsing of regulator node failed: %d\n",
 			ret);


