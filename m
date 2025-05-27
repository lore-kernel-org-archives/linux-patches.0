Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7211A3159;
	Tue, 27 May 2025 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367548; cv=none; b=lMgku9YBJcI0f+citNMZ+hxBzpETshRSP93Zyb6rkn+hOjJH5m3kmgob0+LLenCzHGoxb5gdkWs29wQo4WoWv2NuEIP6w+H2c0Z6rVix1hPi136e7NVSGqx2d5PJb4iyvZBlkzTJZa4Z+PWmKKazTATm3R6RdJEOC9lDKQ+bPTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367548; c=relaxed/simple;
	bh=v2ZtP0WU47Z73QogqJQEHzJKgLugrg+tIGqHvP/TrP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pUXIMwyv0qmUycQGzh3ZuInQ8P+sf9UKbHRXGL4QljD+ZmvnYsglfrNyb7XR7ijGTG2qIwyxT2LcQLPV9XIC80T4Oz81JfqX/HkY8Ymyh3hnTkb9fnFxX+Q+1qq9j53fpgKgmrxI8XWDm1S73Yyzwnuab5ye5IxpyeTrtSmWgVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rT/9zNmQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rT/9zNmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDE2C4CEE9;
	Tue, 27 May 2025 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367548;
	bh=v2ZtP0WU47Z73QogqJQEHzJKgLugrg+tIGqHvP/TrP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT/9zNmQerarfisRvQ94Bka1bDg1td7AnKzAm67sj42g3a8duJAe47mq4l2GVH1Mz
	 qyWh+36PJ9s3pkOwPLcDcbKNFXEtBoUrmff/sE2oD3kJISJsuWRh+U9SkUzWrrpF16
	 l5F5jA9sYKR0b+8v6El7jPYL4jp4vxkd0tPebAUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 423/783] PCI: Fix old_size lower bound in calculate_iosize() too
Date: Tue, 27 May 2025 18:23:40 +0200
Message-ID: <20250527162530.349980229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8707c5b08cf34..477eb07bfbca9 100644
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



