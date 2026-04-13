Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C3549620;
	Mon, 13 Apr 2026 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097456; cv=none; b=biPBu7W2J7aPmfdfThRAI2IIu8kq9AFj76XNOZPP1HRj9wSd87hAiFAATY4IhrHUSLa8yKH8Qi9Z33YpxRBwsPuqDWtn7dwib/RguuyFkuD2PJJa3MFTXz3Yv6F+MNFiRBqAB0qScYlHgqwQxyLL5Ptv1yWZ/6pTy5jxA/tqy5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097456; c=relaxed/simple;
	bh=mVTMNdHRbtAPU0ASXL8jojR4xkbFdUdDH7y6gd0b1+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfGSwrBJGJF6sg0ZypBh/1WiDnir/ITnfvEAqasMZbMg240Gk6ZjjhKt/x1QKT0BMeCCivubHo90VnIQ1noozmgmEDCkiCWrRWZ4uhFmOtLvaJ0/ijf4JpeNH/VUwHHqapFAGJrvitar7Gh/Mk/vt4idwu7xkxUsdX4wXp815nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1Nn7UMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1Nn7UMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89587C2BCAF;
	Mon, 13 Apr 2026 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097455;
	bh=mVTMNdHRbtAPU0ASXL8jojR4xkbFdUdDH7y6gd0b1+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1Nn7UMPmsjr0TCfy+Kv5WMtE7ieg11DARLuU/tXFoifZkb204QGNVTfNGWFMUO67
	 gD+D7r84HB+2z8khDkDb/mOgiO6P8nom+MdzacA+l71/5XvCUJYHYH3Ll91YHvE/To
	 FOPfz5uzA60qpqu3wl3y9X0HJ3qQclnHZMMJBXYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	Gui-Dong Han <hanguidong02@gmail.com>
Subject: [PATCH 5.15 143/570] usb: class: cdc-wdm: fix reordering issue in read code path
Date: Mon, 13 Apr 2026 17:54:34 +0200
Message-ID: <20260413155835.799835491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 8df672bfe3ec2268c2636584202755898e547173 upstream.

Quoting the bug report:

Due to compiler optimization or CPU out-of-order execution, the
desc->length update can be reordered before the memmove. If this
happens, wdm_read() can see the new length and call copy_to_user() on
uninitialized memory. This also violates LKMM data race rules [1].

Fix it by using WRITE_ONCE and memory barriers.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Closes: https://lore.kernel.org/linux-usb/CALbr=LbrUZn_cfp7CfR-7Z5wDTHF96qeuM=3fO2m-q4cDrnC4A@mail.gmail.com/
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260304130116.1721682-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -225,7 +225,8 @@ static void wdm_in_callback(struct urb *
 		/* we may already be in overflow */
 		if (!test_bit(WDM_OVERFLOW, &desc->flags)) {
 			memmove(desc->ubuf + desc->length, desc->inbuf, length);
-			desc->length += length;
+			smp_wmb(); /* against wdm_read() */
+			WRITE_ONCE(desc->length, desc->length + length);
 		}
 	}
 skip_error:
@@ -533,6 +534,7 @@ static ssize_t wdm_read
 		return -ERESTARTSYS;
 
 	cntr = READ_ONCE(desc->length);
+	smp_rmb(); /* against wdm_in_callback() */
 	if (cntr == 0) {
 		desc->read = 0;
 retry:


