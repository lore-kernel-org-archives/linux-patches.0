Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909964BE43B;
	Fri,  9 Oct 2026 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555511; cv=none; b=P/V21Dsmg6PerUDo5vCu3HFUWSv73LLVOegLWsaZu6PPihwSlueQ1pLW9KcznjMg6z/QvrB2YccHyi29byls0Zy9n7Em3JjZ++TCbuVGQdUFy8PRjJiewnE1W3HSfNRqxXHl5nvnbREjyupg5yy26wk9JYHJ5ghHWV4grigplNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555511; c=relaxed/simple;
	bh=K15/nuW9KfKpmozPWtxLCXGS/MU2lWd/zBsX6q0nUHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCHRru7lC0AKSDQKNKWf9glgw//kPqlLu/uyh4jW8CP7+OCC91yt/VS8VJjt3BCH5Ll8SADaHO689iIJ7XelGGc6J8MZwsAjLfxgnm6EKLL/ahRA99hzPuejwKnT4AQ3IZ2ueAOMi7XJzFEt1LehCXbmgCzyJJvknzploJWrcB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rm+8l76N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rm+8l76N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2E71F00893;
	Fri,  9 Oct 2026 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555508;
	bh=HrsWeiYCGdfpC1/2GIqDDTmvLO4FGahNTddREHpr544=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rm+8l76Ngjs8lW8ykRY3agDys97i1ycAauUxIVFaK1M9JBzlh+jB6jOpsHNc0jIDm
	 k8Y41bO1Bsre1uKzdT9MDwtJcXHZKQInkkMDp4PQXs9ObryaUhAZSHxGeAcFhAh0h3
	 Kr/pMIOz6cYRCahx6Awzqq169aRZO8iiT9aPqJYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 029/403] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Fri,  9 Oct 2026 16:06:30 +0200
Message-ID: <20261009140952.795729130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -660,6 +660,8 @@ void __init of_irq_init(const struct of_
 
 	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
+		of_node_put(desc->dev);
 		kfree(desc);
 	}
 err:


