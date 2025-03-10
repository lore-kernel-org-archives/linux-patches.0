Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5B722FACA;
	Mon, 10 Mar 2025 17:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626963; cv=none; b=I/ibAJNHk3EnB1ZdxAfBR7u7ye/pgk83hn4VvjR1vUiAbagfk7a6niIbvHigr1rzBwfUNrvtYZnLNCoBLd2kgb/nhDv9LT1a4noaQ9DrrXpfEeZtPJMN+Z1X/1nVstXc3O77vkxARri84yb3rxkAlvCY9vHo/ZEZXJdVhcRUsbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626963; c=relaxed/simple;
	bh=0FJ0QdwVhLm6E5QBu/Wf6lY4KIxmZUxYPnXZQTzEx2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uk7nctMCb5dBWcA4jX+9eIRxoFNBZp5OFb3AyY8AF5cHBFfvMejXnNhs4fU5tCOqExnEJgoYLZ/F8i52HwrlQ9jfdUuw44KMysm1xy6XIYwxebOSxeknbXWsPUoAwAsLd5ODVCa+X75H87JnKdtFJtmQ4YgWmciWyxkbf3Qty+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdDfcFrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdDfcFrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB958C4CEE5;
	Mon, 10 Mar 2025 17:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626963;
	bh=0FJ0QdwVhLm6E5QBu/Wf6lY4KIxmZUxYPnXZQTzEx2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdDfcFrADtHIP+ffHNoqDD2uwbB23MNiDW8Vr1Jb0jlBvVrZFCiC/FuLfD8THU/H4
	 PZzdKAuZ6ad+AgH7mFHInpUu8bXBeRxhKDKkZOcqLkKm9/KrBojRq410wnAJCU1PkG
	 N5ZxYR7WfG0mozj5sh6UAbUPfIf9myp6XyO+1Hp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 142/207] ublk: set_params: properly check if parameters can be applied
Date: Mon, 10 Mar 2025 18:05:35 +0100
Message-ID: <20250310170453.445751980@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 5ac60242b0173be83709603ebaf27a473f16c4e4 ]

The parameters set by the set_params call are only applied to the block
device in the start_dev call. So if a device has already been started, a
subsequently issued set_params on that device will not have the desired
effect, and should return an error. There is an existing check for this
- set_params fails on devices in the LIVE state. But this check is not
sufficient to cover the recovery case. In this case, the device will be
in the QUIESCED or FAIL_IO states, so set_params will succeed. But this
success is misleading, because the parameters will not be applied, since
the device has already been started (by a previous ublk server). The bit
UB_STATE_USED is set on completion of the start_dev; use it to detect
and fail set_params commands which arrive too late to be applied (after
start_dev).

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Fixes: 0aa73170eba5 ("ublk_drv: add SET_PARAMS/GET_PARAMS control command")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250304-set_params-v1-1-17b5e0887606@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 934ab9332c80a..d9e8bf9f5e5a8 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2716,9 +2716,12 @@ static int ublk_ctrl_set_params(struct ublk_device *ub,
 	if (ph.len > sizeof(struct ublk_params))
 		ph.len = sizeof(struct ublk_params);
 
-	/* parameters can only be changed when device isn't live */
 	mutex_lock(&ub->mutex);
-	if (ub->dev_info.state == UBLK_S_DEV_LIVE) {
+	if (test_bit(UB_STATE_USED, &ub->state)) {
+		/*
+		 * Parameters can only be changed when device hasn't
+		 * been started yet
+		 */
 		ret = -EACCES;
 	} else if (copy_from_user(&ub->params, argp, ph.len)) {
 		ret = -EFAULT;
-- 
2.39.5



