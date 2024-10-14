Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759D21C7B9C;
	Mon, 14 Oct 2024 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917487; cv=none; b=UE0ZV6tXZHGl3WBbrPjY7bgiRxE6yyQ2yoRbA9+7aDH0amyxda8uhgXSAK5njHNN/X+ur8fKbxD77jJ4ki/kC+D79CCcnSjJuI5APtZ3u79Y8soxQ3RbsFmavq/kF0FtGNBRWbBX2lbJONtqzmUFlpzyRthZBFFhnnd1YYgwUdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917487; c=relaxed/simple;
	bh=+z9SGqI/u0vQ8yplZQy+A6r7nVzqYktKbE4oGFtvtC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBdrJZ8VRsrMjU2WBj9GADGz5GsPQawwW3yKiTrcoi1zzR0c70tyIAE0EuqEI0Nls8Ur4lxyWLHWl2Zju68o5iua5PCyrMMXMvWniq8nIsc8OxDOdtgAaac0J4hb/3SL+AU9XZ0WwTQxwnSB8qwiESNdUn8ipT1LX+yObnRbktI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5G88Fpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5G88Fpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBC3C4CEC3;
	Mon, 14 Oct 2024 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917487;
	bh=+z9SGqI/u0vQ8yplZQy+A6r7nVzqYktKbE4oGFtvtC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5G88FpjNokX8340gi0Dom0FhJ54To4TTm22L/xpoDAMN0jG//Wpa3QezqiwqD6Px
	 ARwrPX+HR7qH+99CbrSjs1dZxQLJxGDUzYKH/A4xe15FB1OEzIEAJ21lr3X+mqtYfm
	 dmpcIe5lYnseg1jJ6ZiKK6UNQDJB916JE9Pn+6P0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/798] Bluetooth: hci_sync: Ignore errors from HCI_OP_REMOTE_NAME_REQ_CANCEL
Date: Mon, 14 Oct 2024 16:10:02 +0200
Message-ID: <20241014141219.830290472@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit cfbfeee61582e638770a1a10deef866c9adb38f5 ]

This ignores errors from HCI_OP_REMOTE_NAME_REQ_CANCEL since it
shouldn't interfere with the stopping of discovery and in certain
conditions it seems to be failing.

Link: https://github.com/bluez/bluez/issues/575
Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3d6a22812b498..0cc187ff35874 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5256,7 +5256,10 @@ int hci_stop_discovery_sync(struct hci_dev *hdev)
 		if (!e)
 			return 0;
 
-		return hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
+		/* Ignore cancel errors since it should interfere with stopping
+		 * of the discovery.
+		 */
+		hci_remote_name_cancel_sync(hdev, &e->data.bdaddr);
 	}
 
 	return 0;
-- 
2.43.0



