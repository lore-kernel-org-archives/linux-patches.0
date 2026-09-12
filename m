Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8649490BE5;
	Sat, 12 Sep 2026 18:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237571; cv=none; b=PgCBOv5Cg3mdX0eHkNktpCHAnApXY/YIglJXzbJ9f/chMesaTKH0zzrxp8ftc0fCL61qO4yj7IgICOhZc6bNsmhGSA57nWPhzEqn7pvmgq++B6Ks8rQPi/4qDbnQH+70p17rp6elpPZBrKQSsli06QP+ttSWtCP60A5ZmhlT5Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237571; c=relaxed/simple;
	bh=ru8dfBNAEJRFK3QfuI6PFOp2HExhK+qLJkKJAwIloeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzyfQYvnHoHHhKhRw8n1f14+Je8keBVg+Pzx4dfm5ZTSVq0fSwQkcGQ7La4Q/NuCW1hfyMMzbOusKeNp/tfzyNBtN/CdPlNwYosNzH5pT1c6Howqw4vdAZOpLZV1Qk52JHyUp4aSO6lDzAD5y1TKlKppmutgmeLKgFJ+j0PwKLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d50AO6Ns; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d50AO6Ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D75E1F000FF;
	Sat, 12 Sep 2026 18:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237569;
	bh=7V/BQkD/XoteobyTjEX7bqf9FgKY6toebrlwW+4TCtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d50AO6NsHNjIt18bPPQ937P4ssHkPGqyMC1JRt808IC6UU2aSUAvJ/YRL80qSMM3M
	 qNgUDuOhaOF4jESoAtLmsZGi6SmBrD7K4+xMVx3N0GdXdoUkGGL7w55ousF1mlQckE
	 VTtQn21Xa0ZVuOw81t/TngJ6CLOeakRom6cAgOwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 285/935] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Sat, 12 Sep 2026 08:55:15 +0200
Message-ID: <20260912065533.353123241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


