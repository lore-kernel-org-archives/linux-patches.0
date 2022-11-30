Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4679C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC18C433D7;
	Wed, 30 Nov 2022 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834171;
	bh=HR5+sZr4xA4YkHQdmDXf5ymm+/LJ1uPao7QRk0ICFcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5Y2Hsd5A9+CYvhn3Np6uEtYmdE/n1NUDlbT2WVbSYSMcHZeL0T5K1gaYc3FEW7+E
	 23alGQLnuUhPhopH7Nh56e7qo49X64PfRhZKgXqv/9IJFW7hT7NgM1DXb985j4PXYP
	 jn2kfC3//bqZZyZDrloj0wi4Flukk8U9QF63HM6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 156/289] net: thunderx: Fix the ACPI memory leak
Date: Wed, 30 Nov 2022 19:22:21 +0100
Message-Id: <20221130180547.671376433@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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
index 2f6484dc186a..7eb2ddbe9bad 100644
--- a/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
+++ b/drivers/net/ethernet/cavium/thunder/thunder_bgx.c
@@ -1436,8 +1436,10 @@ static acpi_status bgx_acpi_match_id(acpi_handle handle, u32 lvl,
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



