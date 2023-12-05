Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3598BF8;
	Tue,  5 Dec 2023 03:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNOZ1VpJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83774C433C8;
	Tue,  5 Dec 2023 03:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747544;
	bh=4tmy0UcTiu7RhmAbr3mUxvfKPfBq46XvPtwxd5kQVFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNOZ1VpJtbjFZ8vJzLXIhotgaF9oBC4jV7E4fkB03Sqdd+BLHvTjhf2VxWRER4o8m
	 P8DYk2wl1TBRINcTYtniBXv7qeNdAI3eQabXzTYcZD6zHcYb2TIUjvC0uBXL9RDpiU
	 vsa0qgbBUjgWh10sC3+Pjxq9ZcQ2PBx3RO6Fpn6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/135] usb: config: fix iteration issue in usb_get_bos_descriptor()
Date: Tue,  5 Dec 2023 12:16:52 +0900
Message-ID: <20231205031536.356287376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 974bba5c118f4c2baf00de0356e3e4f7928b4cbc ]

The BOS descriptor defines a root descriptor and is the base descriptor for
accessing a family of related descriptors.

Function 'usb_get_bos_descriptor()' encounters an iteration issue when
skipping the 'USB_DT_DEVICE_CAPABILITY' descriptor type. This results in
the same descriptor being read repeatedly.

To address this issue, a 'goto' statement is introduced to ensure that the
pointer and the amount read is updated correctly. This ensures that the
function iterates to the next descriptor instead of reading the same
descriptor repeatedly.

Cc: stable@vger.kernel.org
Fixes: 3dd550a2d365 ("USB: usbcore: Fix slab-out-of-bounds bug during device reset")
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231115121325.471454-1-niklas.neronin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 1e40e63d301bd..2f8a1225b6976 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -1047,7 +1047,7 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 
 		if (cap->bDescriptorType != USB_DT_DEVICE_CAPABILITY) {
 			dev_notice(ddev, "descriptor type invalid, skip\n");
-			continue;
+			goto skip_to_next_descriptor;
 		}
 
 		switch (cap_type) {
@@ -1080,6 +1080,7 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 			break;
 		}
 
+skip_to_next_descriptor:
 		total_len -= length;
 		buffer += length;
 	}
-- 
2.42.0



