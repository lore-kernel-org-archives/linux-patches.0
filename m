Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D67425CC7;
	Tue, 31 Mar 2026 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975013; cv=none; b=WHslq7WO5GL94KOReCCV9ylZnxikGKh/LeItUDx7J4HA1ikCdD3MZ0B24WWtm9HFPaNwgFpEY0NRa4MZs1dlkwZNnCO9YQqJF8SULFjugAlFPwAWU9BZ1DTBzAh/0GDiA08FD0+M8nwrD2uBesHixR9tJs1CjNGyAoBqU3tNMOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975013; c=relaxed/simple;
	bh=LJGlFB5qp+C6Wy3sk/lwtsBqbkwujsVMEiPgZKtyyFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxvaY+DtjTqfYUGGELR531DAYPcwIxwu11vlI+5EEEgqsU65AOoXCJzgQd/D5zDpL9AV7OvcPqC2XZW6BQmr6/InBrm3rjFwcuRCslMhLs23kCO9zsJvkT4SnTA73Z79jsI9eoYMUOw9qmy4P7SA9O0vWZ1GIMQ25lb8YxmHT9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGK087Lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGK087Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC23C19424;
	Tue, 31 Mar 2026 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975013;
	bh=LJGlFB5qp+C6Wy3sk/lwtsBqbkwujsVMEiPgZKtyyFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGK087LmjC+LLXvJ0lFcXebTHAKCHR4LlMOhgn+RMMxO3tJyDaloyTSnRDxV0kzd+
	 TgaYmHHFe5LCgp7+Y31fK4W67a96okqC1JQ7sb5Jdcpy7qqMZHbFlpwWf2kfMuc4QT
	 e4PvT5edFhaGhAh3spry+zEioWVkUJCp/W0hNN8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 097/342] Bluetooth: hci_ll: Fix firmware leak on error path
Date: Tue, 31 Mar 2026 18:18:50 +0200
Message-ID: <20260331161802.587051801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6f4e25917b863..c4584f4085766 100644
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



