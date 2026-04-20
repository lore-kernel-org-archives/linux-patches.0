Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA0B329C6D;
	Mon, 20 Apr 2026 16:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701279; cv=none; b=XnwYTN0WymFUeIgcaDnvmwfWxqlZsmp25s7bVPUfcqSYWwitrgNeA3d4eji/18Wej7yxWwTAyYLYlyOKR+E8S5jD01kD4CkOxqRWfGFbCVWLo/gckbZBvjZSIyH1KcxhkOJCZtQ/cxFojz5P0QGcU2NMCbPeAjBZ5xn3la59mS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701279; c=relaxed/simple;
	bh=VkDtn6Lm0Z3zletnGWo2BUcEI9Wl4AZKEqQJD2mjSOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFeyBYS7brI7WCt5A25CDiSOJKqxoWTioyjWrLzuhMrXLEZCy7jM1iTOJOw2DI3QDOL5l85pZ0EswB4ErCS7Qo7hU6Xnj4YBz4Cz9lufwIgk+ynnP1OHVoOmOQgm1y0oM5RNiyw/SSCt3ok/uKih3pXCTlE9s1jrXAAteJTkctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7F9NubF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7F9NubF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833D6C19425;
	Mon, 20 Apr 2026 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701278;
	bh=VkDtn6Lm0Z3zletnGWo2BUcEI9Wl4AZKEqQJD2mjSOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7F9NubF7S24bsZjkx35V8gMfq3HwIVgZdj9CsDdyj6LQdAECr8kbiJSloPKPihPN
	 682m8pUw0J6K4gSjEirKV1/DdtLEqK6i9K6+l6kr80geZ5bSETR4ii416OT2lb5113
	 E3d6EtxSn17WGBjptwlCdqY93cL7LZVnP17PbflM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/162] ASoC: soc-core: call missing INIT_LIST_HEAD() for card_aux_list
Date: Mon, 20 Apr 2026 17:40:51 +0200
Message-ID: <20260420153927.716176354@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit b9eff9732cb0f86a68c9d1592a98ceab47c01e95 ]

Component has "card_aux_list" which is added/deled in bind/unbind aux dev
function (A), and used in for_each_card_auxs() loop (B).

	static void soc_unbind_aux_dev(...)
	{
		...
		for_each_card_auxs_safe(...) {
			...
(A)			list_del(&component->card_aux_list);
		}			     ^^^^^^^^^^^^^
	}

	static int soc_bind_aux_dev(...)
	{
		...
		for_each_card_pre_auxs(...) {
			...
(A)			list_add(&component->card_aux_list, ...);
		}			     ^^^^^^^^^^^^^
		...
	}

	#define for_each_card_auxs(card, component)	\
(B)		list_for_each_entry(component, ..., card_aux_list)
						    ^^^^^^^^^^^^^

But it has been used without calling INIT_LIST_HEAD().

	> git grep card_aux_list sound/soc
	sound/soc/soc-core.c:           list_del(&component->card_aux_list);
	sound/soc/soc-core.c:           list_add(&component->card_aux_list, ...);

call missing INIT_LIST_HEAD() for it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87341mxa8l.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a1e3829914268..5097b287b889a 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2801,6 +2801,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
 	INIT_LIST_HEAD(&component->list);
+	INIT_LIST_HEAD(&component->card_aux_list);
 	mutex_init(&component->io_mutex);
 
 	if (!component->name) {
-- 
2.53.0



