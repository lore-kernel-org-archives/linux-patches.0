Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B61DE88F;
	Tue,  8 Oct 2024 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394090; cv=none; b=GlEkA4LpNrwmKIwIIXwfIxlvGird149zHxARvCR2jx/wACFi93rrG/QY6VI9Fg6XNpb9sLSfIRPG+RC6bJ0lJIWqVKZuxUHwKV8U10VicwZxKsZyJJTwcJxAd+2fpXpGhQwo4GBMWLnltbziDCuHb7mSEmGnmxUUhb9cClpJA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394090; c=relaxed/simple;
	bh=x0m+zElJd9CY696EFmmYq0VzQ4gphOgvdxNzfDg2dP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfZaJtovGQW/aBHzW+4kWtgXsfEPW0DwuSsiL9aAqBYdTrA5vxe1ugQhJXRN/EEEDYyT3eLLhM99h1IAg3qFWBkLcb70KxyY36925GG3eSfkDKYi+ODuVAvcOd4TwH7NWpkCj88iOnddIuuxgZDngHf3J992F9p0VS3DXTF393g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lez8TvlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lez8TvlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB256C4CECD;
	Tue,  8 Oct 2024 13:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394090;
	bh=x0m+zElJd9CY696EFmmYq0VzQ4gphOgvdxNzfDg2dP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lez8TvlG5ft255oqmxtYVBi+jql0OYRyJOj0eqdcF6QZqvKZ5csCDBo5msk6BIYDb
	 CwS6jdmUmJVjcIKOMMMWosY5R6SwESqLzLZ4hwmJt2SdDFOrpBJYDipx1xvjWNuTo4
	 GZwJ7+y0TJxXf/evi0nPqlkbti0mNNWdjJ8ufbSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 344/386] net: mana: Enable MANA driver on ARM64 with 4K page size
Date: Tue,  8 Oct 2024 14:09:49 +0200
Message-ID: <20241008115642.920578856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit 40a1d11fc670ac03c5dc2e5a9724b330e74f38b0 ]

Change the Kconfig dependency, so this driver can be built and run on ARM64
with 4K page size.
16/64K page sizes are not supported yet.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1715632141-8089-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9e517a8e9d9a ("RDMA/mana_ib: use the correct page table index based on hardware page size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/Kconfig b/drivers/net/ethernet/microsoft/Kconfig
index 01eb7445ead95..286f0d5697a16 100644
--- a/drivers/net/ethernet/microsoft/Kconfig
+++ b/drivers/net/ethernet/microsoft/Kconfig
@@ -17,7 +17,8 @@ if NET_VENDOR_MICROSOFT
 
 config MICROSOFT_MANA
 	tristate "Microsoft Azure Network Adapter (MANA) support"
-	depends on PCI_MSI && X86_64
+	depends on PCI_MSI
+	depends on X86_64 || (ARM64 && !CPU_BIG_ENDIAN && ARM64_4K_PAGES)
 	depends on PCI_HYPERV
 	select AUXILIARY_BUS
 	select PAGE_POOL
-- 
2.43.0



