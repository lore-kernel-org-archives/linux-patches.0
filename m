Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C9B342CB0;
	Mon, 20 Apr 2026 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700065; cv=none; b=Bsy/lHZP57kvULZVYB9ViVkRWlzDksWyppG1AufehdZe9vo8uJA8QxmNawM0zFO13RUY+lY/QpPfOCHKUmeSJvt9t3cBxSyd5jVT9VFC33QiwedJQKtXll8O/qTnkPwqYtO7xpvRz8KB7JuczdJ8rjxpCbjv/STj6M+UP3t8RVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700065; c=relaxed/simple;
	bh=ZK3Vjk0lNuKuM8h6HqRMZrBWxDNRo2cSpqkOpl5ktS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf7qXwh8qq7Z70ELf5Qhhto0NxMqRoBIDMECBXMt8l8nQAIuBTfgyLdYwSCJ9+rIl8ZbN7wO38j39L23Pbqoux3NeVXjCNiV6z91gGlhGAoOTiQ90Qj3qMmECW6U4doL4PQgVAx9n1tuQEuh6lOs64eQy4RW+ZXHtestGCeh1M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WC+qnMzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC+qnMzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29855C2BCB6;
	Mon, 20 Apr 2026 15:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700065;
	bh=ZK3Vjk0lNuKuM8h6HqRMZrBWxDNRo2cSpqkOpl5ktS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC+qnMzZ/AIH/dKp5qwLZGS6yYEfspg1cqB42M0A0hGvSW5xV9pZ6noiVXNAKDPC7
	 8DslXk5XWZ1RU3YIP1bQKFR/NKEy5B7f4D+5QbuGeoQ0F8Q72M8nQxdGBn6nrGv06R
	 ytRF6j/OR/pV3/d8d609e5bReS+cXEC4muQx5fmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 028/220] ASoC: soc-core: call missing INIT_LIST_HEAD() for card_aux_list
Date: Mon, 20 Apr 2026 17:39:29 +0200
Message-ID: <20260420153935.043323827@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 23ba821cd759d..c9a6471661ad7 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2849,6 +2849,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
 	INIT_LIST_HEAD(&component->list);
+	INIT_LIST_HEAD(&component->card_aux_list);
 	mutex_init(&component->io_mutex);
 
 	if (!component->name) {
-- 
2.53.0



