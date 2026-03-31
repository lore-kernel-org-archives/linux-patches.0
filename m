Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4CE423A8E;
	Tue, 31 Mar 2026 16:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975011; cv=none; b=Gt3aT1maq7gcKDn6zokkwDN7/P9fhGJBISEon2k4gNmykIbFvH8IG3VB2/L+YQM7Jl0rstghEumoJOuKCESmD/8nKTS/Hg+7r8aGBe0+xTlfgmsNbaU7ewreCs5EmKWqXE23B+7cOpEIwncLiDi/9G9B48a0cgIswdlHEwzy8Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975011; c=relaxed/simple;
	bh=INlR2GdcM95gM6kcxK6kENcAzf8i5BKX27BKy/Ozuwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S01XPXsxtLDLfo1oW6H2J5YtzwkZw0fzFFPA5HIR8gZga+6ByzdGls3WqTDoS4fi2WE+WXXoeha1lFecITL6F7Iztn07B9yMWUQcFf4zT2si9ZIrlB1HN+9dzNPa7Udeg/sYVjYM6hB77d8fHUo1wAaoHhmWoZCZ4n92IPY/3MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=no/kVmW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="no/kVmW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856D9C19423;
	Tue, 31 Mar 2026 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975010;
	bh=INlR2GdcM95gM6kcxK6kENcAzf8i5BKX27BKy/Ozuwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=no/kVmW4bRnQwsIkarJdA5cyxhFwBoMMp1dv8pads/x7jlxqQ3UH50zuBAJuYPvSJ
	 ThHbqyNWpMSnaJAkx6SN9ubOsRHVMbJocueLZQ9NQEKmY/kpZfm+VaX+kRU/ptpASc
	 weR5b9MGU3SXYAl2MEsH1HxDMV6DYVbZO41UZC9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 096/342] Bluetooth: MGMT: Fix dangling pointer on mgmt_add_adv_patterns_monitor_complete
Date: Tue, 31 Mar 2026 18:18:49 +0200
Message-ID: <20260331161802.551231500@linuxfoundation.org>
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
index 2c63f49c33018..f3da1bc38a551 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5355,7 +5355,7 @@ static void mgmt_add_adv_patterns_monitor_complete(struct hci_dev *hdev,
 	 * hci_adv_monitors_clear is about to be called which will take care of
 	 * freeing the adv_monitor instances.
 	 */
-	if (status == -ECANCELED && !mgmt_pending_valid(hdev, cmd))
+	if (status == -ECANCELED || !mgmt_pending_valid(hdev, cmd))
 		return;
 
 	monitor = cmd->user_data;
-- 
2.51.0



