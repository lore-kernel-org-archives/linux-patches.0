Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E60D57D221;
	Wed,  9 Sep 2026 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963671; cv=none; b=XiTSGAgpz3r8ge9thkUHl+Xce3guwm/5RS5i0BbVauRqCQRJqbKjqEgfpsdxAmaVqTknZz+q5rw7bHUnNCAM3SOFlxCxwTdGjpWgZ2eBO35tYC4c92OG5Ge/Ipt4JoSv/Nol69CZbxys6B4ufb30XTBwzYrJhLAydL10KgGV9S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963671; c=relaxed/simple;
	bh=lb8wrXHOgN+Yw7CSsQj9ZJJsTwSl1fn/3LDKGNg+mXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCgojZA4gy/WWEFyRdtz2wpJUZxnb1+hIq90MFbOBJTCVmBWEk9vO3F9tpcRiR11Le4uM/TyfoE2A+2HsDG0804STqf7vCkyzyvuF4NAhuF3+lJHeRgPCWO1nVUMmgaJmT8oMWtL1DV6I05lxGy0Z3SL5XfRs+M9nGVOck1Ig5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re6SYBZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re6SYBZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044C41F00A3A;
	Wed,  9 Sep 2026 14:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963670;
	bh=6Jo92dWjwbwu7u0SvT2Hby1jVqKHfQGRW1ATPUrjg8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Re6SYBZj7xQWvq5HNYE2AHkNm3czVdSmlyM+qgY2HQCE+dLojggvBJHne4WYf2pXY
	 LS9BbKf0Vbk3ZOD/IduGy8LdHJd/ZmjVv4+U9diYXX5qFL/BgVpkC4ljl40i2LdQFr
	 WR6bjK07CBFZBX1x2EkXOGboUbJP3MzkRkFKSkwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 157/583] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Wed,  9 Sep 2026 15:37:22 +0200
Message-ID: <20260909134243.643650763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 62edb8ca0aa44517cc23cfa26cd8a51f15ea92fe upstream.

of_parse_phandle() takes a reference on the parent node. If a later
devm_kstrdup() fails, err_rollback only releases nodes for indices
0..i-1, so the current node is leaked.

of_node_put() the current parent before rolling back.

Fixes: 7c0195fa9a9e ("i2c: mux: demux-pinctrl: check the return value of devm_kstrdup()")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260813095617.2246320-1-gonglinkai@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -247,6 +247,7 @@ static int i2c_demux_pinctrl_probe(struc
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
 		if (!props[i].name || !props[i].value) {
 			err = -ENOMEM;
+			of_node_put(adap_np);
 			goto err_rollback;
 		}
 		props[i].length = 3;


