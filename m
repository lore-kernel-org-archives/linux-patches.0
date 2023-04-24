Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4DB7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01659C433D2;
	Mon, 24 Apr 2023 13:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342460;
	bh=tQmjXt9Cc7Z6kWHWMyjev3Vj4rxIBivhPAu7q7T9ULg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u6bzfw4sSyjedozMrXPfgLeGv0ydgIDr0u1qgl1AltPSFQlCDkstNaOI7sQV/o1tT
	 /R0N8e0iDwmf1bYSsBWma7EyEiY4dMtmzqjS/F/MJHIiZnsgTXct4N5DN9UAiMU/7x
	 8srl6A63YF9IJkZlWy0/O2kP66F2w7Fs2KD9TUuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Natalia Petrova <n.petrova@fintech.ru>
Subject: [PATCH 5.15 18/73] mlxfw: fix null-ptr-deref in mlxfw_mfa2_tlv_next()
Date: Mon, 24 Apr 2023 15:16:32 +0200
Message-Id: <20230424131129.685645314@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit c0e73276f0fcbbd3d4736ba975d7dc7a48791b0c ]

Function mlxfw_mfa2_tlv_multi_get() returns NULL if 'tlv' in
question does not pass checks in mlxfw_mfa2_tlv_payload_get(). This
behaviour may lead to NULL pointer dereference in 'multi->total_len'.
Fix this issue by testing mlxfw_mfa2_tlv_multi_get()'s return value
against NULL.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash process")
Co-developed-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20230417120718.52325-1-n.zhandarovich@fintech.ru
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
index 017d68f1e1232..972c571b41587 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_tlv_multi.c
@@ -31,6 +31,8 @@ mlxfw_mfa2_tlv_next(const struct mlxfw_mfa2_file *mfa2_file,
 
 	if (tlv->type == MLXFW_MFA2_TLV_MULTI_PART) {
 		multi = mlxfw_mfa2_tlv_multi_get(mfa2_file, tlv);
+		if (!multi)
+			return NULL;
 		tlv_len = NLA_ALIGN(tlv_len + be16_to_cpu(multi->total_len));
 	}
 
-- 
2.39.2



