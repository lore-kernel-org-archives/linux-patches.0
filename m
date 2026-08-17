Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2293911DC;
	Mon, 17 Aug 2026 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977618; cv=none; b=h5H6lod/9B+VjwExAGSt+ioA2lrf579My4oQH6R38gNl2qKKyfyQxmMVQn0Wy/z2gP9MU9XficuHQHc3qv0YjAnQX3GQKNVeXWmVcP5+0XdMtcJ0RdNUppYB95mr2DPQ3/8TbS5XH1CzPSQnufkonS+PozZqfYq94476InfYpEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977618; c=relaxed/simple;
	bh=I5CBs4sWSHL9sIgpO+y2n2kr1+KFVnOk76GLf583H1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0E8ebEnwmOMNhR8fQ8bLq8uiS9eP4actqhebmpcRPuXPX6He7Y/THnFsbCzLAf9nq869LgIRoMcWwDwepQgYwExnDhchAZGwsp4SjTpMhZqGkO6s+NsfzPlRbiZqdsB2KbWa2Dvnb9HiaOyNoCuQ+5MfU9wx6YMZOCUVxdwSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYweqSDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYweqSDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8786E1F000E9;
	Mon, 17 Aug 2026 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977617;
	bh=dphsu5ypyw6MwxE9UJvgbcEfXiwyv10jTeWugkcoDbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYweqSDy1raU+TTzrnHNgFnJPLJqNHtt47OJz9Y1vzXA5RO1zl8rro16JL+t9OI3m
	 58TrzXec4Wa9rfMCbnoA+fcmYrDItdH8uIwBa0oWtFzMh95RpcmidyTQBqXha5pw7M
	 3ZExHrdyTUOUwJjfgcNQfAHFPwPnOmrXdj8q6XOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 390/456] net: prestera: validate firmware header length
Date: Mon, 17 Aug 2026 15:33:00 +0200
Message-ID: <20260817132554.672393666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6bef633aa6330..94bcae9020eb7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -616,6 +616,9 @@ static int prestera_fw_hdr_parse(struct prestera_fw *fw)
 	struct prestera_fw_header *hdr;
 	u32 magic;
 
+	if (fw->bin->size < sizeof(*hdr))
+		return -EINVAL;
+
 	hdr = (struct prestera_fw_header *)fw->bin->data;
 
 	magic = be32_to_cpu(hdr->magic_number);
-- 
2.53.0



