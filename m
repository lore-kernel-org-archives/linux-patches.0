Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459B11F152D;
	Tue, 30 Sep 2025 15:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244633; cv=none; b=dmeHlX03I0NRUxNWamyUrA/00EK9yz16fLs9igPeRkaCUv+NbtaNQhMyEt/DwIm8aHa/Q3Jv0ZudlroxW7Gwpnvp/vhM78EvvY6S3zxHgSZy7anzYJHqgXVxMUlNgoCY/CWiRmzZUd8HS0Fw3Nh1F8dDMqHHmu3wCq/oXdo2gfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244633; c=relaxed/simple;
	bh=A83HdLlteLYqFPiNIdFRa6oJoNEGErnYtejRrn9zGrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1ZfYoGTHoYtiEWUxhdU9W5dE+gZ+QC1MLuoRdLJeFQqNQdMIX7yYglnJBh9jVhTVB0797LazSUBGyVkTobz5LR5/2DOvnjRBUZ807AaFbFVmx1tpy7s2vR7gSVvXtjZwA2NG7ct44fkcKWq1+LcaGQ2uCnfAhKQ6GAw45sWYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaQrNpR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaQrNpR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE476C4CEF0;
	Tue, 30 Sep 2025 15:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244633;
	bh=A83HdLlteLYqFPiNIdFRa6oJoNEGErnYtejRrn9zGrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaQrNpR9GFfF1RBVkWrSnWzm1jfqi63BN899C3k15XV+pUwQC85Tc9w1wbux8WBv/
	 1q2bZw5MeB8K1q96UHeb01Y3QdeWpzHIcj29AWS+j3N7YgScXlPv1YEaoFX0VwHHzy
	 zHBZGPVXNsBNuJ4EXevXdQ+SzlTzfHhPNZnCbSUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 068/143] Bluetooth: hci_sync: Fix hci_resume_advertising_sync
Date: Tue, 30 Sep 2025 16:46:32 +0200
Message-ID: <20250930143833.948658258@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1488af7b8b5f9896ea88ee35aa3301713f72737c ]

hci_resume_advertising_sync is suppose to resume all instance paused by
hci_pause_advertising_sync, this logic is used for procedures are only
allowed when not advertising, but instance 0x00 was not being
re-enabled.

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a25439f1eeac2..7ca544d7791f4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2594,6 +2594,13 @@ static int hci_resume_advertising_sync(struct hci_dev *hdev)
 			hci_remove_ext_adv_instance_sync(hdev, adv->instance,
 							 NULL);
 		}
+
+		/* If current advertising instance is set to instance 0x00
+		 * then we need to re-enable it.
+		 */
+		if (!hdev->cur_adv_instance)
+			err = hci_enable_ext_advertising_sync(hdev,
+							      hdev->cur_adv_instance);
 	} else {
 		/* Schedule for most recent instance to be restarted and begin
 		 * the software rotation loop
-- 
2.51.0



