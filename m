Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49093BF677;
	Sat, 30 May 2026 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165224; cv=none; b=WPliWUWGLLR8rc0Hfks73uW82JPlqk5s1CjiO9PzFYQGDA7vbwFIzbfhX46DCB0uhG4WAbDmHTzoI0r64r/YubiVN9DZeRtKYFnmzNJ0tqtiJYZ5e3e4Bw96kdTcDtifUBuWtLZnkwG+GCZlsLZkKHGKmHkPZzX8Dr6u2cPDCq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165224; c=relaxed/simple;
	bh=0WnvGGg0zAlboB16WXwMEssXS0ShBu+qbr/hFJ2P1xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITf9r549PnzJuRJuEgJzKkkqZ2EwSv1BJ2wnNOCYOThjis+vKuzUqKJDPP8FKfol5CzK/bwyBTkCRzZBJT7Qo7tScYfAIRB8ErdX7vvTcxY4nK4KcRZ+408pQ6t+JE2ldFdQr6quR9BBAAP//ygBYEv+Md8wxThSuyBda1viW0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8lTO3XI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8lTO3XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4841F00893;
	Sat, 30 May 2026 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165223;
	bh=rMZxCuP/K/IKPZ67UlbEOqba+GmY4EhB/302nEGDAKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8lTO3XIvwgaiCrlZsobJxOo0Y+D7JI4aVa18j/RCJ8+/xrdh0sW0KItGg2fnRwWD
	 iDcVRagqSidBLCMDbHH3SUWdu1yVxcflo5Jk1e+I5Ri4O5aJn/nQnAi/g18+zhoHJV
	 eBK0U/rcT7zsWm9RLH+46SwsL58iy8AUVmsEDFQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/589] ASoC: soc-core: call missing INIT_LIST_HEAD() for card_aux_list
Date: Sat, 30 May 2026 17:58:09 +0200
Message-ID: <20260530160224.795243636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index e7310642be6a5..de81858dee34a 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2628,6 +2628,7 @@ int snd_soc_component_initialize(struct snd_soc_component *component,
 	INIT_LIST_HEAD(&component->dobj_list);
 	INIT_LIST_HEAD(&component->card_list);
 	INIT_LIST_HEAD(&component->list);
+	INIT_LIST_HEAD(&component->card_aux_list);
 	mutex_init(&component->io_mutex);
 
 	component->name = fmt_single_name(dev, &component->id);
-- 
2.53.0



