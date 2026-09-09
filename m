Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2F56E05E;
	Wed,  9 Sep 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963756; cv=none; b=QDsEvzSByYVJzhLzmlK+1+9xSfOIyhjTtL78Bjb83KPlr0o5xl6RzrnDDWV7Q+zjytG0mOLdWwomgAACsd6bM9RlrjglMvwjnHAoGoeHCwBOTporikR93KKta/owLORz2gnsqQX0eY+/9G+ZusaTsqIXQXg5i0kSZiHziRakB30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963756; c=relaxed/simple;
	bh=2/s4aFGg/n3cOx0YMr/fJfNd+3FEbvXXyEOkEJCrlsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYCljCtjFqSo72FAuJ0JA9GoGET99wTowhqAXmO4ZqzPYY4cSuJVhZJ0u77Zp7qpFZrK+RFs+nt/c+ZWbiNpGDxCyuB5kE0KylxFE0ahm8P+boxfZIBtwdHoLrDugYuqbSsnj4MXKnGfW4IO6Fzv+JWg3Ohe563owtDckseFbRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kV4Hcgb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kV4Hcgb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825391F00A3A;
	Wed,  9 Sep 2026 14:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963755;
	bh=xyepi2C0hjFVBA9GkSSz5d5B3l83AZxlsgsBmnnx5vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kV4Hcgb6GNCEN1qcAcC1HwlxhNLxfrRIUay1Fs8Yu3UR03WOHAbPDgprG3Yn9fSUI
	 TFEjCrxdk8TgOo95LcZ+0ixZESiktajhkLAceg5oD9s0lQ4K6GVLhAK1D/1/4xI3iV
	 OnYQ10D1zeCYDS7/g/r62Hrg145quOkV4GXKopV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 189/583] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Wed,  9 Sep 2026 15:37:54 +0200
Message-ID: <20260909134244.723778443@linuxfoundation.org>
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


