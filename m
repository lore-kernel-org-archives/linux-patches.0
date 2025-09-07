Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9857F4315A;
	Sun,  7 Sep 2025 20:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277716; cv=none; b=q6nStkqoHuzVxZvDGPsaczGrShimAMyszgya6zeUsb3HR9WsfAARokd4W9EdhhCfYeCs+01TYQR4DudcH23mk9LiwlgOp1OivZWc/f/nN5Nr6es4OjoDydJO+Is/USnPXN9cWid05qodi8YtJBNZMDzGa+GQe7iOX1WZGoosNJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277716; c=relaxed/simple;
	bh=k3BHoZCUqVxJZK/g4q2a1npD2g2c/V+O8orbOXMUvYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOerSetEzWFISor6cvXJA3IrenpY+t57UJc8iWYTfNIfRy1BAAkAbuUSTlUE8FoDIIdKbeqAdy/20WukfvgNBc51bitTHeTyiShhMDwTjEP8u5PIB7QYEFTIdBTn+kZShmAwVmkzx6Op28R7qPttUb5cfX0l9aSIkuF7AAca+0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCjhNk3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCjhNk3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDE7C4CEF0;
	Sun,  7 Sep 2025 20:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277716;
	bh=k3BHoZCUqVxJZK/g4q2a1npD2g2c/V+O8orbOXMUvYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCjhNk3+AUYiOV9GwLdBO/swzjhidk/BlpHt5nttj2MH3LUrZwP9uIty9Nm8QF+9S
	 G0CILI1k9ClSDc9Y2nu7auDJ5LjRCp/47FlzrQy3FuiNNErYkifsTbM4hjRnLEyG2x
	 tndNkkbWfV1yeaxbTCmlbuwRZNgdduAqUJZxety8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 6.16 100/183] pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()
Date: Sun,  7 Sep 2025 21:58:47 +0200
Message-ID: <20250907195618.163823914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 44822df89e8f3386871d9cad563ece8e2fd8f0e7 upstream.

In __iodyn_find_io_region(), pcmcia_make_resource() is assigned to
res and used in pci_bus_alloc_resource(). There is a dereference of res
in pci_bus_alloc_resource(), which could lead to a NULL pointer
dereference on failure of pcmcia_make_resource().

Fix this bug by adding a check of res.

Cc: stable@vger.kernel.org
Fixes: 49b1153adfe1 ("pcmcia: move all pcmcia_resource_ops providers into one module")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pcmcia/rsrc_iodyn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pcmcia/rsrc_iodyn.c
+++ b/drivers/pcmcia/rsrc_iodyn.c
@@ -62,6 +62,9 @@ static struct resource *__iodyn_find_io_
 	unsigned long min = base;
 	int ret;
 
+	if (!res)
+		return NULL;
+
 	data.mask = align - 1;
 	data.offset = base & data.mask;
 


