Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400792C2AC8;
	Wed, 23 Apr 2025 15:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422509; cv=none; b=lU6GBN6rOG0ZJL37EfoaDiD9xQj4n+wrBXWvV+FIehY5L6PV5dNyrKaU/1MAkG84OQzIhyVUf/9KYE60oxG5ONxus10lsAqGa/KLI/c7oDZLvoXveRPqIpSGAUxcdTpzEH7pMz6cALZLRnMuklfDc0SzmiMf+w+S8SvxTVvn+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422509; c=relaxed/simple;
	bh=IDDgZwio+OwZ8EomMjwVD23tDj8xXQznlr7y8GnX0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k287fZDP9d8ZIEvxVVS0a2YhhK4A7utv44FfTm01ggGYWKB6QJ1NW8XsVTzJltDaI0dCCJ4Rje6QErjbilqbSFWAQz5gNNPAEyshgt+lDIW5WFzhsQulP3fhbshofSU5uF9ZwkBM6oEgImQSp7Qk0c45sn0Fga+U0mpsg/rdwAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCY24hjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCY24hjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D38C4CEE8;
	Wed, 23 Apr 2025 15:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422509;
	bh=IDDgZwio+OwZ8EomMjwVD23tDj8xXQznlr7y8GnX0Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCY24hjlALPq7q0QVXyeWrUg/EXdqVKCvAN9lHS9L1zZ73ynux3Plvb8F+LzO23sJ
	 wEZbLbc0YAKrRYdH6XD2fkJTgZMvT5pAVkk1AQeOWGVW+++5ulRS2GLWHRMD0dIIgx
	 KlosXDz5wEiqrHil90+ZBiVVSUuxsQaisUPYePJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 377/393] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Wed, 23 Apr 2025 16:44:33 +0200
Message-ID: <20250423142658.902670515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[Minor context change fixed.
 13f2ec3115c8 ("usb: typec: ucsi: simplify command sending API") rename
 ucsi_ccg_sync_write to ucsi_ccg_sync_control in v6.11, so this patch is
 applied in ucsi_ccg_sync_write in v6.6.]
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


