Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E554781;
	Mon, 17 Aug 2026 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976317; cv=none; b=E/eLw/ZWTDXEIBkqvxGXAwmSXsNVbtaSZ9gA1omFq2IfdeG6ePdubdbjI8Ch7P48aZ7crcCFP7pRFvxdVFDiynuI6X+Ggq/j9nuWq1TFKZiZkCrFtMOTe/l1WHjPRIsidq5Sx10dc61dCaRyBwC6o+PlBbvfTi3y/+j0L7AlZ30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976317; c=relaxed/simple;
	bh=fYIF+tNh+qvQ/pORgS1J5pXfjhK2PzogpASF+gZNDmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gul4RmBhCCyHBL1O29D7pWRQjI6zTjSQwZAqGjovCJhHwyyN21LzslSxJqaxiXovsFEdq+7i2dXop08Cu58a/DpHDk+onmuk2R2Ln4Q5rzX0OkN2y4CtxoWdE1YEaWDQO0fSLLv/oZEfde4/mzYunM/tmlaJ3+SsUyajZnA3eqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9XMtvyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9XMtvyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC471F000E9;
	Mon, 17 Aug 2026 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976316;
	bh=rihziY7FHLx4djRkPnSkJb5I6Qgmk4EGMBI8sCv0wUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9XMtvypeQ9UYfSRbS6EvlozG3UlMoz8b04FRfbTWq3ThIH8g7lMy6qcWeiz1Mp6y
	 XkZEQdEV4f1yu/fJFmd411udL/n3I6DeP2D9BzrtpGgG1D4kFZBUDIiVeRu1WxeDSs
	 kyM8VJIQ1FMJzfWMWuH0Run+Wk2xKoAmRVgsuIio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 332/389] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:32:51 +0200
Message-ID: <20260817132551.833250461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 39cd3d5010147..bdc57f4245930 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -597,6 +597,9 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	if (fw->bin->size < sizeof(*hdr))
+		return -EINVAL;
+
 	hdr = (struct prestera_fw_header *)fw->bin->data;
 
 	magic = be32_to_cpu(hdr->magic_number);
-- 
2.53.0



