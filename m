Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B581F472A;
	Tue,  3 Dec 2024 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239510; cv=none; b=rSZ30rB4uzIzF0kyTrygp47Lx/6hSKiaioKrJcA58wwLlyNitfDPEmRC2AUFA1PTmbWz52X4U2gHCdS30YqynC6GWzRL1dxlvbDdDPFLSgD0+/1BN7aOe/zr7AHP0oKhHzbG2K/QLhivZww+JIesMQqmx5jiymCnNHWgubAHGLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239510; c=relaxed/simple;
	bh=eGciI+ZMTTs+2HA7z+tD0sFJeyLmLtwP7vWWyyURaR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvcCntVPdhi51qMMMiH4cKWnm6YTpKum97p29VIuCUV56P5Tf7TOwvcd9WNYb4n+s2jNnB4gS2t3F6R8N42Mwv8G1BuBZvIYTCoVjK6XQyJJlJjJNlTqYtLYqVejZvE+Rqkkw5hNt1WXEJ7ECphYAFOjMhQcgtFEt1HZxM+zmos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTtdG3a/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTtdG3a/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A1BC4CECF;
	Tue,  3 Dec 2024 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239510;
	bh=eGciI+ZMTTs+2HA7z+tD0sFJeyLmLtwP7vWWyyURaR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTtdG3a/ZYaWQKU7zyhOi+YDNsL4aRZY7qpB97ZZBtAKZ6Spml+N/nhqDWi/bsh4J
	 bcuAVE/taRVvWO7lav6cHKhfVDYnY8aksXtHhSEyqmGzaFrOpYuOjWMMCV6uqaRCWC
	 D5yx6xwP6j/0PHWYTUa9JKml9RQmMKuy/oxU/orw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 611/817] usb: typec: fix potential array underflow in ucsi_ccg_sync_control()
Date: Tue,  3 Dec 2024 15:43:03 +0100
Message-ID: <20241203144019.782907270@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 763ff99f000d9..14c2dc9255b54 100644
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



