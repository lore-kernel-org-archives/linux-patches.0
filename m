Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA7C3382C7;
	Sat, 17 Oct 2026 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256356; cv=none; b=igIjfLhuOTyeek5OOuu+wNhv+A3/vN3sxAqCgyWJ9Txx5oZoUiN+e+BoTjvvZ33bH/plzsq49RScr/VDfsJLj5W1U9yYsoDwidtjI7ftTWBofVmpG9nrsX/Jhw2sD4oGujIChMgnHQ+PIZgydbqwH+KuwcG/lYJhWAS7bl1rhQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256356; c=relaxed/simple;
	bh=jK0VcA0ZMWvZQ69+0uyI4TAQg4U60rUBUpGG6e2co0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCOxL4doAJF9bCwWvhoOMOw11VtAuaXQsrJ9seNjXePK6yylhBCzoALUKAmBfbLjSeoqFpVDr1HE04sEUCG+5eDXKJtntp2RElQuhw28cVqTbxoFHjzTPBSy40xGRuV5Pj+F6P8H0rJxDY+u6KGCE0Y8zAxclyoOjuNY0SlvZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/H7hPSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/H7hPSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF601F000C4;
	Sat, 17 Oct 2026 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256355;
	bh=Y4TcYZ5Ejid+TFTvyTmCBCHUpU7L/SnIuF5YSDutGnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/H7hPSkOtLqwsXm2ZAp74rwJ+F3nDdsSYGVXqiJ0GlHC9DKUegoqubeVHGYpY4e2
	 7PYcLbYxpzPMyGLyI7wPC/lDY24FSW0VlVMPej1Qy1N5Ugk1fprrJgtSxJ4Ezxbw/m
	 R4aEYhQFBjkYcNSV/TdqiO6RNQQmOGkvYuIJTyrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 0167/1674] of/irq: Fix remaining refcount leaks in of_irq_init()
Date: Sat, 17 Oct 2026 17:40:39 +0200
Message-ID: <20261017160435.447467835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


