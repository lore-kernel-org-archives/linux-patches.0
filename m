Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAB11FF5EC;
	Wed,  7 May 2025 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643704; cv=none; b=SR/vpBQxoTbjU0zwr/cvXRFwb1F/v6vTgATOJxDVhHI6HN0QmldZVnXyxI8bHQBXH+/uer20JeZje8Wyxq4m5mVmqv8mMQmuOd7ggEvhUxohJSsXxl592tdRsllo3SH1WfBlY7C1WHpVgdMjqbqA9poB1Tge8oRItY+eVPJaM+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643704; c=relaxed/simple;
	bh=1ZV/7Yqw6G/3gnKCjvKn4HqZqg/SLPnGQr6FleXNAHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHRQm6eX+MRfv9Q8IrUubUSrhvKlHRkAJcFfr/yL87Yay4PZACL8qwaTs4yN1HD1ftWDpxQZrV5nudSjnaxz4rzfmkLobD9T+3D5USoC1dzUlliw0oBMvo8FbOqbfE2o0X2MCdG6KqQ2he8AK3WrX6Z0TQct2hh2hSsM853HxjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM5tX4Fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM5tX4Fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4BBC4CEE2;
	Wed,  7 May 2025 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643704;
	bh=1ZV/7Yqw6G/3gnKCjvKn4HqZqg/SLPnGQr6FleXNAHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM5tX4Fbj9JR4G38mjB3hZFIu5o5F0zva8UJcMjG/ceE/swkp512HHVLRK3GIg5jb
	 VpsQYkWlzWBQ3aCpxwvTwCZi91xukd9nuMh8zQbwly2YEnKdTwjJprysf0Yv3KEOzp
	 QEGZ+ZKt4D3CM2Wm2RPPhoCyS3RvYva0/Zs7dEjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 58/97] bnxt_en: Fix coredump logic to free allocated buffer
Date: Wed,  7 May 2025 20:39:33 +0200
Message-ID: <20250507183809.335116846@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit ea9376cf68230e05492f22ca45d329f16e262c7b ]

When handling HWRM_DBG_COREDUMP_LIST FW command in
bnxt_hwrm_dbg_dma_data(), the allocated buffer info->dest_buf is
not freed in the error path.  In the normal path, info->dest_buf
is assigned to coredump->data and it will eventually be freed after
the coredump is collected.

Free info->dest_buf immediately inside bnxt_hwrm_dbg_dma_data() in
the error path.

Fixes: c74751f4c392 ("bnxt_en: Return error if FW returns more data than dump length")
Reported-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index c067898820360..b57d2a25ae276 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -72,6 +72,11 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 				memcpy(info->dest_buf + off, dma_buf, len);
 			} else {
 				rc = -ENOBUFS;
+				if (cmn_req->req_type ==
+				    cpu_to_le16(HWRM_DBG_COREDUMP_LIST)) {
+					kfree(info->dest_buf);
+					info->dest_buf = NULL;
+				}
 				break;
 			}
 		}
-- 
2.39.5



