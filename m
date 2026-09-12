Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E42400DF9;
	Sat, 12 Sep 2026 11:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213506; cv=none; b=uDChmACfneza5xj/LHRxejtOxKEDDQ72CmxSVXd+VRRkh19HoQ6t6psQaSX5aiptGsLSzkXCBxA6EVlnw2t5/I5YbSeim/vE0AXPhyfzziw398JrM+vlfQRzNuaLdZ3XfODkm/GgDiQlVoIxpuexQmHkj/5nTfhhrN2VVvb+SrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213506; c=relaxed/simple;
	bh=jOrXm7LxL5LaxVBWz/i7OKg6gg8o2+Giarp1qFW53rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrzbVp0NV7e09bKf+/9X1xhVfKOrTzTvir/iYsyXlv6L9fWJgYs6xfwCaw6XLPbWIBCzEmGZr9XRXVRD8td+SQ/feapAu/wGnYG+K1HhTcHo+h3vQjgREKaUqVaUMJNi8wW0M0PORffdSRsZVuvUZBEWiXqtDJWUdhQ3JYfL46Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qwx+7O7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qwx+7O7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD7E1F00898;
	Sat, 12 Sep 2026 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213502;
	bh=R+4QmfGpNGBUiC9Fp07WjZ0PDNPgfmZ+nGntHyNdwJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qwx+7O7W80/f2Hg1TuxfO2Zj4cj5Q7qkwtDsy3jJSPe4CbtdMPq60BPYicmLZrtRn
	 g9iU04uJLxVTz0rDG/rxYBcIighkmaaTGsjvjYfltvwFmitEEL1K1v2VAnH9UaiYZB
	 5hmQf5E8PjGmf9BChCVNwmzzbs2bNXt9yVaQjahk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0133/1376] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Sat, 12 Sep 2026 08:42:39 +0200
Message-ID: <20260912065610.518827752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WenTao Liang <vulab@iscas.ac.cn>

commit fb5d1b1c5f8a920ee697545fa6dee16825085717 upstream.

In aries_audio_probe(), aries_dai[0].platforms->of_node is assigned the
same pointer as aries_dai[0].cpus->of_node (from of_parse_phandle)
without calling of_node_get(). When the sound card is deregistered, the
ASoC framework calls of_node_put() on both cpus->of_node and
platforms->of_node, causing a double put on the same node and a refcount
underflow.

Add of_node_get(aries_dai[0].cpus->of_node) before the assignment.

Cc: stable@vger.kernel.org
Fixes: 7a3a7671fa6c ("ASoC: samsung: Add driver for Aries boards")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260627035251.60172-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/samsung/aries_wm8994.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/samsung/aries_wm8994.c
+++ b/sound/soc/samsung/aries_wm8994.c
@@ -658,6 +658,7 @@ static int aries_audio_probe(struct plat
 		goto out;
 	}
 
+	of_node_get(aries_dai[0].cpus->of_node);
 	aries_dai[0].platforms->of_node = aries_dai[0].cpus->of_node;
 
 	/* Set CPU of_node for BT DAI */


