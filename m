Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C07533993;
	Tue,  6 Jan 2026 17:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720833; cv=none; b=kzDsW35nJbk/dX110sCwQJEtRrf3bkTE/A0YvEPMYr9ytfiaa/jn/kukELa9ZebvKK8GWe8aUGhWQ2nETZgGMnwHa/OQC93AQGndYOXow3IyF2uz012RNRG89hWCSTSgA5UN2//YD7CQCqhDwE1zqokoRUy1NBLsO+WR8IbvuFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720833; c=relaxed/simple;
	bh=68X1AQZApyjLvXTSFbLCUItAP+9uiEEFjYuAHpU8ja8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFmDJ7+bEcdTMHkRgksyBj39ohAFhXy4ZhEgPd0Z6VOgSRsg2DOwfRBkvIuvJh73G/pKufNDWn9nUBO6k+9tXMZohdFdy/PLY2feKYWsYuzpJIAbhJDlQKPFizuFKjD5rB/jrEHHlJZvHzYZ+rMb93LOFzOBko/Zle+JHFoIurg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd2sjGff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd2sjGff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBAFC116C6;
	Tue,  6 Jan 2026 17:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720833;
	bh=68X1AQZApyjLvXTSFbLCUItAP+9uiEEFjYuAHpU8ja8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qd2sjGffl/y6Qp7CkolLxds/7Z3ajQgRGXUbNS7325tENquFM4cYdvjB2zIzl5w5R
	 BmA/n3//z6AGf9D9aN9NV/aJfm/kwsExr2j70sYXx/cZwUxBo9NW7B5vb5BY6P4fOv
	 ED7lXYhC7p1qMXuF15oKGpXYYQTgmyEUB1yZJI+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dd915c7cb0490fc8c52@syzkaller.appspotmail.com,
	Deepakkumar Karn <dkarn@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 313/567] net: usb: rtl8150: fix memory leak on usb_submit_urb() failure
Date: Tue,  6 Jan 2026 18:01:35 +0100
Message-ID: <20260106170502.906310568@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepakkumar Karn <dkarn@redhat.com>

[ Upstream commit 12cab1191d9890097171156d06bfa8d31f1e39c8 ]

In async_set_registers(), when usb_submit_urb() fails, the allocated
  async_req structure and URB are not freed, causing a memory leak.

  The completion callback async_set_reg_cb() is responsible for freeing
  these allocations, but it is only called after the URB is successfully
  submitted and completes (successfully or with error). If submission
  fails, the callback never runs and the memory is leaked.

  Fix this by freeing both the URB and the request structure in the error
  path when usb_submit_urb() fails.

Reported-by: syzbot+8dd915c7cb0490fc8c52@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8dd915c7cb0490fc8c52
Fixes: 4d12997a9bb3 ("drivers: net: usb: rtl8150: concurrent URB bugfix")
Signed-off-by: Deepakkumar Karn <dkarn@redhat.com>
Link: https://patch.msgid.link/20251216151304.59865-2-dkarn@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 278e6cb6f4d9..e40b0669d9f4 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -211,6 +211,8 @@ static int async_set_registers(rtl8150_t *dev, u16 indx, u16 size, u16 reg)
 		if (res == -ENODEV)
 			netif_device_detach(dev->netdev);
 		dev_err(&dev->udev->dev, "%s failed with %d\n", __func__, res);
+		kfree(req);
+		usb_free_urb(async_urb);
 	}
 	return res;
 }
-- 
2.51.0



