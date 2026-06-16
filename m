Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2883044102A;
	Tue, 16 Jun 2026 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623569; cv=none; b=JZbQV9d/DqmAVOuGbSSNBoZzHqJ3H9lgxdQJhu332j9ag3RLkyV3GCDtHAHKHzzuLBzcHGaJJrDKgrQjx8S0JBxC0IlehlzRlKlf4S2g6RcLzbfjHkW0b2C1W3DAeshJxjUKpEQYN3CYD78fByNtXha9E5tRNXC1I9sWg9Hl2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623569; c=relaxed/simple;
	bh=XbbuCKrCRkrs6SF99r7GaYKaFffH3n1HIjjWgOwArXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcGDea7Xz4gUE/gnqDQCkJ07Hth7djy7lw6iaj6sL01ShlrEwFzvC0OEALGZWVgOyP+LcnwvKn/5MmSsU3BFwRwUz47NPtc0srMD/17MR+8RRZWH+8GIWutl4We+KJbpcuiwKS1JnfHrkJY+g1YWYK6zwVW/qIpa7Kq8padWDuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkHY8Oa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkHY8Oa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5461F000E9;
	Tue, 16 Jun 2026 15:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623568;
	bh=W+GUFc8HhiPhHHDrFAbQAvmRsGMRV2CshJIrp/ic3iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkHY8Oa/Gn4P9K2oM7pbZ2Bbe817mtfIoCR7ARrtQ2ghv1EJ0wQ7bBqCauel84aH9
	 6XVJgufXhzITFkFguG9TrVUEwsHaTwvBAdHpYxhkw/F3CgwIhtSfF9+cE6MAK/UK+h
	 JKQQVMVqERzJqOTCY+PITSJ1JQe+KNuuRC7LgoKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuqi Xu <xuyq21@lenovo.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 172/378] Bluetooth: hci_sync: reject oversized Broadcast Announcement prepend
Date: Tue, 16 Jun 2026 20:26:43 +0530
Message-ID: <20260616145119.387573825@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuqi Xu <xuyq21@lenovo.com>

commit 5c65b96b549ea2dcfde497436bf9e048deb87758 upstream.

Existing advertising instances can already hold the maximum extended
advertising payload. When hci_adv_bcast_annoucement() prepends the
Broadcast Announcement service data to that payload, the combined data
may no longer fit in the temporary buffer used to rebuild the
advertising data.

Reject that case before copying the existing payload and report the
failure through the device log. This keeps the existing advertising
data intact and avoids overrunning the temporary buffer.

Fixes: 5725bc608252 ("Bluetooth: hci_sync: Fix broadcast/PA when using an existing instance")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Yuqi Xu <xuyq21@lenovo.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_sync.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1725,6 +1725,11 @@ static int hci_adv_bcast_annoucement(str
 	/* Generate Broadcast ID */
 	get_random_bytes(bid, sizeof(bid));
 	len = eir_append_service_data(ad, 0, 0x1852, bid, sizeof(bid));
+	if (adv->adv_data_len > sizeof(ad) - len) {
+		bt_dev_err(hdev, "No room for Broadcast Announcement");
+		return -EINVAL;
+	}
+
 	memcpy(ad + len, adv->adv_data, adv->adv_data_len);
 	hci_set_adv_instance_data(hdev, adv->instance, len + adv->adv_data_len,
 				  ad, 0, NULL);


