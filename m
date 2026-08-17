Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9582842900D;
	Mon, 17 Aug 2026 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977962; cv=none; b=ldpbnooLrjx8/f5eSDRlDjYfNrOVtGKv76gqTOCF2mfiTcJ/x+RHO6R88ONsBQo+0UVEpHzkSJNfLBSZllFzGkjF1k+OdTSlWLKAT/8ITKDJEYu0oK0ry/P5nZEhOb/LQRtoJH2rGIb/AyoA5lgPrVBQiuE3mK0jcej0+N2oAD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977962; c=relaxed/simple;
	bh=KPEwztGsmfJsKA+22skZ8QXtFyUWmhnmtiJnfpYvZg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QM6WIWQvWM1brKJFj2Jp2gIWiHBH7MuEyJW9RTxPiFqAfBNzItVSjCFxqlfFggWFi89r8AUzmFstv7NgZGwahf9RBjAA+m2qxxVFiVPSeQHF8znsNPX4w8BOyxnovQsQSBYJxbo9iu+9+OliSfNSe75c2iJWWNNj+BEx4nj5e5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTWjGj11; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTWjGj11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21461F000E9;
	Mon, 17 Aug 2026 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977961;
	bh=b0UULvdorF4fwKoFIQJeSwfeaolQ3d+zwbAZBYCR+ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTWjGj11TKig0yskFnIwv+0TsRE3ZwRvmwnqkyLmo2lFAbYFtDAlRQ6xwRqcNuUXs
	 qRWuBTgMPOYIybV6iTzN0C8Mx1BrnZskCAbTyYhGRSKzUPjJ8JKs6or1NHXfKLSWSW
	 EmLpyPAfD0QnWWkjINjnSzVAK5RoNgDQ7rKkul9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/181] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:32:28 +0200
Message-ID: <20260817132537.540908492@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8ae344eb540af3f457179b52bc6061416752485c ]

prestera_fw_hdr_parse() reads the firmware header before checking
that the firmware image contains that header.

Reject images shorter than struct prestera_fw_header before decoding the
magic and version fields.

Fixes: 4c2703dfd7fabb ("net: marvell: prestera: Add PCI interface support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Elad Nachman <enachman@marvell.com>
Link: https://patch.msgid.link/20260731141500.1-prestera-v2-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index 35857dc19542f..5db2c9e5e077d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -684,6 +684,9 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	if (fw->bin->size < sizeof(*hdr))
+		return -EINVAL;
+
 	hdr = (struct prestera_fw_header *)fw->bin->data;
 
 	magic = be32_to_cpu(hdr->magic_number);
-- 
2.53.0



