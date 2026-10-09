Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3845516B;
	Fri,  9 Oct 2026 14:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555581; cv=none; b=mGApAYY71r5PQU/HNeEGXMkaeEJyh173/QayGal4mIYwaFfg0VvPylpcQ8/JPccioZEd4AyV+HkX/h2mXNhjwy9BEv2xgCVu+wZl8PBPEOkE56oAOsLavm4l+9K0rvZ2HSoTVrN3gNHjVJS2HXwe18ZSl50VMDBE+jdDGSevx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555581; c=relaxed/simple;
	bh=81suvibgLy24Ma3q7L55XtUSMkWbb59B4eWfT9X0+vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQfxDfh9T5Flq2lgzkYsjDGNrk/gMQBDdJhGa7eFkOeKoLjs266SfIyg2bWJwC1vJTa9uxkvu0GEfTapeAMbOpi8fPcpEgmkQ0ORov7+FejbKr88Kj/bwoutc1xC/MzV7+Qyb43PqNnGZ3apOXewtvqWQS/enGCdYHTvUvYWjdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrsEWBeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrsEWBeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914B61F00893;
	Fri,  9 Oct 2026 14:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555574;
	bh=EQSlCYZnnlmX/n/p85vAH1sTLqSk2vBDYJIC9tL6eVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrsEWBeUxRoP6J/RMOY+kDckWJyoZK/4RWkX/8x/6S+WZCAgyGryRFgEG2pxWu5en
	 Ned6CieTk2b3RKpHSuVWrT3qHmJpJtVhroRHesVtSxxH6TZrCR084TzNiE8yPuD9E3
	 vgSyXZSKN4T2RVWPXDfhu1V3I+Mi0SbtLOKWk6Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 7.2 031/428] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Fri,  9 Oct 2026 16:06:08 +0200
Message-ID: <20261009140946.763812227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -754,6 +754,8 @@ void __init of_irq_init(const struct of_
 
 	list_for_each_entry_safe(desc, temp_desc, &intc_parent_list, list) {
 		list_del(&desc->list);
+		of_node_put(desc->interrupt_parent);
+		of_node_put(desc->dev);
 		kfree(desc);
 	}
 err:


