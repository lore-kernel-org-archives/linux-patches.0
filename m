Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC67644AB84;
	Tue, 21 Jul 2026 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667780; cv=none; b=TekyhO8IWyY8ROdDHoBwxXU7IB7U6Vu9E+xxGrbS2yK9LuZ/AcF4is+jW5imnY5c6F5In3zPAzrYXB3z9RRf25IUbkP90PY2mrX5HvtV01yW1LSUINDVTu1/s92UksnBtMaz3+NqBTVNmPoY4BGjeizsaYME7sBFKSVkJzo3YkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667780; c=relaxed/simple;
	bh=Eyxtx1MkEOz4/gfZMOxhaEugoPn2rrb0ln9jEqtL9x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnqtFJjM/RDVQaCM/g2iF8ieiNxVt2xc2Z+TgxPMo2ifE70grq9zBYXZM2OEU6pe5rwLIHJ8QaWZgynJffOoUOh514Q+AqDnDYqV6VRQoEmRRIwJoqjQqr0O8pdfmfXovDI/cnDFjSyaIdGaXyUsOT+ndRFtH1gfIEJFk6uQieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTlu6Jl4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTlu6Jl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407DE1F000E9;
	Tue, 21 Jul 2026 21:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667776;
	bh=HlTZ35GsHzWnjwrGExjEPWygY7/BweU9pKQZvt58q7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTlu6Jl49zU9iWZgfybY0kP+rpNxoGJllFIIivHsgvilik3xGdtpOyGBKlZ8CRALk
	 g4oKWwPQTzjZU/V5lueT/RqlPoW8vEIkMJHcgXmAIosimSUIivk3alTOlq+vYe2O+L
	 N2zHzEc1QFofJHWtI0eHFco4YwH4v/rbU5afOLxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1188/1266] media: nxp: imx8-isi: use devm_pm_runtime_enable() to simplify code
Date: Tue, 21 Jul 2026 17:27:05 +0200
Message-ID: <20260721152508.380612905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 078161dd44d6f848a62a473206d69025607736ec ]

Use devm_pm_runtime_enable() to simplify code. Change to use
dev_err_probe() because previous goto change to return.

No functional change.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260116-cam_cleanup-v4-2-29ce01640443@nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: b670bf89824e ("media: nxp: imx8-isi: Fix use-after-free on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -474,13 +474,14 @@ static int mxc_isi_probe(struct platform
 		return ret;
 	}
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	ret = mxc_isi_crossbar_init(isi);
-	if (ret) {
-		dev_err(dev, "Failed to initialize crossbar: %d\n", ret);
-		goto err_pm;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "Failed to initialize crossbar\n");
 
 	for (i = 0; i < isi->pdata->num_channels; ++i) {
 		ret = mxc_isi_pipe_init(isi, i);
@@ -503,8 +504,7 @@ static int mxc_isi_probe(struct platform
 
 err_xbar:
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
-err_pm:
-	pm_runtime_disable(isi->dev);
+
 	return ret;
 }
 
@@ -523,8 +523,6 @@ static void mxc_isi_remove(struct platfo
 
 	mxc_isi_crossbar_cleanup(&isi->crossbar);
 	mxc_isi_v4l2_cleanup(isi);
-
-	pm_runtime_disable(isi->dev);
 }
 
 static const struct of_device_id mxc_isi_of_match[] = {


