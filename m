Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835971D432D;
	Tue, 27 May 2025 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365430; cv=none; b=BA/mP7kEhIkjBI9rn231cwjoh6oXxpePTgiR0UK8Yh+fn4xVgIZiStke6vUuMJTH9Nu+he74rCswSQnWdXZ2ovnK4Ma2c6JiLJ4L0AJz1KqW0Az9FXFM8NSy2y4BGtUiHGzfukYrq+Ma79Qnv/yQlzfqkMkq6PFFqDEB+XJ+mtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365430; c=relaxed/simple;
	bh=XH29Mh0cQzi9+ehVfPVTMEf+zWtr0PRBXg7kBoeT6Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FhtzgxqsHl7EBRdxKoIMyJRjVURjfmeEyOwJNrONOT33HqXTUQDjW+p5QVl4ZKZk7Vr8dfAOc5TM3GeTOjJa/8UoYeeyCsHzJHJH5131pG4w4s4OOjcZaNwmTdq+OkhGEWKbHT4uFBj2gLAzlSSb/6H30p77Txf1LmPsgehHKGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AU3IGbwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AU3IGbwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E9BC4CEE9;
	Tue, 27 May 2025 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365430;
	bh=XH29Mh0cQzi9+ehVfPVTMEf+zWtr0PRBXg7kBoeT6Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AU3IGbwH/r03xd8HA+GlC9B9XPcD6yTa91f+cG7msdPmdksL4+v9pZUASd8Kytbhn
	 X1+1uq/MyzX65Kb6/DJAdZ1I8WVtmY3EL+MlzCumWhGk4Gq3UJ5E8yRUzbvmqVsvQM
	 /V2iTw+xjJibcx0lbZA6DW/ddKueKxOl6hWpqrBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/626] PCI: Fix old_size lower bound in calculate_iosize() too
Date: Tue, 27 May 2025 18:23:59 +0200
Message-ID: <20250527162459.082452365@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f16c7ce3bf3fc..1eceabef9e84d 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -814,11 +814,9 @@ static resource_size_t calculate_iosize(resource_size_t size,
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



