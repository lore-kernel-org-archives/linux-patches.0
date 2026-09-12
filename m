Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D89309F08;
	Sat, 12 Sep 2026 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228192; cv=none; b=rNjETiCJTRiOv/fEgx9DoWUj6WyVWbNDsrh70bVA1pA/KlZ7GP0HcXl5yaRcXKAAAjuFlzASFCFOq2eLF83hwml7evvCe8YHyXFVN/PXl7SaNoBGZYZAJn30NJlMUjbufCtoWEduxEF6k9QMUp3+5L75q2xQd7SGIXeXNvCQYVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228192; c=relaxed/simple;
	bh=wDIMfjxk5oiNXFx4hoQ3OEEy9ofe0v9k8IxopsJ+g8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfOy2j9lP3SOlC7dbxjtjbx2gs/Pap12HYwORywkZnoZUD8fL13DcEGWHSUfR13Go2kkbxVZGz8Z5sU9FpkzZAfzC8XTlTH1RcUqHCb8i6QrEPoRcW84X/9v5e8D0ikYWp8b0PrsoiHtlODMzAZ8JTZPZC8noJFydGfhzGihrXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvWURUPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvWURUPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8279F1F000FF;
	Sat, 12 Sep 2026 15:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228190;
	bh=SpOJqtjZFUurGNHrAeNZL0scAN75Lc6ySZOsxSWo8Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TvWURUPuIrfWVdx6YCoPdooXekru9hY2c5EPiEEPxHuH5zoJI8PG9orDBhkbym2M0
	 yv++fJd0Bi4pXJ9+zi7e7/qNndz0xYmNOLLwm3sPClUO6Jcq0nnNk/Ju21gOy5cTXM
	 vcQq58fsneGgWrLYO+gZhzBiKSSwqoqrLngj0Ong=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 0336/1191] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Sat, 12 Sep 2026 08:51:04 +0200
Message-ID: <20260912065555.773807386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -245,6 +245,7 @@ static int i2c_demux_pinctrl_probe(struc
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
 		if (!props[i].name || !props[i].value) {
 			err = -ENOMEM;
+			of_node_put(adap_np);
 			goto err_rollback;
 		}
 		props[i].length = 3;


