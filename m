Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAD934D38E;
	Tue, 11 Nov 2025 01:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825400; cv=none; b=kSsoaGn0p8Aks7bGkiSQCBoKVgEg3uXFbyrt4K0GhDr/aVJLdrc+DXV6V+BuqXhdmkjf59i54uSbddq4Dj4TwxWKI1d1dKhs8AoeikZPRKKIFrQLOjlDKiOctdRPSzoRhnshsOtSDyFjC1SlU10q8OPcL1UhRjmiu8ITOAbzbTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825400; c=relaxed/simple;
	bh=c4EGxsRY3YOQ0nA8nQCBs9KQvK57HLNxCu1FYggAAJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heS0QiaL2MFveO7WsT824fXS5hUld4NcJ6WGRprgd3cYYE0IosMCtQkAad3rPJ69M5/Q+9/GvuEjC3QrDJCta+5+b4iXAuBqyk+L0dSk3QMPuSCv8tk8ff2IEjCNUciqlbsfbcMrrlzKRxPfK9U+dWhCto2jRjTxnYaQMAWPQ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9jNKjjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9jNKjjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D89C19424;
	Tue, 11 Nov 2025 01:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825400;
	bh=c4EGxsRY3YOQ0nA8nQCBs9KQvK57HLNxCu1FYggAAJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9jNKjjyRZXgvJlwkLU22XpSYFvvmCWwKro6BjKs+rUaXluUzSogRAP9kw+igyNYv
	 k1L611NnbX8rhXljFdpSZvbQD0tE2ysoOyqTYzfeXZmtU8dH8icoZoB4IDF7KrFnjo
	 7MFC7txJipYmLS2mqdUmSPusaoK1lkGbxH+4YFLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Shantiprasad Shettar <shantiprasad.shettar@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 785/849] bnxt_en: Fix warning in bnxt_dl_reload_down()
Date: Tue, 11 Nov 2025 09:45:55 +0900
Message-ID: <20251111004555.413101258@linuxfoundation.org>
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

From: Shantiprasad Shettar <shantiprasad.shettar@broadcom.com>

[ Upstream commit 5204943a4c6efc832993c0fa17dec275071eeccc ]

The existing code calls bnxt_cancel_reservations() after
bnxt_hwrm_func_drv_unrgtr() in bnxt_dl_reload_down().
bnxt_cancel_reservations() calls the FW and it will always fail since
the driver has already unregistered, triggering this warning:

bnxt_en 0000:0a:00.0 ens2np0: resc_qcaps failed

Fix it by calling bnxt_clear_reservations() which will skip the
unnecessary FW call since we have unregistered.

Fixes: 228ea8c187d8 ("bnxt_en: implement devlink dev reload driver_reinit")
Reviewed-by: Mohammad Shuab Siddique <mohammad-shuab.siddique@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Shantiprasad Shettar <shantiprasad.shettar@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-6-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a97753c618de..b213ef75c5d17 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12428,7 +12428,7 @@ static int bnxt_try_recover_fw(struct bnxt *bp)
 	return -ENODEV;
 }
 
-static void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset)
+void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset)
 {
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 6b751eb29c2d4..2e96e7fd74914 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2930,6 +2930,7 @@ void bnxt_report_link(struct bnxt *bp);
 int bnxt_update_link(struct bnxt *bp, bool chng_link_state);
 int bnxt_hwrm_set_pause(struct bnxt *);
 int bnxt_hwrm_set_link_setting(struct bnxt *, bool, bool);
+void bnxt_clear_reservations(struct bnxt *bp, bool fw_reset);
 int bnxt_cancel_reservations(struct bnxt *bp, bool fw_reset);
 int bnxt_hwrm_alloc_wol_fltr(struct bnxt *bp);
 int bnxt_hwrm_free_wol_fltr(struct bnxt *bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 4c4581b0342e8..3c540c63c7949 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -467,7 +467,7 @@ static int bnxt_dl_reload_down(struct devlink *dl, bool netns_change,
 			rtnl_unlock();
 			break;
 		}
-		bnxt_cancel_reservations(bp, false);
+		bnxt_clear_reservations(bp, false);
 		bnxt_free_ctx_mem(bp, false);
 		break;
 	}
-- 
2.51.0



