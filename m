Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B521A238F;
	Mon, 17 Aug 2026 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974142; cv=none; b=AIUrgj3QxX4OR8+wGv0tMIn/ckpYe26Rre1G7xBKz62N+Xhd490xowXWNrZTD3/MRk2d071wbR8S4QUB0bDlx4ClpwwDwWZoVuqWgmpIPSjaFoFOtvZmjAFDZIiLVMGh1XnXmkAoFFev4+PYwX63CkpmZxCPPuezLiAR9XhS9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974142; c=relaxed/simple;
	bh=jkmejSc/td/35fO2YioCaIY1VQsp6w6qg/ZzhCzJGT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6RppnU/0xyEZzXaZsX4jzdiT/OwhaDfbBrPGrnSK8m7OZwsIEVmxSjFyF4dAwcl122BPF0/XrxUZO/wiueV2NpGc1YVS6RQSMRYgs95qxGWYYIMiqtzO+WEm/npwHofwOBL70yN2vPdP9knxaGZi6lwBkutqUL9MXfkwNyF9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xEjsa39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xEjsa39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C041F000E9;
	Mon, 17 Aug 2026 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974140;
	bh=VvR7kaWTqrLF+AbroV+AiesBTsO/iqzKOUcaOD25HWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1xEjsa39TlhlCGbErQI9ccipY5Y6TBpRUn7g+4Ac7YU6yYbjZ+ZKHso9whGgyLPNk
	 Q/f2jgGwJ+6iFvngcI7poRPMVahSFG6NI9YMHbigMnfr4VSpo9rebuE/W5U1dsDIlr
	 vuSneWaxH+FAIMrQFRNX6DA0H6lA/IWe3SmR2wGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 103/271] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:30:28 +0200
Message-ID: <20260817132541.062946853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2989a77e3b422..1ad0e62a8433b 100644
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



