Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215322C21F8;
	Tue, 31 Mar 2026 17:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976420; cv=none; b=iiH4InIaHXbbz8dufsQl3IecgjnwFzrRvAN3Zwf3T18zBAyT/G5KjLCQZbAVCmTjG4U8DAnD+v3eMn3VdSlDtL1BmJE0TAg+WZqSWhC+9SwyS7TsIeYJr37atcMqZBBSknAsxDMUiqIu88F3VvAzBhXaEU5LFLs/dFRz4DeKJAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976420; c=relaxed/simple;
	bh=J0dgRK9hZ4+XZDMn0XFVo49Yv6TieCkve71lRlKN6k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyfPEPXflmzdqLd05nvEKChGlxcU6hQR+wetUVXd1dnzj44hLjlNu/l9/gkPeWXeNUBU9GNNbL6rCc4UHJiEGAUl/OPl5MQi266G76WGirCgW0pqdLRzCzh06h/iVyQzbeBjv9yZcfseHVqXU9rZkLEkPAc2rxc0RGAWgETtvhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H172ZQvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H172ZQvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9142C19423;
	Tue, 31 Mar 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976420;
	bh=J0dgRK9hZ4+XZDMn0XFVo49Yv6TieCkve71lRlKN6k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H172ZQvEBgzk2CAkUfaLF6B/3R5Gc/E/MWefhS3B58eRshVU52JAhEp7YwmCMpKdi
	 V1ltrFY4YepzW/BCced2xjPpd1pzwEtn8Byt1w2yafli4t3cOWmegCZGsrODH8gm/Z
	 LF/xEkcXH0GR316opompyE2g23UsN44d2JqO6+B8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/309] Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete
Date: Tue, 31 Mar 2026 18:19:48 +0200
Message-ID: <20260331161756.613403689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5f5fa4cd35f707344f65ce9e225b6528691dbbaa ]

This fixes the condition checking so mgmt_pending_valid is executed
whenever status != -ECANCELED otherwise calling mgmt_pending_free(cmd)
would kfree(cmd) without unlinking it from the list first, leaving a
dangling pointer. Any subsequent list traversal (e.g.,
mgmt_pending_foreach during __mgmt_power_off, or another
mgmt_pending_valid call) would dereference freed memory.

Link: https://lore.kernel.org/linux-bluetooth/20260315132013.75ab40c5@kernel.org/T/#m1418f9c82eeff8510c1beaa21cf53af20db96c06
Fixes: 302a1f674c00 ("Bluetooth: MGMT: Fix possible UAFs")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1a270f0b17d9e..5d70b1f69bb6d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5273,7 +5273,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 	 * hci_adv_monitors_clear is about to be called which will take care of
 	 * freeing the adv_monitor instances.
 	 */
-	if (status == -ECANCELED && !mgmt_pending_valid(hdev, cmd))
+	if (status == -ECANCELED || !mgmt_pending_valid(hdev, cmd))
 		return;
 
 	monitor = cmd->user_data;
-- 
2.51.0



