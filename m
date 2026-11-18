Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034174;
	b=2v1dQ5PNJ3m+Ows6Q93l2ZHgEQjHx6dbFHJsf5epjP7l8h19F90C/jvVDETsbr1pRihg
	 0MaLtxEo2NEhxK/57bHbvNX3pI7TpTX0dz8idm/HXTD9ESPpG4C9qnfkeCy6o+RttABu7
	 B+XTV5oyKih380IBV/Bh40SA2PvjPdCPPwbFhiAb05J0V03gA4ppNLXDgTrOLkpVgTMIS
	 v1BfrlEB7Xl0Uv7GdVGau8H3qgrzANrExh48/fW5JnJmQFADxr20svR67/ODz0UTaHsag
	 2JI03adZynov7hTjcxEmXuJP5EuNdP0QlmtYvVKKI4Lh+W18prLl7QSBge/FXlRv1hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lII/qKT9bn2Bb8/Wuw7Rqcl3eJJPBmGb5ylINnjiMAY=;
	b=GAs408NNKf26IccZLqRonM8q5AHj34UH3k7ZuYQsQ8SEO5FafiSiXkQqbAIoQvXfb6B0
	 OXdr/hS3QH9XjCjRq8H/G2qls9wB/mchyX1WJy7xeKfLtc7yMLer4UXu5uS+u/OZI60kl
	 6rE1TDN8/TsqgSQd/MBzDX5dE9mUnM4JRuMCYGj5TjX9Dd+3lVHB9IxWpiD/FRvuzOL9t
	 01/Haii0K7L7mH0NL/prpch/OYxbmTW6JOiYru76gLNad0YiASEW2/sOKiCgBxgL6Xcfx
	 D1yaO8Nuezlovski7AlM7agkDnv/O1paLVgnQBD2dvddXgbexZVrKXBBXwUvMdnvlMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZsiQCKn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AAB606A320;
	Wed, 18 Nov 2026 20:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZsiQCKn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85C71F000C5;
	Wed, 18 Nov 2026 20:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034174;
	bh=lII/qKT9bn2Bb8/Wuw7Rqcl3eJJPBmGb5ylINnjiMAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZsiQCKnGTMWR604IrhG3++Ku99C2oig1Koyzv8EkDqcs09Rjes8Zu1Lu33vo2BqC
	 6xe/zQ5g5ViUxVy5uo8ehQ+WZ07CDDmK5y+H/1JZ+E0iDQIn9f8xfgvwuMnUZO+yAd
	 AANoVlCtSLs+s071lZ9AKZajdaXbB/+U2WKNDnhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michail Tatas <michail.tatas@gmail.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0275/3318] ipmi: Fix leak in __ipmi_bmc_register
Date: Wed, 18 Nov 2026 15:14:57 +0100
Message-ID: <20261118150323.729648989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 18e633dd9674c8bf118ea8583bb5a531edc2728a ]

In case that ida_alloc(&ipmi_bmc_ida,...) succeeds and then
platform_device_register() fails, ipmi_bmc_ida is leaked.
Fix by freeing the error path

Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Message-ID: <anUK_HOy_pCgvsBm@michalis-linux>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 11e3012349c57..f0c8b4f1b551c 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -3257,6 +3257,7 @@ static int __ipmi_bmc_register(struct ipmi_smi *intf,
 	list_del(&intf->bmc_link);
 	mutex_unlock(&bmc->dyn_mutex);
 	intf->bmc = &intf->tmp_bmc;
+	ida_free(&ipmi_bmc_ida, bmc->pdev.id);
 	put_device(&bmc->pdev.dev);
 	goto out;
 }
-- 
2.53.0



