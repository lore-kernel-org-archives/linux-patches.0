Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208500;
	b=HCuG2jCBOL00ykU6sZjfoKRIz+fpnUjrv+EG6XgQ7ANNn5lWzv36m5K96efhL7NdxpZM
	 Q75vBkS+py2h9nfZn5t6vFONuGIIE4LFAow+QRBIoa1FoZmxNoQOggTPLZ9oStXpcJEhX
	 y22oIboNRixGwxgB2lTs7TDwyJYKORdPR+T9wX6XNvn9mNdeB/0W+IxVcyPr0VygNqgvd
	 Lw/+Lyk1YfNnIvuyrxkbMbvXciJXqB5gADwph0AmYNlA59T1jy7zZIMitjLM+S778haqs
	 s1wRHjgXAK2AF4eb0WhKhP5y7sqlq/AHvjPvpqeR2lnhIpmYPDt6OoWohefsrHO/aDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/9Fx1jPGAxCqehyAdBz4U0mWSb7SMbzAhBcWxa2GtZg=;
	b=UQkyAEMENOHk09s5o6MeL4mPeo0c9OVXWayqcjhcMi6XExtMo5wKDwANlRG41S0xC1Ah
	 Z7FGcer5MdvI3KZ67yFsYN1hCo5GHW2y39MfN/jRh7RWTx7e583pGU6lx7a9MSO5gD5JX
	 5rXC7g7X27EkRhjHK3Q5wERS7KyxvsDinr5vaoZxsKVsbJ9nouUPXbTX665xiyfzNollp
	 02mjVLgnwo/4LvjTIj86ugp9+p5mxGL1oyoWkrtrk6VYoCaDguhg+kXlrAXh0ihsXixP/
	 u9xim4aI7/80o9TtK2eFGutZQy5VhHFy0uRdhEk4XO3y5cNTSQmVrbzMKIVeeVe2AZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vnlx3GR2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A6B606A31A;
	Wed, 28 Oct 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vnlx3GR2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142AC1F01825;
	Wed, 28 Oct 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208499;
	bh=/9Fx1jPGAxCqehyAdBz4U0mWSb7SMbzAhBcWxa2GtZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vnlx3GR2G2PFO81/pAatDicSjU+PctzkEkoGnRVdioeGVNsMvywqcBjsvrPKmoLrh
	 Jjo7N7avmZ0myQFxS66xjatx/PGvn6PAiftviiWoqSHjlmgc7M1OUd1iGw2aZH9sqv
	 y2XdXsweZNf4y+Jm4/FgQS7WT5xNrkm1E69Ajgiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.10 139/516] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Wed, 28 Oct 2026 17:54:51 +0100
Message-ID: <20261028170006.802791974@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


