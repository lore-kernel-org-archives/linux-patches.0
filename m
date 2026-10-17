Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA403B19B9;
	Sat, 17 Oct 2026 17:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257555; cv=none; b=ktQgGwfXPNG99dgxAngYXT6D/i7xYsaSh3SE4OCKDE7TB6B6dolXWs4qgyqv75kbjSMUwzcqZ42hDEB9lZ8lD5Gc/rz/bthoJMBVQHVqHgMtAmNGLNZbyXxR3t8lxbv6PzqynqGi5enZwvUiSqtP5KFrIS64Ei6pvMqoOmc2vT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257555; c=relaxed/simple;
	bh=EcflqZbJusZeqUI4vCY/CxFb0Ht3OmjiJuakTjdsSC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebYEGNqr0qnojTrbinw7cGN6gKqEK45lV85muKbhUsq9+3YgmbfnjVEC1YAljTue/HKvB42gm7AyzK0Xw/vp1U3YD9p2A4b1YsQntR5cAmWW+kelUGSzqXIgr1YqZFmXIfbn3Y1XVxNfNaFHFPReFs8fUB8ayqWscbRq2V0L5Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXa0OGgt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXa0OGgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF711F000C4;
	Sat, 17 Oct 2026 17:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257553;
	bh=Y2+sQEjr738GgW+rPdyZBzZNKXrekaOOqN2OK1kzQfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXa0OGgtuSBgKm8LH88ZLNR8jEm7tpCu5eWm3l+xupwrLVMkorDL5+vx/rKpnZFqX
	 HcK/k1+13TM6z1SN6WbFxpd8RcTMS/oWyi+WFohpIUJn8Kktaw07tJDxDZHisLePUu
	 04W0YNpfIhp+rgJkw2xx4OsxSe9a1dQ5nXDsQYK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Mark Brown <broonie@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0596/1674] ASoC: hdac_hda: Fix hlink refcount leak on component registration failure
Date: Sat, 17 Oct 2026 17:47:48 +0200
Message-ID: <20261017160446.379328286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 6ad4892c4f5cb437a928a02f5b7d37d496aa9268 ]

hdac_hda_dev_probe() gets the HDA link with snd_hdac_ext_bus_link_get()
before registering the ASoC component. If component registration fails,
the function returns without dropping the link reference.

Always call snd_hdac_ext_bus_link_put() after the registration attempt so
the reference taken during probe is balanced on both success and failure.

Fixes: 6bae5ea94989 ("ASoC: hdac_hda: add asoc extension for legacy HDA codec drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260622145645.1184986-1-haoxiang_li2024@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hda.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index d59d38ce5657b..c497354251cb2 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -612,10 +612,8 @@ static int hdac_hda_dev_probe(struct hdac_device *hdev)
 						&hdac_hda_codec, hdac_hda_dais,
 						ARRAY_SIZE(hdac_hda_dais));
 
-	if (ret < 0) {
+	if (ret < 0)
 		dev_err(&hdev->dev, "failed to register HDA codec %d\n", ret);
-		return ret;
-	}
 
 	snd_hdac_ext_bus_link_put(hdev->bus, hlink);
 
-- 
2.53.0



