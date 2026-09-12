Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C83309EE2;
	Sat, 12 Sep 2026 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241988; cv=none; b=JXkZHC/I5oVJEr4dVFQaljhZ0VCdyix3v/5DKe6TxmwZzpIGlyBETXbZHiofiYV+vltsVtg4jlbumNjPJu8XXX2S5gNX3S1xHuS/igC+bJdjmIJzkeoUfdSxwQ3mX2imxRf0/nwSp/e07JnTSm9pmVkvi8mGSPhJ5uwAMy3JXWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241988; c=relaxed/simple;
	bh=iOBBNjb45+hIkE2jgjVFYKfviV4qwQiIUM749P7aeOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWIS6sdOuqbZlzlZvNPKrTxViH/7sbR8CIBRam2NKDb90eyKvsyTOoIBjM2YRa3Glu4uann8RjUIck1Of8J1c70h9E+Q01Nb9QNPN4oXMenFw9NBK0NiW+UzGW4Ag/wPwc4i/s/c4+r3gLOV8SnPdyxj0gfnl1QjXB/khKfcnII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vTbNUDCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vTbNUDCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2A51F000FF;
	Sat, 12 Sep 2026 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241987;
	bh=hiq18RE6/M2j3zakfJyFD5tOgDFpcnEy9iwR4UM6QIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vTbNUDCC/FRLa4NzuWOxgLEe9kiz57bqZ1B/m74OAviyBRfJIZo7ep1mMQcAwC+UV
	 dWjwiDrMEvm1I5th/oQMhBfUm2obvtx1AalqT+UI8xwXt5k565nnjhvV9mIFyCbgHG
	 ve630+HMZrn3yAmxqcZmC4CO/w6CJ/z1CPKjGwZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 250/798] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Sat, 12 Sep 2026 08:57:58 +0200
Message-ID: <20260912065522.889494425@linuxfoundation.org>
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


