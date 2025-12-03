Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1801A2FB0B4;
	Wed,  3 Dec 2025 16:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778039; cv=none; b=flD4HRpNn8uoZwy63/MUyl+a1fQqvzinUvIKnJ3wmhP+5KS9iVqO6ZRXY5zYbhaoVMeUKKYvYwSkRgq7QxkwA14AFo4uXp79wl6OR8cWPgeXOCDoGUy5rjYEncEOis7Fe3UlWopZ5pMmJrsZ+OA7BlNWcrfdoPtZlFLU7fxKxj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778039; c=relaxed/simple;
	bh=n/ZF8dizxMo98xJ2qORPfefAFQRqVmgcMz7OVJfTsWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzLD4vvlJ/OVIQ+Udt0srzoiSWITZXsHtEB4jmeOgXRMEqxQ5MP4LDDM+qjhXoXepYVCRHx6fgHEccZve9ipN57rkh5nH7RbjztUhLBRoIrCaVd5Ysm0mFBGHggkPuqQaVmPUS7EAh2rE32hr7RlPiGEy4PBjVUmjq2o3d5pozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUgb/Kqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUgb/Kqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86084C4CEF5;
	Wed,  3 Dec 2025 16:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778038;
	bh=n/ZF8dizxMo98xJ2qORPfefAFQRqVmgcMz7OVJfTsWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUgb/KqbS3jmtiG1BEqMqJUSQQMUvcL/C0WmagPKZVKuFyJYS73379vrgQBAhzt3G
	 wQ2lTHmoGLFC5WZ4JgrVUlHk7HYQoc3cWgubY9CP+sDmzKajqTxx6u4xkY72IJEBVn
	 Hfz3f/8eFPH82QmS6OI7Ku8OxWkuxqFgVCz4hiEM=
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
Subject: [PATCH 5.15 224/392] bnxt_en: Fix a possible memory leak in bnxt_ptp_init
Date: Wed,  3 Dec 2025 16:26:14 +0100
Message-ID: <20251203152422.427823815@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
index 67717274f6b9e..328ae267eba5c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -755,9 +755,9 @@ static void bnxt_ptp_free(struct bnxt *bp)
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



