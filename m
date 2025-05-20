Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74002459F5;
	Tue, 20 May 2025 13:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749272; cv=none; b=T2ByhVqxKBtoBS51xD2lrRTOVmKpkSOV1lQZyETdmuYvYR7rJspoNX27Dln16Ni86dPXD9vee/gzJodv/IN5XPL65Zsn+AoxzhULOoLdix47oGW6gmaoomcPv4oOn6gMoydgsjO0k+S1lSXZMGCbn3I7MFDeHUzzxBlWlOo4tWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749272; c=relaxed/simple;
	bh=JvWetSzpPtWmWyXUKCoOISFpaBM96cnpP3zbQnisvFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAaW8hgceVEmqYBwoROoSTQX7gRtWn06tlHDKKv42mWTwF9yuIK1VT7HneP0PLKeGd4rF5/kOOkHRCZbhl6SNKgdHbyfTszM1gtqbR/TQwXEQ2n1AbponTVmi0Fd+/7yMiLDCqvSmdgE/MiIk7zvRfuC58reNiewu8OZRnhHNjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDZz1Jq7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDZz1Jq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58812C4AF0B;
	Tue, 20 May 2025 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749272;
	bh=JvWetSzpPtWmWyXUKCoOISFpaBM96cnpP3zbQnisvFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDZz1Jq7gFvaDtJEmZvEEa8CCoS1uece87lU1sfpgyBq/gH7ICKIvzSbJpGfK5t4m
	 cqZFTmxWWkkU8dQYhrexPcNEZgjp4ogGyv4jjTq5EFQi1pVaYstIU/6zP2dtwz/45b
	 GR1qTzZVAuVPA8uw9bpL4v3ugiLuy7PgYzLA42us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.15 50/59] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Tue, 20 May 2025 15:50:41 +0200
Message-ID: <20250520125755.836271179@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit e56aac6e5a25630645607b6856d4b2a17b2311a5 upstream.

The "command" variable can be controlled by the user via debugfs.  The
worry is that if con_index is zero then "&uc->ucsi->connector[con_index
- 1]" would be an array underflow.

Fixes: 170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/c69ef0b3-61b0-4dde-98dd-97b97f81d912@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ The function ucsi_ccg_sync_write() is renamed to ucsi_ccg_sync_control()
  in commit 13f2ec3115c8 ("usb: typec: ucsi:simplify command sending API").
  Apply this patch to ucsi_ccg_sync_write() in 6.1.y accordingly. ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -573,6 +573,10 @@ static int ucsi_ccg_sync_write(struct uc
 		    uc->has_multiple_dp) {
 			con_index = (uc->last_cmd_sent >> 16) &
 				    UCSI_CMD_CONNECTOR_MASK;
+			if (con_index == 0) {
+				ret = -EINVAL;
+				goto unlock;
+			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
 		}
@@ -588,6 +592,7 @@ static int ucsi_ccg_sync_write(struct uc
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
 	pm_runtime_put_sync(uc->dev);
+unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


