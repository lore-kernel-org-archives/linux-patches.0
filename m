Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ABC3AB276;
	Mon, 20 Apr 2026 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691959; cv=none; b=hx8DQ4B+hW/aG1OyIKUGlBvQYLSXQa/FypZstTBlu+qrRHzdqlWd9U4c+ACE+wBrzGMTZnkBwWPialZuzO8/PfYdNbNgsgSzEThYZ+Ct7f7uOr68sKExp3hR8ZtH2SFfsA7DM1pdBYJ8WDvFeY18Nu9ll3mBBd8tH2SZf+iJXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691959; c=relaxed/simple;
	bh=yGG/Ei/hfptsph2VYmrvKtY4WSmY8/OSc4XuVGW2U+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJUrAXjc4Fc4DHKWlWO450xOlLbhDLqSfI9Nci/B9ZSK8YHR9lJF6Vu8aol/ntGIVkTNBSbHJ/3Q9mK58eOUI/4Y6hzcTKJnQb9Wf/SJPVTj4QSlGNtEtfOHp5AfrR1ACDPej1XpnK6/oQv858aM7F5fmEkcfmsSpdI44jvJvv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l39uOG9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l39uOG9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A0EC2BCB4;
	Mon, 20 Apr 2026 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691958;
	bh=yGG/Ei/hfptsph2VYmrvKtY4WSmY8/OSc4XuVGW2U+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l39uOG9RCn3uG6ruqc7PIHVkVEJ/VHncFmj+KiVKnBYnnBVlDvGeaGYBZit9ZTP0L
	 nOIOhngIVrzgpkrGVmyJ7T55TyANH+mpW3su6z4f2faXEDpibe7Xh4VKQXSx2Fnpu+
	 X0a5auR7fAgkm2uOZxwonNk2qYq7wCZx6BxgAX6QGLhHZRoEO8aR81YhxNvSDCawpM
	 k1A2eWr6+eoKE71L3OT75mm4T7dpTKf3/5ii/37eqNvqrV7fRg1fHluixNx4+xbP+9
	 k8v2OC6gQrcK00m7iMI/WhJQOmaorWm8ssDqA4oJ4KeB6Aa3z/5sHs4IpVjR9vd6pJ
	 QDCu66YWTfdVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ASoC: soc-core: call missing INIT_LIST_HEAD() for card_aux_list
Date: Mon, 20 Apr 2026 09:21:25 -0400
Message-ID: <20260420132314.1023554-291-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/soc/soc-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 7a6b4ec3a6990..feecf3e4e38b4 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2845,6 +2845,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
 	INIT_LIST_HEAD(&component->list);
+	INIT_LIST_HEAD(&component->card_aux_list);
 	mutex_init(&component->io_mutex);
 
 	if (!component->name) {
-- 
2.53.0

