Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678392AD03;
	Sat, 12 Sep 2026 19:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242011; cv=none; b=X90/4Q/EonVej0FQDiiEYj9BcP/GHHMf3rTNa5ybpcv82WREibEZPMqaSDSIfXnWVfYm2mLfkfuNic9A8Db3Hj52nk73IYyGGAS/ox+BskhWy+FzL8t2ZMC/OnlVb6Tv1tQWROUBd9KvrjCG1Iad1rgQvf65RmQ4GgMarQTVCY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242011; c=relaxed/simple;
	bh=pq8WkudBvAjud61O6TNjXdQnh/arLA52A20oNMRcI1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbCZjZvHCmHcK7CMTNhYh9vbmbVrwu/SN6eWgtyudyHix1sjab0hYZ7gEvZvC+sYeomQRFl3C5puAHtxyz//pq1H+GfcUlEt03l+hzVHFXFXf8f9YTaIzWokr2SmP5l7Th8eqGuENnt51a0rMRsq24JNB3Xa05gdJfQqSJCl+vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLihHpHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLihHpHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23331F000FF;
	Sat, 12 Sep 2026 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242010;
	bh=Eb6Q90xoDlkk8VXm8B0jHlM5BtBmaGpHQ3aSfuQVlxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CLihHpHQsWQKEO4dOa2IrGfudCWWrXEG+6vGVfYOq8NNEpMfSyG5LLN+hbjds3OQ/
	 x6wYirL0L+mp+ixG7dTYxvIAkaNjurDozu3Ub9HcOoF7NZYmzieZgBwADe6TP8E372
	 RJSeSwg1pW144ZgYmiu3y/WLrunL1W1hHl5nWulk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 255/798] ASoC: samsung: aries_audio_probe: double of_node_put due to direct assignment without of_node_get
Date: Sat, 12 Sep 2026 08:58:03 +0200
Message-ID: <20260912065523.004541278@linuxfoundation.org>
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


