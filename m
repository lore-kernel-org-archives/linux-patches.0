Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118834EDCD0;
	Tue, 13 Oct 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894699; cv=none; b=CgUitNfhLFTNs+2sIi73Gwl4FhQ4fbh77H+n4AFlBW4AlcFbvfk4Cpv259RJrfyjLgTV39cyOopx8aci+h6IzNeki9BpcAqqYZbPV8keI77SR82cwyxJ4Vgg0oqtnySQeshm4BXYX/dUHHp27Get4WYprGAEnL4x4pIpDchXp3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894699; c=relaxed/simple;
	bh=s0LuwrFop7r/eCGhVgX2l4ifttiK7T1/3+BCB7k4YaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhLLAHzsTjS9nLDIA1ytmB/AP18N9gCYIZaTi6XLMg96WHaBvRCZW7T+xpIMoIaH8ITNYG04ZirTRINHOYcppAY2lfPu2h7+z63lfbctaEA09Ze6bRcM/IjQVyNuY16SzVoSsIxlJ5MnCZF3BQSp5v/y3UWgfYall8vMgJnHUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvpDDwnx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvpDDwnx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647B31F000FF;
	Tue, 13 Oct 2026 12:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894698;
	bh=j3TBFMBhOU5PHLruYmM7r8dEmx+V+YqJFYY+CzYqcQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvpDDwnxbNYuR6orR+nzUZyoMHGZPbECa7qfJfMO0m4kQEwKWg2m7s4scgbdDi3ci
	 yEeD4VJzEgtmM0XHwgC83N+KpB6h09vRa5Fb8ErC2bd6v+88wLPYeLtRysD1ZiTrzJ
	 QhrvpQySvPU8Z7mcA4qSnkOA+u/4LME4GmA6YQIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 026/497] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Tue, 13 Oct 2026 13:33:13 +0200
Message-ID: <20261013112908.505048761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -659,6 +659,8 @@ void __init of_irq_init(const struct of_
 
 	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
+		of_node_put(desc->dev);
 		kfree(desc);
 	}
 err:


