Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301CF3E3C4F;
	Mon, 17 Aug 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974907; cv=none; b=CQfMLW2t7asLOETiTYTQYGNqq1KIvWM8iz3JAsYljwPq7v1/aftEnUYV1EWPw7SmXKircepaJ+OzqNV7bTQSXzCDiLXSOVkmg6ktow+B22qydYShfKv3HnxLJoKqRocp8hmpJzgkUdtywArp3/5aMZhy5OJ92hUSB16P9UWNu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974907; c=relaxed/simple;
	bh=G9iU8glyvtnzHgCODBivQA4IWrY4Yg2LByvsx6DAzjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TovsRe1Jvo+caTLP0aXMlliQTtNjwnAg7UulOHdxt8nGYJjLS/A3KFdxJVIO+W+8CLs4w+MbxF9ICGpUXCgSwkZbXiX2VMfF5vBMoOMG9kTM8q0zNR3JCPkX02AneKcqwWhw0vc3lkof7TJvrfbqbklcwUJjQXgTuQHQgI6UFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1w9kPUmQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1w9kPUmQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461281F00A3D;
	Mon, 17 Aug 2026 13:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974903;
	bh=b52Kak7Y1CbY3x0heaXZrq0MheC+U+e1/dlIzgX9lIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1w9kPUmQ4wvV5/MKcbWlL7rmKP3wmduyIOiH9OxGakzQcCAPWNqyTjXaotKO2OeNT
	 O9U6xpu8g+qQEzFWEMOZjnDNgxcwCCQEMo4X3aD8NEIU1jAeLpAxyalQInmCwG7bVf
	 Ixywvj+xK3DkOUGQvbqzyMBsbdSX+S9Lm3Cb/W/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/250] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:30:55 +0200
Message-ID: <20260817132540.342240359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 3e13322470da6..bacc869551dfd 100644
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



