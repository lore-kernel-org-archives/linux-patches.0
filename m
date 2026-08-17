Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF60443E22;
	Mon, 17 Aug 2026 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980298; cv=none; b=D3Rnz0t0sEMXwVP/Ki2YgQNmH28hmJ8VptJyp1ub0Ae4NnGNxP3seTfNF3AW8oiCmNPF0rs8g4CiPRksP5VLfCHOzKMgfgPBCshbt5gjEK+pWj4RupAaCBeNI8jIXKLHCJXPVyhNN5M8kfAR6Vf7MP/xj/aq4vgo6Iq7/UHoLc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980298; c=relaxed/simple;
	bh=sP9IZjG1xWMbT7LpaMetYGX/oNujRH+VH6ap2b+Q9II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ffero8/thJU7WEcGWSKqt32CrZnskXa2IrAw0t+qd0XapKRCbG8Y02NETBeIHhiMJ1eLiz09OPpmgwWlQwTs2d5mCFv0aTJ8Ac5zhyQH52a1vv9i1gr2xxbZ1pmRB2BBHC9NuwvhtdXrvS6J01abOm3hFKbRuXLL3mlN61jGOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSQslLkB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSQslLkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641021F000E9;
	Mon, 17 Aug 2026 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980296;
	bh=cLUPQKTHGtrPp1XV/8AqVyGdrW7dKmco93kPHTFM6BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSQslLkBqnxrzIblazPEV+b87OLm7J7/OEUl2Vq21LeVK3vhYQIql3LLQttDgf+bM
	 QeecaOfuNwmspL7f0w9PIIjgrcEPKsHAIo3ig8BLq1vCj+VWQpqjQJEoLKOcTx54mb
	 qBIqURmQWqDWqzbMMRXjWXPMh8OSeAT/Ce2xPXoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 523/609] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:33:39 +0200
Message-ID: <20260817132601.320639497@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a37dbbda8de39..bc6af7b4909d9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -673,6 +673,9 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	if (fw->bin->size < sizeof(*hdr))
+		return -EINVAL;
+
 	hdr = (struct prestera_fw_header *)fw->bin->data;
 
 	magic = be32_to_cpu(hdr->magic_number);
-- 
2.53.0



