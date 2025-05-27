Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236C7182D7;
	Tue, 27 May 2025 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366590; cv=none; b=sa68ZHitNmfTD9/N/Tb1pwUsDIBZ+6Qqm8chwDDxIioRMbs6pMrLn4UqfG84jcTZ1fAIVzhu12QtqrrYNVmx9ClexJwM5zDUtjEXXnqKoib5QGggkRcmGSjjYHNmhmT/Hd1/I2r3f7Re41+X1cb5sukFqI/JpKvzDrj2XphlZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366590; c=relaxed/simple;
	bh=29oLjvBUc5NL3NTRzbwXwY+q1G8am+g4yZpH5o58pIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDxGmcemOc8DdGx7s6NOJvO06vAT7BwCrElSpYpkFdIGVOTvSFXUdNmKfFH4ijpPPMQ6vh6hZRCWVx42nr80vkMCmXP6ZsD5FRlaCNv/L8R2cVRS/ZTGFyRWp0wNtLr7gc9jKRI+fFS7bKD4iEHwbVpfp06gyFbVQB0OWnegLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBVviH+1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBVviH+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A4AC4CEE9;
	Tue, 27 May 2025 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366590;
	bh=29oLjvBUc5NL3NTRzbwXwY+q1G8am+g4yZpH5o58pIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBVviH+1dxuuC5Zd8kVGrWx5WbAt4pHieNNS4ChInx12AyWMbfQGOEpcHpCch41N+
	 03sz/Z2SQnSCa+AzjPXCgU4DUDNT3c8GUY4a0ynLR58el+lbi6lJiKHo9wdzXXZozM
	 D47+MT3OC2i6YkVwuHcskObW3YT5411o2AExXOgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Nishiyama <nishiyama.pedro@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 087/783] Bluetooth: Disable SCO support if READ_VOICE_SETTING is unsupported/broken
Date: Tue, 27 May 2025 18:18:04 +0200
Message-ID: <20250527162516.683360433@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Nishiyama <nishiyama.pedro@gmail.com>

[ Upstream commit 14d17c78a4b1660c443bae9d38c814edea506f62 ]

A SCO connection without the proper voice_setting can cause
the controller to lock up.

Signed-off-by: Pedro Nishiyama <nishiyama.pedro@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ab940ec698c0f..7152a1ca56778 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -930,6 +930,9 @@ static u8 hci_cc_read_buffer_size(struct hci_dev *hdev, void *data,
 		hdev->sco_pkts = 8;
 	}
 
+	if (!read_voice_setting_capable(hdev))
+		hdev->sco_pkts = 0;
+
 	hdev->acl_cnt = hdev->acl_pkts;
 	hdev->sco_cnt = hdev->sco_pkts;
 
-- 
2.39.5



