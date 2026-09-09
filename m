Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8AA423A85;
	Wed,  9 Sep 2026 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962229; cv=none; b=fHrnrntomKW9SBV/pje1sK5uHxvOHmQ1EGiJs+mjYXxDCW7J5NhvRHtoFd4jFwC8et5ppG3nCOFBEtOxuXzmzWGgAUn3pogOoZcKlfdcy1T1FymTG024MTNKeFN8FBTCxHu6Tawkr7QOWUfSyptoRiW2je2xqWQDkwBRGgTD6/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962229; c=relaxed/simple;
	bh=cermoDX48Uxi94z779xn8vPlCxE+DT3UjGl2mxK4Il4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW0DmDFiDPVkCeodyaN0U21pXuRBxzCGX/oWBuGWNehovZ1sMvhZ1ufdEvudZstLmB7WJJrYJOg1r33qmU08ip9Kn5fhCG6jg6W5IwNPQg2ovYa9A2gfsHkM65rzR013lxu8XyMY3CALTMMi+djlsCu5ARuEg08whj1qE+C9MxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yznn4gh2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yznn4gh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333F41F00A3A;
	Wed,  9 Sep 2026 13:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962228;
	bh=okgGubfwg78l55+CsWINeLgw2BVTD7QaVCgrWhHFijI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yznn4gh2z2YJDGyJyVR28qHqG2VUBux/bVyNwgTSJzUJMrd5iJnUFd6vl8tO8UcmK
	 7z1GXVrIY+Ek9U6z9n4i80CvUSyO4pssNhqAqtg1+Md6Q4rHi0rwxaHufTtIR8z/91
	 I17VDrRSCWH5sE8uf6VJR+465XlTozCgrV6gZ7Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 219/556] i2c: mux: demux-pinctrl: fix OF node leak on kstrdup failure
Date: Wed,  9 Sep 2026 15:38:19 +0200
Message-ID: <20260909134238.104297513@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


