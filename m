Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE124337C;
	Tue, 20 May 2025 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749541; cv=none; b=XNEql6hl0lsstGstmiDrUcAY/nd/urvvsLbFz33PPF1NRAhI+kbIuZJbq7inknxLxvXJ0/5u5gX6IVO9kGQLe8skEeTL9RjZlC6xnVa2Ze/IQc+Hc8ckWASL/wHCpbtxgZ2ORd/nFqzli7lxBwGHoF1h+raKixN4HcVStljJvCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749541; c=relaxed/simple;
	bh=DK6CsknsaM7QDMkL56UbQpGrsN0qlJxzdWqJn1qSVOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cebmI3JEV2UCtazik3jCuuQTYSZLVX0HoT05sNqm2iWQY4Vo48eS74U+M68jfEaqRkkeRkTioQRo/ha7eMfulSSd1VEwqmq+LWIL6K6W4ovdjjgLkV00UJW+C7Nxh8mUXFGO3u0M60SQJ1ZN5X2LtOqi1e25j9fAI3J+UdzsNRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayAIqALo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayAIqALo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DD5C4CEEB;
	Tue, 20 May 2025 13:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749541;
	bh=DK6CsknsaM7QDMkL56UbQpGrsN0qlJxzdWqJn1qSVOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayAIqALoolagroVRxP8+I6AtKdWlEMxDi+Zm31P2PM4dwDjE+39TzaQRlcR3uvWas
	 /Rj9iPCqEyh/Snf+JuqH9pe/OukXVGDpcJJNuljrZsA2pWD9vBZQPHfsb+GyaemWwj
	 pfKIEO6pEdOsnyi1jERc1v+TcA+Rv405Yh8Ezf3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	GONG Ruiqi <gongruiqi1@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.1 78/97] usb: typec: fix pm usage counter imbalance in ucsi_ccg_sync_control()
Date: Tue, 20 May 2025 15:50:43 +0200
Message-ID: <20250520125803.699722820@linuxfoundation.org>
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

From: GONG Ruiqi <gongruiqi1@huawei.com>

commit b0e525d7a22ea350e75e2aec22e47fcfafa4cacd upstream.

The error handling for the case `con_index == 0` should involve dropping
the pm usage counter, as ucsi_ccg_sync_control() gets it at the
beginning. Fix it.

Cc: stable <stable@kernel.org>
Fixes: e56aac6e5a25 ("usb: typec: fix potential array underflow in ucsi_ccg_sync_control()")
Signed-off-by: GONG Ruiqi <gongruiqi1@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250107015750.2778646-1-gongruiqi1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Minor context change fixed.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -587,7 +587,7 @@ static int ucsi_ccg_sync_write(struct uc
 				    UCSI_CMD_CONNECTOR_MASK;
 			if (con_index == 0) {
 				ret = -EINVAL;
-				goto unlock;
+				goto err_put;
 			}
 			con = &uc->ucsi->connector[con_index - 1];
 			ucsi_ccg_update_set_new_cam_cmd(uc, con, (u64 *)val);
@@ -603,8 +603,8 @@ static int ucsi_ccg_sync_write(struct uc
 
 err_clear_bit:
 	clear_bit(DEV_CMD_PENDING, &uc->flags);
+err_put:
 	pm_runtime_put_sync(uc->dev);
-unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;


