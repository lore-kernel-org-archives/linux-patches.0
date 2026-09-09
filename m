Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49A6492E2A;
	Wed,  9 Sep 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962475; cv=none; b=H8Hrgewycafzfx9VqvB3zNe6fJoyaU9ylja322enDNzR6Ja3gA21uacOwmWUjb2sE/r1DhIgAWGmD0LcY5/Pogp8dhTX1Vc7SKPCuDqT8WqB2Zel/uC8TVgLFVNzYXUyT70P496yKx7cMFNBiCRNJPWn2GKOaTWmOVInay4hhpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962475; c=relaxed/simple;
	bh=fEh+jgwLJYGon39X/Z0+ll3sdhRPoW4bQDW1LBuJQUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5ysY//x/HZqVylyTSysyTiy90yxIKIRn6HLNAaPDg5bNMPi6tMEsQLkD72yKS801RpiPWuvlVLgzFv/d0JrBxKBWBepMqK3p6a9XE1gpIKXOmhhUy2fbXZIO8DnwbF3xVe2InPcjgaUza+XZGbqtDxt4KNx6jCUtgGo/Wz+vzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnROuLwP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnROuLwP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488911F00A3A;
	Wed,  9 Sep 2026 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962473;
	bh=iqlNBeqe9HbCVRrZfsqAqWGDDTvPVAYX175zjNCOsDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnROuLwPM6XWwCCGqtG1jWjcpBDkdW6eFF2gKjLbOfZlbXqA6qWnhptgT84LkhY4v
	 Abmf8KwOqC8CfThZbrIQsfXw0wPFN2p1ZQWl0Czpvzyus/+ka6xhfzzALB7zjLnF0C
	 CquemBS+9D03xKIfuavAJtnn5MRD1EDkk97nyqkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 251/556] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Wed,  9 Sep 2026 15:38:51 +0200
Message-ID: <20260909134239.324647916@linuxfoundation.org>
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


