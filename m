Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212496;
	b=Hp1jqQ1PrlTJFJBoN0ruEfNXCeZ92kX7mlCueNL5A4ztGMqV7QbSGXrXS1J6dOA0LC3t
	 1J/QZdmmIUL+noPpgazPGQy5MG9HpyBYWIMiBhJBJfItDnwceY66eXaELv/tXvXGlMSYK
	 YiyWe7FMzCf6snU/YaIxXQFSK9dqoHT0ggK6Ee485QX/EuB9AS50LHgspBDmk1O5lTJGj
	 XkNOBDcVlBy99YC5cuo1ZJYObUU3PhO9X9m69EZq90sOYEM3NbZqD/IheSshiwPM46/BE
	 /B8b4CCiC2InAxKU9ACg14zMCL3HFYWReNPeciaAcyYemOvWM/Tq60qEzora+91dbww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KYD9AyPNN53FYiHSPqaHjszL1wJ0zixgaHQzUNtuC6M=;
	b=KqijB1YXBpyCeCXfu/Ak/wsKebQASPXH63UjxCSxA2Pu1tCO1owHAVW1lw0PWfc1E53y
	 14/m2b21nzf1oqm+FwL4X1qRLuZOVddusqPtUXl9kTt8U/S5iHUWtW6I2PfZjhOrsDBKO
	 KDn7OLjUGDh5httqzxKnCI6fpa87bzPAvAfZmiK/HtTm9q64UK0+jO7L2SGCRjnGPpdca
	 4Sx8tZT9sFgKQoTrV1rcdHinHefX49diNpjH59+z82kyclDpLsgVd/+cxNyt4O4dD1YuF
	 l4JVx328Ev/OBitJPD4WIXLCWR2W9aVKWy/M08XO3qQud6ccLjJHZmhGsXDfU3GyMiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmakXtor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B382606A31C;
	Wed, 28 Oct 2026 18:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GmakXtor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C58C1F01825;
	Wed, 28 Oct 2026 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212495;
	bh=KYD9AyPNN53FYiHSPqaHjszL1wJ0zixgaHQzUNtuC6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GmakXtorvMRLRMs2JNHphaUp6QuWXr7u9LlpK5gEA35WAzZsThWhmBPqcerp917HI
	 Lqyz5X6jEj1bHnrCjZRyt3BZtLtn01g3KZ/UOg5s56ffn+Y5p8BEEYGMASu6RxBn3Q
	 7Jh0ob/cz5Q977Bzb3dNFR/502l5BIh89qGZSLWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 0174/1887] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Wed, 28 Oct 2026 17:37:50 +0100
Message-ID: <20261028170503.197828909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -654,6 +654,8 @@ void __init of_irq_init(const struct of_
 
 	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
+		of_node_put(desc->dev);
 		kfree(desc);
 	}
 err:


