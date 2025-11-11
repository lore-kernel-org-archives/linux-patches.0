Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E3226B76A;
	Tue, 11 Nov 2025 01:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825391; cv=none; b=Bi7YBhFKEU7Uj5gY3sWxbMJxnwJzP58m18oRi6/ola+dxDtLJsf9Sx7lOMPcVWiXS/HwIWUTmqAJk2Jhx44qLSBiJZs/wDfMDRGln6nc2yPVTO/GzqHjnsg48ozDpeMaGScQcdVHxqXGeZ1gdI6WVyf/UOnQV7yErW1sBZa1QKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825391; c=relaxed/simple;
	bh=QQmVr82XLPwT7ZnPN43oBKBVwE4ox55ZkhuXXZmJ6/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D27Pz9B6yA0slTitaX26n2VZ1+MIhv9FQtcSForsikai0fzjFDwKP7HMtq1ZUIqYKY7EY7/xi64LoWFmQR+Zqlr6KGJgbrP8OFa9ApIxl0JSVUqw1SA5Xg2rAbPBvoMofEqTd5E9B82JbAx5FWbBDFBu4ETufh7XzO0Hm2w6PLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frpkgjWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frpkgjWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD04BC4CEFB;
	Tue, 11 Nov 2025 01:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825391;
	bh=QQmVr82XLPwT7ZnPN43oBKBVwE4ox55ZkhuXXZmJ6/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frpkgjWQNEx2p7veF/TxjJqaonjNt3TmC/jHcJMqPsvxDLAMA9onsiXt++i1lLU5+
	 0z5oMW4w4ktImj7jMb8t+EJPjpQfHUOURrVfGkwID4IfH9DBUaZoG8yFdupk17+DL7
	 sgnIvNhAz4a81higIm3FmuJTn7OMW28fw1OoF1+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 782/849] bnxt_en: Fix a possible memory leak in bnxt_ptp_init
Date: Tue, 11 Nov 2025 09:45:52 +0900
Message-ID: <20251111004555.333954796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit deb8eb39164382f1f67ef8e8af9176baf5e10f2d ]

In bnxt_ptp_init(), when ptp_clock_register() fails, the driver is
not freeing the memory allocated for ptp_info->pin_config.  Fix it
to unconditionally free ptp_info->pin_config in bnxt_ptp_free().

Fixes: caf3eedbcd8d ("bnxt_en: 1PPS support for 5750X family chips")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index ca660e6d28a4c..8f2faff044591 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -1054,9 +1054,9 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	if (ptp->ptp_clock) {
 		ptp_clock_unregister(ptp->ptp_clock);
 		ptp->ptp_clock = NULL;
-		kfree(ptp->ptp_info.pin_config);
-		ptp->ptp_info.pin_config = NULL;
 	}
+	kfree(ptp->ptp_info.pin_config);
+	ptp->ptp_info.pin_config = NULL;
 }
 
 int bnxt_ptp_init(struct bnxt *bp)
-- 
2.51.0



