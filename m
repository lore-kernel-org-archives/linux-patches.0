Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2202335CBDD;
	Tue, 16 Dec 2025 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886805; cv=none; b=piVRlAjKuQ2loo9jfQlcoC9PokOe79r1eXCJRja1WjgxjErQZYCwnH/cD06M4vt4ys4e8CcYH+syqWiYlUHAK4OZ4PLZLmsbYUFCHEfxTldETQO4EjWh2jecLIe+FquUB8exdZai5CE9MhaFlYdXfg6qufGp7iHsSERpc5/Wakk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886805; c=relaxed/simple;
	bh=Y7IgVZv2+GMiLX98MR5Yqc3DxoHBR2t6QJ8Sz7oRGUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbPI91H3J4kBpdzjtYPxODFZlELgUdoX5DizDkF2bSzWHLkq0JUj6rSRzF8mH261sQCOHnfHishxkENwW2gtBX7S0kmiebfbLdUod+XAu/ilKHr0kJVQweftVNsJJaMGOo8cKtFWUTcCpnvcFSIBVKx3g86/hZaJjgBivqr3uEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzUC441C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzUC441C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAFAC4CEF1;
	Tue, 16 Dec 2025 12:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886804;
	bh=Y7IgVZv2+GMiLX98MR5Yqc3DxoHBR2t6QJ8Sz7oRGUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzUC441CAMbG2V6HtTbgNRCLrBiUSGQFDxt6dvk37v/HuylPGaw1NmrBdljFOTnnV
	 Xnlu1fnUP9Hv6C27wwJQy5TaaAEm/+Pa2iVTf/Kgvi7+IBR2xV2aCZZtOD3TYYml1c
	 BgscZr/WS0koYHHZiWK7sGR6ZleNvrAwvnMzsYcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/614] gpu: nova-core: gsp: do not unwrap() SGEntry
Date: Tue, 16 Dec 2025 12:06:45 +0100
Message-ID: <20251216111402.688651672@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f7a33a67c50c92589b046e69b9075b7d28d31f87 ]

Don't use unwrap() to extract an Option<SGEntry>, instead handle the
error condition gracefully.

Fixes: a841614e607c ("gpu: nova-core: firmware: process and prepare the GSP firmware")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Message-ID: <20250926130623.61316-2-dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/firmware/gsp.rs | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/nova-core/firmware/gsp.rs b/drivers/gpu/nova-core/firmware/gsp.rs
index ca785860e1c82..6b0761460a57d 100644
--- a/drivers/gpu/nova-core/firmware/gsp.rs
+++ b/drivers/gpu/nova-core/firmware/gsp.rs
@@ -202,9 +202,10 @@ pub(crate) fn new<'a, 'b>(
                 let mut level0_data = kvec![0u8; GSP_PAGE_SIZE]?;
 
                 // Fill level 1 page entry.
-                let level1_entry = level1.iter().next().unwrap().dma_address();
-                let dst = &mut level0_data[..size_of_val(&level1_entry)];
-                dst.copy_from_slice(&level1_entry.to_le_bytes());
+                let level1_entry = level1.iter().next().ok_or(EINVAL)?;
+                let level1_entry_addr = level1_entry.dma_address();
+                let dst = &mut level0_data[..size_of_val(&level1_entry_addr)];
+                dst.copy_from_slice(&level1_entry_addr.to_le_bytes());
 
                 // Turn the level0 page table into a [`DmaObject`].
                 DmaObject::from_data(dev, &level0_data)?
-- 
2.51.0



