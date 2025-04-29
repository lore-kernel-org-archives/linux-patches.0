Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1AAD530;
	Tue, 29 Apr 2025 17:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946915; cv=none; b=VCg2QF77+mTNgLNuh9qj2EqltwxP3d9Fmbr/Yd92GT3MOTbHCGAJmzWLqUHrYScVL8+eISP17+pG4ZPXQ8K0kdH42jvmSwMR1pQTNbk+Oh5wKodCh6p4JpiEUMzRN+3VBAMicFxYzJcC6PgU8jpNA6bfVjJmKesDXGCCL8JbjJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946915; c=relaxed/simple;
	bh=wb8o+6aDsVNeL48lo1ktaLOUhLZgpAbHHKraeIWx5tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVggFuQsX+Wj4hyTCe/E8SDLzgO7t0lvh4xwBkTGFeTwurPBsSQGAW+zJAuUxwK7w6s5mY1gDPZu6USy1LCwUyiAXj4uhgHU6M3NZXgqK0/PtAadqSnj/ZYRCjIb68RNpI3xuxDzEbxA+4acASuexvL3NiErNfOZ/aEMeeFghVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FklWKpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FklWKpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDA0C4CEE3;
	Tue, 29 Apr 2025 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946915;
	bh=wb8o+6aDsVNeL48lo1ktaLOUhLZgpAbHHKraeIWx5tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FklWKpE4A7CG/mzAxBtBPwolSWxoCJCiFbAp2wo0f4tgF07ibqT/P2jiJ1thlaGa
	 2muqX3VLV87+MjD+uRsZruQ0C/yXxJhh7U+UZdXBOoFqmlWO+frPbh1Frq0hc34vmh
	 vtLP3vlfvh7VxqRBjyOTI+yCZL5CB39bvt+ZnANA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/286] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Tue, 29 Apr 2025 18:40:15 +0200
Message-ID: <20250429161112.425804591@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 324dddea321078a6eeb535c2bff5257be74c9799 ]

The btrtl_initialize() function checks that rtl_load_file() either
had an error or it loaded a zero length file.  However, if it loaded
a zero length file then the error code is not set correctly.  It
results in an error pointer vs NULL bug, followed by a NULL pointer
dereference.  This was detected by Smatch:

drivers/bluetooth/btrtl.c:592 btrtl_initialize() warn: passing zero to 'ERR_PTR'

Fixes: 26503ad25de8 ("Bluetooth: btrtl: split the device initialization into smaller parts")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index 3a9afc905f243..77de43d8d7962 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -625,6 +625,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
 			rtl_dev_err(hdev, "mandatory config file %s not found",
 				    btrtl_dev->ic_info->cfg_name);
 			ret = btrtl_dev->cfg_len;
+			if (!ret)
+				ret = -EINVAL;
 			goto err_free;
 		}
 	}
-- 
2.39.5



