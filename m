Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCC2298CB7;
	Wed, 23 Apr 2025 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421776; cv=none; b=OJMLO+6K/9WIhwcYwzSRVPFTy2IyxBHDjjcgSfi4iVk+4PDD0PVnl/gBiqjXInH4gZoGo0/mVbisAEeuSclJUqHfGDsE9M71IOvpUOCUXGpLlOKMjTte1ZHZT+8hjvmEWEKtr1mEIPLA5uNUh9b7uK9GbYXZa4nw89zvmwVoQvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421776; c=relaxed/simple;
	bh=8tEUPTSMkjirLZqBhFi0ZIXnNS+dFVbR75Jlea0lSig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TokI52xERrKB8iSwiMtNa7NK7VYO4w/IFoOB70nPGgfvyLjPfM7SWJsPB/lR7ezYPJ4CeAmZB1nn3IkL25QBgxViCa5hwzHvb+ynKjScftXoeDE7jOKew9GTLdLJRkxCIZ8zSjSE7IgX43MI9ajjyOHbJLT2ugB176xLPxWaHY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgBqJvwT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgBqJvwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AA5C4CEF1;
	Wed, 23 Apr 2025 15:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421776;
	bh=8tEUPTSMkjirLZqBhFi0ZIXnNS+dFVbR75Jlea0lSig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgBqJvwTLYbX/g4TO5Qi4t7i7A7CwD3CNszIbKMeCEd6DoocPiR10lO3vknj3RjQV
	 mX1JCmt5E8cRqRX2vxjU+0xOZ2Z35dDH916qQqqTlvgysDDrkfUGmOovHtnFpTw3D/
	 Zsi/SkTOuwu9TosbPakN/bODJ4wZyHZLJXhvzaLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/291] Bluetooth: btrtl: Prevent potential NULL dereference
Date: Wed, 23 Apr 2025 16:42:46 +0200
Message-ID: <20250423142631.615478148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5671f0d9ab28c..1c122613e562c 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -817,6 +817,8 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
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



