Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C71265606;
	Tue, 21 Jul 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663783; cv=none; b=uo8KbamObVXid7aee7lBKGbAyNFrErZ6WMo6ObU/NO9iubImSghg73r0XOIsPC3+oQE7wKLskvDlAajtxMnW7wYLIDEGpb4Cs8v/fdtEynznoqPBn4N8O60C/sV1SnBshas3eyCdg5rKXREpcPVh7kxia1TkBcfxOk9IFm4gQV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663783; c=relaxed/simple;
	bh=nUF/OCdbndVv+aoCt2yOkURIgGuogSvFpH2nP7Qu1ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxvZEj8VOOui5eYIb+b5v5BBwZb2lVYfjoNkjpff4nhamuT1OqW61N0dIGE+h332fqVG+N0gZSsUwROnt+y0X2xPre2mQVU4kGb4hMCgB3dZ29l9jSxge9eOKuTLvCjgfajKml3Rpdjx7TEig7H4A7zT50jIaNOZmJaqONaYo9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHco54O5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHco54O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FD71F000E9;
	Tue, 21 Jul 2026 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663782;
	bh=8jlbFwGleVFACMOTJbQdOszHw0U0cwwXW6hdGwpDquI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHco54O5r2anSXC1a+z8NqPsFmkJ7lf1Zdsr5ImQiaWyfVTRCcOlMDBpvHk1ljs4B
	 DsQ6o2tkb5QwXh8wQfBcB1vxsk80tPs/QP1TxVJyCjaNe7x9cP8+dWsKKdSryAHCf3
	 MLf5GVgyuknvcp17XUZ1AHcISXC3cdjCduiwF604=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.12 0952/1276] bus: mhi: ep: Protect mhi_ep_handle_syserr() in the error path
Date: Tue, 21 Jul 2026 17:23:15 +0200
Message-ID: <20260721152507.332744149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit 519ddf194b158b91439319f6b977b8a465fda0fb upstream.

All the callers of mhi_ep_handle_syserr() except mhi_ep_process_cmd_ring()
are holding the 'state_lock' to avoid the race in setting the MHI state. So
do the same in mhi_ep_process_cmd_ring() for sanity.

Fixes: e827569062a8 ("bus: mhi: ep: Add support for processing command rings")
Cc: stable@vger.kernel.org # 5.18
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260302085612.18725-1-manivannan.sadhasivam@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -232,7 +232,9 @@ static int mhi_ep_process_cmd_ring(struc
 			ret = mhi_ep_create_device(mhi_cntrl, ch_id);
 			if (ret) {
 				dev_err(dev, "Error creating device for channel (%u)\n", ch_id);
+				mutex_lock(&mhi_cntrl->state_lock);
 				mhi_ep_handle_syserr(mhi_cntrl);
+				mutex_unlock(&mhi_cntrl->state_lock);
 				return ret;
 			}
 		}


