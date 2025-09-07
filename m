Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF97714BFA2;
	Sun,  7 Sep 2025 20:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276244; cv=none; b=tSg4fyrykmsxxTiy5Er3zoYnw4V+nnRzp9w4QTP7LfpFP+4s0x91b+cpYY7UBPJ68zNXuDd5vc9NZwOcAzTQCLLe8iNJIB5+2wasxDWeiscXgc2aUWOUXYE+EX3f8bHV081rUOaqI1EGpDrGYOvYYhr2K4ItTeq95Osakh6rtaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276244; c=relaxed/simple;
	bh=m4jhKvHN+gDMFVAzYkqvesXLsOM6bdggRsYvVmD9dfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsapAXpE00QSHr43WBom8mnXpnGvjSfgyn3/jlNHYcPgjr15YTSsHDbZoaYuvuZ4fVF/cNFoALphw57H/Rtxx2X/Ef1/2UdNnVk9bZs6nQSnOLlOUD+Lg2GJg6IxfkAlXLLd2+zlxOz11Z29Q7BCOSkKnOCSt9+R7oH8fLTHQ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXJZe0le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXJZe0le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F5DC4CEF0;
	Sun,  7 Sep 2025 20:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276243;
	bh=m4jhKvHN+gDMFVAzYkqvesXLsOM6bdggRsYvVmD9dfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXJZe0leuPfXu7iWbaOdQ2NIav5oCkq3TJ8F1FB/dXbuOO4SJx0ybDrt077MDZOqy
	 GezrpS/n2aMDzWKwpZZ0Bw8tJ/sHwTK1MfHpQIQz/YG0EPxa1jVbCYfQP39g5ZJ9SP
	 a3YLDPw2NXDRl5yzSglRe37VizyPJTaHi5DbceFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 6.1 042/104] pcmcia: Fix a NULL pointer dereference in __iodyn_find_io_region()
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195608.789161361@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


