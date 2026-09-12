Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DFF309F08;
	Sat, 12 Sep 2026 15:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228216; cv=none; b=rqQyXdc5u0E1XsxcUT67mxcCUhzEz7J5BhSf2u90JotW4bpt20X2jHCOhhvkuGOkcTaSSVpox8iM83xq+Vzs1URu2oy7senJsUizwzUkvWHWAvttF0MoIgEy3ZwvvK5bbzZpX200rc7y4EtF7JnnvRBG8u8MprxcIBBUkZveSLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228216; c=relaxed/simple;
	bh=Zpg0ulamo5EqfGy53oG1ZWkvxC4OXcWhys2JktWthOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KisvQ8xPJGBWlOJbTKjan6E44YT/o49kkC+9ZgLBua+2WbPjSNqMmG38/9j54lJO/guF4zdVKTWC7O1lsyjNoASR7woYABBZt77esSvkQeveKvrQ5kH32nHs9HRhLmsDck4S9u2UosetOXUmJ7cGhzD8JGDLY/0/SMcS4+HYzhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlZfrD3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlZfrD3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1721F00893;
	Sat, 12 Sep 2026 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228215;
	bh=lso3BJtlQQEITRlE7gKs+Ln3Qj1Hidq1vVgz7KqBwlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlZfrD3YUUzXTu4RFppGPeFuOQ5CebQepSKviCe0sbREUtoHXrn5ZDTY2OPPpIS8t
	 k7nohXLd9X59t8hB0lclDqKzVMxqO3Sl8TViybiQePFMWcUc9vQ3FMIs0pcwVZxgVy
	 xtg7muUxjoOD/nrP/e1UTrDfGUW3lLlSdoY8ZYs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0341/1191] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Sat, 12 Sep 2026 08:51:09 +0200
Message-ID: <20260912065555.887271994@linuxfoundation.org>
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
@@ -653,6 +653,7 @@ static int aries_audio_probe(struct plat
 		goto out;
 	}
 
+	of_node_get(aries_dai[0].cpus->of_node);
 	aries_dai[0].platforms->of_node = aries_dai[0].cpus->of_node;
 
 	/* Set CPU of_node for BT DAI */


