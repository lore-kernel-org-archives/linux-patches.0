Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F8426B099;
	Thu, 13 Feb 2025 15:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459269; cv=none; b=LcoiTYmP5WGBxkJkCaVSPCCn05g9riAfm/oItsW8rWGYRzz+tKZyeaIlwDBQJ/4UPTfgvs6DwlydTt6uY+rbx77vz/tfTwa/KMhf8DCIGTF0ccWNyHu7qpA0IDgKHhcz5piRIvaW2WrLhMLztLc6nWeZ0Z3YUBg6Tc44xPSL1L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459269; c=relaxed/simple;
	bh=dIoNV8H9p//v/GIvyLFyGREIPEedeNbiSlNRZoR9yWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcaibx8azU5VgsyiMSSpJzZregTHFJDk3c8ImE6yLD0e7cLS+Jw/ZovNZaksn/GF/fHyuMv55tYFPLP3USFIWNZdl3/7wAKk4ypVcSQ7yRvDIeOfjMuZuWBmr6M2TylsjvHiFfnICyz/OvT/nzr6BRxdN6A+6LZzMVZJITgwCJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5XeNlcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5XeNlcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4218DC4CED1;
	Thu, 13 Feb 2025 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459269;
	bh=dIoNV8H9p//v/GIvyLFyGREIPEedeNbiSlNRZoR9yWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5XeNlcpdkCNydovkByZ7xpngAhbZubyX5/ZrV4ofs0hfMvAzcCUwJc30oqG9X3vc
	 PmjogMLXyUcL+6+DbubS1+0FR6Zya9RjTk14h01Nq9RG3ME2SG4gY8XJTEZx5iK8Si
	 Dde5hKnQHGJjCENd6tDO/KSGOZLKBFEYJeRaxhRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basharath Hussain Khaja <basharath@couthit.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 216/443] of: address: Fix empty resource handling in __of_address_resource_bounds()
Date: Thu, 13 Feb 2025 15:26:21 +0100
Message-ID: <20250213142448.950447753@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 15e2f65f2ecfeb8e39315522e2b5cfdc5651fc10 upstream.

"resource->end" needs to always be equal to "resource->start + size - 1".
The previous version of the function did not perform the "- 1" in case
of an empty resource.

Also make sure to allow an empty resource at address 0.

Reported-by: Basharath Hussain Khaja <basharath@couthit.com>
Closes: https://lore.kernel.org/lkml/20250108140414.13530-1-basharath@couthit.com/
Fixes: 1a52a094c2f0 ("of: address: Unify resource bounds overflow checking")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250120-of-address-overflow-v1-1-dd68dbf47bce@linutronix.de
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/address.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -200,17 +200,15 @@ static u64 of_bus_pci_map(__be32 *addr,
 
 static int __of_address_resource_bounds(struct resource *r, u64 start, u64 size)
 {
-	u64 end = start;
-
 	if (overflows_type(start, r->start))
 		return -EOVERFLOW;
-	if (size && check_add_overflow(end, size - 1, &end))
-		return -EOVERFLOW;
-	if (overflows_type(end, r->end))
-		return -EOVERFLOW;
 
 	r->start = start;
-	r->end = end;
+
+	if (!size)
+		r->end = wrapping_sub(typeof(r->end), r->start, 1);
+	else if (size && check_add_overflow(r->start, size - 1, &r->end))
+		return -EOVERFLOW;
 
 	return 0;
 }


