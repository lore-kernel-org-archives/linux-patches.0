Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72898347517;
	Wed,  8 Apr 2026 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671691; cv=none; b=fQ/FDawz2l+O4HiGMbIp/oU7QkmNpDejV2YmBbazSEav+kJlrIju0mj34K1UKJILuWS6JeM6Q1Iuzz0OhICp6jLJlbtJt+imLFVV7rGmnM2BveyZ8OJLHUbeeVJehhhaA1pAPRecE3rAEWoCVEajcW1rW78ryhI4t64sZgPSb+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671691; c=relaxed/simple;
	bh=OXqss7rd4ltxx2BxHeKEbGCR45GGmSZaJf8iTb6jdlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK8dV2V8OEUNmtFE632wpDJ+CG9Y6ifLTjpbINw9fcI+OspvJu6ut/3QzY3aEVUUJecdC0iJhJ4QAoNzeoe7SCLP7d5DzmdPxS7ssLIpJa5en4FA10EB+I0qwtrZKXbwB6Ko2lwVeqvgWqx1wmd98bH6M4Y+JVj6xbyRBxXFGxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3vZvFAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3vZvFAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE215C19421;
	Wed,  8 Apr 2026 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671691;
	bh=OXqss7rd4ltxx2BxHeKEbGCR45GGmSZaJf8iTb6jdlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3vZvFATaZuEkBhmTc1pGL6wQxI4FeY2fiUIFrf+ETaCGoHYxGfnd8QwfahACCwPc
	 Qjbk7Gg7pujIG8AKo5miroVLXZXHzP899OQ67qN9MAvruR2Bl4ixA+xQUUT+WvHQHX
	 yFEfJxUSy9pQZvP1HdBsK0TjCgnjNyzNkCUFYUjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/312] Bluetooth: hci_ll: Fix firmware leak on error path
Date: Wed,  8 Apr 2026 19:59:08 +0200
Message-ID: <20260408175934.890950519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit 31148a7be723aa9f2e8fbd62424825ab8d577973 ]

Smatch reports:

drivers/bluetooth/hci_ll.c:587 download_firmware() warn:
'fw' from request_firmware() not released on lines: 544.

In download_firmware(), if request_firmware() succeeds but the returned
firmware content is invalid (no data or zero size), the function returns
without releasing the firmware, resulting in a resource leak.

Fix this by calling release_firmware() before returning when
request_firmware() succeeded but the firmware content is invalid.

Fixes: 371805522f87 ("bluetooth: hci_uart: add LL protocol serdev driver support")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 5abc01a2acf72..a5ef57b27bf28 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -541,6 +541,8 @@ static int download_firmware(struct ll_device *lldev)
 	if (err || !fw->data || !fw->size) {
 		bt_dev_err(lldev->hu.hdev, "request_firmware failed(errno %d) for %s",
 			   err, bts_scr_name);
+		if (!err)
+			release_firmware(fw);
 		return -EINVAL;
 	}
 	ptr = (void *)fw->data;
-- 
2.51.0



