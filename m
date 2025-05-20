Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAC21922ED;
	Tue, 20 May 2025 13:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749537; cv=none; b=YEOcVcMdx9Mslg1wnCPydSbCD8P0xBM+oM8DbInJ06mEWa9PX29iMmjU7B0UPA5NtfncMcLX67V52GkmnYrjM6TdOJVGwhChTURba+huDVj3RWdfP1LCrM9uEyN8r1hWU9dxx1j/sNdGvgECuZ4uB1KzvRqlCrc9b4L5LQ1u+Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749537; c=relaxed/simple;
	bh=hc1KPoNR3Bm/clZQmt7JkjJvl2OUvoza2/nHFKk6gF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pq5UC9/8N5LTtsSGf5SSjjAYwUGhmw3hcew1vZoyKZEq6iI6pTkgk2m87QFZL7K5d79uhQIwl82qg/5uU7WYK6TlSkD6rJX142aSrcYctRUglvYMuzxgoa+/x/cM5X5+O1N3ma+c2ibTUoQ5IZnvfFF1ptuTeFXP/jP6YL6W/Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7EKMhjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7EKMhjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42083C4CEE9;
	Tue, 20 May 2025 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749537;
	bh=hc1KPoNR3Bm/clZQmt7JkjJvl2OUvoza2/nHFKk6gF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7EKMhjqPa58BCEjjIDCBH7pUGaWFKVYj1pUVhF1rmaAUMupyW8CDPlI45+nZTLa1
	 +DRKY8GQ6ZE6BvSHGQ6uhY8btIl0PbeunSTEWbX8v8xAfuNQBQcW3bVDxIgQHhCmAy
	 ZTdJBJtwzvNMLnW+YqL0oKrCbMn4r5J6kpsRE6nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 77/97] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Tue, 20 May 2025 15:50:42 +0200
Message-ID: <20250520125803.662801373@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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
@@ -585,6 +585,10 @@ static int ucsi_ccg_sync_write(struct uc
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
@@ -600,6 +604,7 @@ static int ucsi_ccg_sync_write(struct uc
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
 	pm_runtime_put_sync(uc->dev);
+unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


