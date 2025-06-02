Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F9D221F12;
	Mon,  2 Jun 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875729; cv=none; b=TwROyRAfbnSPOTR5COx1au0pKrZZ43Hh4gGJUJhENqBFxdvvCpdZIXIMTYs57Ebu0qd1qaliz0L6U2LSMWsQVh6siE+pE8Wt/oqURsFxMn5ViKYVrAlZpQ3KJZR4AzkKoFnMvRluDu0q1t/z1V/OBi03CMQJx3gPJzZFk99TzuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875729; c=relaxed/simple;
	bh=RQQxuj0MnwitMTcEu0m8XRa5aCtajyarRHJF4bAER2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6luBDLxMRv/7POeofMsUqmjFQs9xd9I+yeSMwJ9tz5jmfzfDuoyJsJQMae9/n8q8qndGtnO6b1xFaHlDFZ28l+ZjgywF31tcTfzSwx3ZZCXV0O5pG2EDIp5y2CZVI9ot6gIAvimlGz/2SgnT8Gt3bZO7S9vmyDkA6BnWNWZnRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bDH4fIRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bDH4fIRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B52FC4CEEB;
	Mon,  2 Jun 2025 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875729;
	bh=RQQxuj0MnwitMTcEu0m8XRa5aCtajyarRHJF4bAER2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDH4fIRBsbrxFV4E9qOcyePVwfcq1Ic7MpttJCRInEQuB9u3kTOrEl7Ax6OvTY75P
	 56W6MbVdlRiQMTLynn9N2QK1gKicdbEXuQveYf2hrBRIieK+oBHS3oO4hsQ66t2GMa
	 19eML3kNoVjrDTES871n9+gT/F71vz7Kxar/awno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 195/270] PCI: Fix old_size lower bound in calculate_iosize() too
Date: Mon,  2 Jun 2025 15:48:00 +0200
Message-ID: <20250602134315.169357124@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ff61f380de5652e723168341480cc7adf1dd6213 ]

Commit 903534fa7d30 ("PCI: Fix resource double counting on remove &
rescan") fixed double counting of mem resources because of old_size being
applied too early.

Fix a similar counting bug on the io resource side.

Link: https://lore.kernel.org/r/20241216175632.4175-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index a159bfdfa2512..04c3ae8efc0f8 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -806,11 +806,9 @@ static resource_size_t calculate_iosize(resource_size_t size,
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
 	size = size + size1;
-	if (size < old_size)
-		size = old_size;
 
-	size = ALIGN(max(size, add_size) + children_add_size, align);
-	return size;
+	size = max(size, add_size) + children_add_size;
+	return ALIGN(max(size, old_size), align);
 }
 
 static resource_size_t calculate_memsize(resource_size_t size,
-- 
2.39.5



