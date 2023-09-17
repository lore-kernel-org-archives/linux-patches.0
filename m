Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519B56FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81151C433C7;
	Sun, 17 Sep 2023 20:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981719;
	bh=ulDAvKJZcI/cYcVItB/icSDIb/tXcmvj0x1kUIUnaJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ksh/OniKjSk9uVYnmfvS/VJaMFVQnjlJkjy2CY52kaoedFookRzPtYxcTC+YkUfv9
	 ymDocNOE4T8LWEfJMDgb0kVcVQ6u2YfHo3CamhLbsePZrSKUzW4CTOPqZql8wTa24f
	 qcoshpOIIfBjnPwTbn5+w4IM7+B1RTE04HzvnSH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/511] Bluetooth: nokia: fix value check in nokia_bluetooth_serdev_probe()
Date: Sun, 17 Sep 2023 21:08:44 +0200
Message-ID: <20230917191116.210508128@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit e8b5aed31355072faac8092ead4938ddec3111fd ]

in nokia_bluetooth_serdev_probe(), check the return value of
clk_prepare_enable() and return the error code if
clk_prepare_enable() returns an unexpected value.

Fixes: 7bb318680e86 ("Bluetooth: add nokia driver")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_nokia.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_nokia.c b/drivers/bluetooth/hci_nokia.c
index 05f7f6de6863d..97da0b2bfd17e 100644
--- a/drivers/bluetooth/hci_nokia.c
+++ b/drivers/bluetooth/hci_nokia.c
@@ -734,7 +734,11 @@ static int nokia_bluetooth_serdev_probe(struct serdev_device *serdev)
 		return err;
 	}
 
-	clk_prepare_enable(sysclk);
+	err = clk_prepare_enable(sysclk);
+	if (err) {
+		dev_err(dev, "could not enable sysclk: %d", err);
+		return err;
+	}
 	btdev->sysclk_speed = clk_get_rate(sysclk);
 	clk_disable_unprepare(sysclk);
 
-- 
2.40.1



