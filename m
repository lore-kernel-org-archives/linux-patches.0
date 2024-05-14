Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3EE12E1E2;
	Tue, 14 May 2024 11:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686717; cv=none; b=i+7KLelpxzqA2CX5xa15kf8e5uxgwgMwpilpG3uFee5A/djJtlcldGwuiItZr89V9B2WbN+mTm+ueAQwHBvmXJXsGnK/AAuooagEy5mPoWYFC4Wx3AMo+oUUQBXRVi0ZniDrzBB1sW4joK3gvqm5/UvRSvQwEVexA7cxQfBXKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686717; c=relaxed/simple;
	bh=o1Wr5i9efbq0tY/7RW7sFc0InXWlNLbVBCMfFIGGuhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkB9AFls8xYmyV6gmeaarzUPRFRKRnSZnRZG8G90lFudxxvYQ/DyQIBiAu4H4d5g2XK6165WZ+AJZ0Hx2t+dsQM4D5rRgC0fNgDfCq09vbh+BKOKCmd/uaCeO5D5FfJxK4Nu4ymTkE4onSrv+AVjmYSTvB4TyuMTWizrjAlqKPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j2jfiUM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j2jfiUM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF86C2BD10;
	Tue, 14 May 2024 11:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686717;
	bh=o1Wr5i9efbq0tY/7RW7sFc0InXWlNLbVBCMfFIGGuhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2jfiUM4RUTNj+/uJSPyWJ13X0A7HcvyY2Pz21YlK3qw0b4xK0g4pAZK0GwI3gMx4
	 JfHJOEQkQVR+4p4CBrZCRCR5+Y/xBCQIg8O7TJw0NWzc4jEop0hCWu9tHTozIlWSiu
	 gPd2L/gBg4dcrFFj+jT8/46Y17pd1qvm/Hn2oDTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Jiang <quic_tjiang@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 234/236] Bluetooth: qca: fix info leak when fetching board id
Date: Tue, 14 May 2024 12:19:56 +0200
Message-ID: <20240514101029.241840373@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 0adcf6be1445ed50bfd4a451a7a782568f270197 upstream.

Add the missing sanity check when fetching the board id to avoid leaking
slab data when later requesting the firmware.

Fixes: a7f8dedb4be2 ("Bluetooth: qca: add support for QCA2066")
Cc: stable@vger.kernel.org	# 6.7
Cc: Tim Jiang <quic_tjiang@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -235,6 +235,11 @@ static int qca_read_fw_board_id(struct h
 		goto out;
 	}
 
+	if (skb->len < 3) {
+		err = -EILSEQ;
+		goto out;
+	}
+
 	*bid = (edl->data[1] << 8) + edl->data[2];
 	bt_dev_dbg(hdev, "%s: bid = %x", __func__, *bid);
 


