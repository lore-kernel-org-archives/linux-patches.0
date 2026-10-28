Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210877;
	b=crxKGt2lyNuQlCMVcGEARQ8kFQbH2EZv2Dcnxpu4kApV6658pJZodhH30PoCN30Ibom1
	 KewAovHM8PR1lgjh5czKcjJcwlzp+ZTuAF6yii9Vi3cKKPDVbfW9YgH/7b2RtpzXRx5ON
	 ZY7QO7B2wsjBGyCpecczCwg5gH3DCBvi3/T6obk6y+iOuxc5A6+QYsAotMmy/fH4JDlvo
	 UM7AB/2SrHmH5cZwzpyEaq8oE610styg9tfWSgHzt5aR/Iv/1z09pZaRImQYO1EgBFbEv
	 eCqpqxg9JrGkH8xBMimbTwIrJdpsulvsDuG9XbTjhuNJJLcZsXC/uSmw42xg/vN6UkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/4ORiZKOg56tFI7VjlAQ9fnH4GvabDFctM0SOQgICXY=;
	b=d0RzKaRLyO+pE7r3eO/nXxhEaIsTnuQnPo+SHkUqSkeI10ZcVKI9s9rtlkIGHAaffnPq
	 urRdfihI9khv9mW/gwXOVsn8lhj1crI6U6V+8lObKl9TEbAXiDsoopYKCzsuVX4NHdjbP
	 n/sFtgCzuE9UzI2L38yC235P0s6bjKPNN9kE+fbmajUnqWvULQBEgpwklWesE7oE8gZr1
	 a7tQplRe5aUvaIqsXTdhO3fzOqZsOaPOXYyDo+yU3P+ErUBBxjC1slPOob56dC2X60kgY
	 Nh/M9DcRqysPEJ5wBLuZ3mLLBvxzYKaT8OA/scCAeMn2F+SG3TP2LHTOFgf+TTrd80A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URlD6LkB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AAC606A31A;
	Wed, 28 Oct 2026 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URlD6LkB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8CA1F01825;
	Wed, 28 Oct 2026 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210876;
	bh=/4ORiZKOg56tFI7VjlAQ9fnH4GvabDFctM0SOQgICXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URlD6LkBpeVdAYC6r3Cv8fwBW1TgN9PukVIswYcMcnRWHkgZ1Okb9Xp03LxJCI1G6
	 v1501wwGq4dEWs2FXrI7Bo+lIt+mnZTL4OOrE7vK/XEywH14i9XeTvMpeNUUp3P8YC
	 kyV0VflFwJHDD/GcM1Av2U+S+6+U7og/pR3J4r/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.15 136/571] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Wed, 28 Oct 2026 17:54:43 +0100
Message-ID: <20261028170011.245118912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 30724547b221e0e670ddfef140fc7d816b2aaec6 upstream.

Successfully initialized controllers are moved to intc_parent_list,
but the final cleanup only frees the descriptors. The device node
references taken with of_node_get() and the interrupt parent
references are therefore leaked on the normal return path. Drop both
before kfree(), as the intc_desc_list cleanup already does.

Fixes: 8363ccb917c6 ("of/irq: add missing of_node_put")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917124247.2151674-1-vulab@iscas.ac.cn
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -582,6 +582,8 @@ void __init of_irq_init(const struct of_
 
 	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
+		of_node_put(desc->dev);
 		kfree(desc);
 	}
 err:


