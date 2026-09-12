Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92115274B46;
	Sat, 12 Sep 2026 18:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237600; cv=none; b=kGrUb0Zl5N+E6JfEj7Av7K9C8QluZieDEzYktV1eRHP75JqtYpPRBhQb7n+UqirEdOocXy4lN0Cwgc4ViPUeD5sHfjOyrQSJSRAN+6OSVs55tbxs+StUR43ULeoBhgPTT7x002YYkAk3ox8e0JmcfBO9Rs4oJlWrociEP/53syI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237600; c=relaxed/simple;
	bh=thevz9AKpD5TuPUzS8nc4Tq5EkJxr0qz+YIe+gTKVSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJ2/obCAhLi1G0odzbW5b7Sw9r/L+7x8m72eyySwy9BIh0q1JQdBVqWhPO5PlRbiJF06e+8r1nH19zZp/ddGC5ekY+qi/aIzw+rGLINrXgeR9sX+uLFBuGZ5TdpGhBbEApf+62p6xdyOrFQ9/fLOu3AZewCzNOrPw23RNWNDavQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6JaXlWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6JaXlWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC6D1F000FF;
	Sat, 12 Sep 2026 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237599;
	bh=MoMvwC87/3D95qh9XO8WyyyiZPYYlB4ygnSLY/88yl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6JaXlWiYihEeXZQ0Yh4d+bvd/2N5vM/lWHZpLVJNWJHtWhP+Z9LwA85T2Th0LBAa
	 U7XRDwghbfWJq3UR7q1FBkrdp77hbIFDlMMZqEQRozRPjr8aKy5kF1k6NEIAULhGeC
	 l2GkzWI+JK+g8QzzvtezoPVZh05mN9F8mg/AcLqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 290/935] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Sat, 12 Sep 2026 08:55:20 +0200
Message-ID: <20260912065533.464340057@linuxfoundation.org>
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
@@ -650,6 +650,7 @@ static int aries_audio_probe(struct plat
 		goto out;
 	}
 
+	of_node_get(aries_dai[0].cpus->of_node);
 	aries_dai[0].platforms->of_node = aries_dai[0].cpus->of_node;
 
 	/* Set CPU of_node for BT DAI */


