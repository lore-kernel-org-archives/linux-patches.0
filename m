Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F5128505E;
	Mon, 13 Apr 2026 16:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096978; cv=none; b=T2N8p1HKpcU1v9uNy00BdXLArzeNV2uw/SY5t8aLGu/zGkVe0Z5CFLCju6LMIt6J8ZvUlc7Es4xj88s19fDwHkoI0r9Pj22sSQajqrksyebbeQ6r6yLUrpiRobJBufM/tndi+mSg+VjTpCPrq4z6TtP0VCOH+A7FQRFoSR8E3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096978; c=relaxed/simple;
	bh=f1CIRpe5dKiQ1G4RmG6XWIE3wDgaiaPQpv68Jjhu6q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBKpIg0ik9NDAv0fxFyvso4hzgmJ9rcetlq5bj3+W829ZTxFQK/MFvy3N7KRZYjWanehEHVkwcOtSagwfaKsf9YrNNlpBRtWjZZdsnC9iUlfDJp0xdjKu5Y1FH/S61b/356DqiHI1vhzpwruoen95pV1mj5Mb65wr3ic/T00GwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KE2W9Gwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KE2W9Gwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64185C2BCB0;
	Mon, 13 Apr 2026 16:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096977;
	bh=f1CIRpe5dKiQ1G4RmG6XWIE3wDgaiaPQpv68Jjhu6q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KE2W9GwetmXFD7RfmWKvs9YC/fafSEuWGfNHYg9og/nPDMqj5YdPv4xOn2feyvIA/
	 pvV8Tar3So0CCw/eoCnpAEFk6LGvwtAnYAnzQRWHJqNixtxrrFF8KpISAucD5anaMl
	 aCNMLt93Too6RpDh5X1YXWQUO0bEy6NnKdhKpi0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishal Thanki <vishalthanki@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 02/55] wifi: rt2x00usb: fix devres lifetime
Date: Mon, 13 Apr 2026 18:00:36 +0200
Message-ID: <20260413155724.915939779@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 25369b22223d1c56e42a0cd4ac9137349d5a898e upstream.

USB drivers bind to USB interfaces and any device managed resources
should have their lifetime tied to the interface rather than parent USB
device. This avoids issues like memory leaks when drivers are unbound
without their devices being physically disconnected (e.g. on probe
deferral or configuration changes).

Fix the USB anchor lifetime so that it is released on driver unbind.

Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
Cc: stable@vger.kernel.org	# 4.7
Cc: Vishal Thanki <vishalthanki@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260327113219.1313748-1-johan@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -830,7 +830,7 @@ int rt2x00usb_probe(struct usb_interface
 	if (retval)
 		goto exit_free_device;
 
-	rt2x00dev->anchor = devm_kmalloc(&usb_dev->dev,
+	rt2x00dev->anchor = devm_kmalloc(&usb_intf->dev,
 					sizeof(struct usb_anchor),
 					GFP_KERNEL);
 	if (!rt2x00dev->anchor) {


