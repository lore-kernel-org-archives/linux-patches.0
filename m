Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5E181ADA;
	Tue,  3 Dec 2024 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242108; cv=none; b=XbWTbP3C4mvyLnr6ApyKWh1SqAEWEK/ZSmJY01eow5rWJvPZuriPckg/AvvbGlDQLq2XdRQ6k3jr1XjXtTOlsyDlAk6ln5cc9mlJJii2oJ3WuvL9ojRS4MaQoVCsTkq9P+sCx6IAlGlVPeufGl5/6qqWpXxZNK2Ph5F2IJNLjYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242108; c=relaxed/simple;
	bh=PxzuBh49hKmhMoyyB/9dkFMzQCKkk0Yt5GIYpjckSI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj8tuZBLjyCvEGJvUhUsbbiGABt+6rHqEhMtwCMeyvhaW7C1pmNFZmBVVAmNQsFiYxDV9dp3SleUCHgOc+0mj1zrAvap0K336Xa5uIxbC7fpTaZJqVcbZ6ok+nU0cYoIiehVo6cGp3DqsLDQl8mi9AuEcd0/w90m7POOhjD2WAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIOF2d/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIOF2d/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E746C4CECF;
	Tue,  3 Dec 2024 16:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242108;
	bh=PxzuBh49hKmhMoyyB/9dkFMzQCKkk0Yt5GIYpjckSI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIOF2d/bFaj1hYbW2XbetziLYb6bhKegOyMTHHoxFw/0y4CUDqavPeZmI7buc1LF5
	 gNHOp4p2lnMvSSJVVdgrd+ckatNwD2rKKJ2jpDWsq64HIrvNOHRqiU+tzIJLrp4q/o
	 VTwDWP86HvRZLiYTDuZog/p+D9lNtgfNtYYNaT8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 609/826] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Tue,  3 Dec 2024 15:45:36 +0100
Message-ID: <20241203144807.509830031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e56aac6e5a25630645607b6856d4b2a17b2311a5 ]

The "command" variable can be controlled by the user via debugfs.  The
worry is that if con_index is zero then "&uc->ucsi->connector[con_index
- 1]" would be an array underflow.

Fixes: 170a6726d0e2 ("usb: typec: ucsi: add support for separate DP altmode devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/c69ef0b3-61b0-4dde-98dd-97b97f81d912@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index bccfc03b5986d..fcb8e61136cfd 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -644,6 +644,10 @@ static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command)
 	    uc->has_multiple_dp) {
 		con_index = (uc->last_cmd_sent >> 16) &
 			UCSI_CMD_CONNECTOR_MASK;
+		if (con_index == 0) {
+			ret = -EINVAL;
+			goto unlock;
+		}
 		con = &uc->ucsi->connector[con_index - 1];
 		ucsi_ccg_update_set_new_cam_cmd(uc, con, &command);
 	}
@@ -651,6 +655,7 @@ static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command)
 	ret = ucsi_sync_control_common(ucsi, command);
 
 	pm_runtime_put_sync(uc->dev);
+unlock:
 	mutex_unlock(&uc->lock);
 
 	return ret;
-- 
2.43.0



