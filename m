Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE83815C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301D7C433D6;
	Mon,  5 Dec 2022 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268032;
	bh=534c8bjAzEJ5BXzmcRCxuJ8Z/e8WaA3l5cy410r9NC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCxCgzeW+T29qshrY4ND3R3UhmHYj3MFOGPH8NNgZMz23NpUvCkD99SPGI2JWtT3r
	 NbD52xpd2KzwxjaraH79OkGdxC2EYVuBnCgGQwZbW9QpKTxmXfkEwwJgf/RpqFp1lx
	 VhBKOoUkP+RTVi1E1LmLFWQ71uUld8GlF3Amw7Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 033/105] net: thunderx: Fix the ACPI memory leak
Date: Mon,  5 Dec 2022 20:09:05 +0100
Message-Id: <20221205190804.260925904@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 661e5ebbafd26d9d2e3c749f5cf591e55c7364f5 ]

The ACPI buffer memory (string.pointer) should be freed as the buffer is
not used after returning from bgx_acpi_match_id(), free it to prevent
memory leak.

Fixes: 46b903a01c05 ("net, thunder, bgx: Add support to get MAC address from ACPI.")
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Link: https://lore.kernel.org/r/20221123082237.1220521-1-liaoyu15@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
index e5fc89813852..3cde9a2a0ab7 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1447,8 +1447,10 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
 		return AE_OK;
 	}
 
-	if (strncmp(string.pointer, bgx_sel, 4))
+	if (strncmp(string.pointer, bgx_sel, 4)) {
+		kfree(string.pointer);
 		return AE_OK;
+	}
 
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 			    bgx_acpi_register_phy, NULL, bgx, NULL);
-- 
2.35.1



