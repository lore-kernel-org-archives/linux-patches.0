Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605BD340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301019; cv=none; b=aNHWHFIfnxwbPfPcQeAqKVhrEMssWUB0e7yPla2YdoUjIKY+ZVAwL/cO4Xo+UQWGC3GXQm6IbGR4rRVleu56aFh5bNSMwuR/mGxmtcFzo7cPDQ52XfmezqMJoH8rZcFd6wYA58G9aaYix4qMfDM+NguG9jE8ZxLoW27qQElsJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301019; c=relaxed/simple;
	bh=TYqVDXtQ0/PIYnUvVHVN5F6H+dM+ladLlhiwnGNLqp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA6D7beLvSQWMHBhZjdrdCVcaTcyi3nfe7zQ6iAAnzZo30ynSDbSagitNFNg5CDYpAsMH9TdDlnr9Wz5YZSKF1XB0TzKVpZfJCIrSb6bUH49nnW1rMb6nCjN0gCix055/wI+yufSA0MoRyU5xkF8fdWwxbJW07sjIRG5GQuOR0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t3uq5WKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t3uq5WKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97494C19424;
	Sat, 28 Feb 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301019;
	bh=TYqVDXtQ0/PIYnUvVHVN5F6H+dM+ladLlhiwnGNLqp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t3uq5WKrY0KE2XrKX4Zdzdw7Y5rgacRZAoa3bwDU8zCna/x82+s+faqtklRz758g9
	 YE0EyQ3yrwm+mBsGBb4Ud8dD1/vHtoapyk1vwTpHU4dnQigcdaICg0T57ZOV23eAq3
	 /Y87vIsYIBzwiVR/x0jMudNlw+RQSYLjjoxLNev5cHi2pSo60NNmLeZD6m9LUpPypQ
	 ZNchEpl9v3+E1vlBjAC9elicB59Zk2pwlN++kjdM2rkVG1UCWGBuyMgaM50p6jr6o5
	 4WDDQm9HKO8/PODoFdRwzQZwYvuH67ejJCLPU1ZVa56GDh4aFftTmCDdrmF7GhRMZ/
	 gSvxCXea/TLPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Szymon Wilczek <szymonwilczek@gmx.com>,
	syzbot+405dcd13121ff75a9e16@syzkaller.appspotmail.com,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/752] media: pvrusb2: fix URB leak in pvr2_send_request_ex
Date: Sat, 28 Feb 2026 12:37:46 -0500
Message-ID: <20260228174750.1542406-155-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Szymon Wilczek <szymonwilczek@gmx.com>

[ Upstream commit a8333c8262aed2aedf608c18edd39cf5342680a7 ]

When pvr2_send_request_ex() submits a write URB successfully but fails to
submit the read URB (e.g. returns -ENOMEM), it returns immediately without
waiting for the write URB to complete. Since the driver reuses the same
URB structure, a subsequent call to pvr2_send_request_ex() attempts to
submit the still-active write URB, triggering a 'URB submitted while
active' warning in usb_submit_urb().

Fix this by ensuring the write URB is unlinked and waited upon if the read
URB submission fails.

Reported-by: syzbot+405dcd13121ff75a9e16@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=405dcd13121ff75a9e16
Signed-off-by: Szymon Wilczek <szymonwilczek@gmx.com>
Acked-by: Mike Isely <isely@pobox.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index b32bb906a9de2..5807734ae26c6 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -3709,6 +3709,11 @@ status);
 				   "Failed to submit read-control URB status=%d",
 status);
 			hdw->ctl_read_pend_flag = 0;
+			if (hdw->ctl_write_pend_flag) {
+				usb_unlink_urb(hdw->ctl_write_urb);
+				while (hdw->ctl_write_pend_flag)
+					wait_for_completion(&hdw->ctl_done);
+			}
 			goto done;
 		}
 	}
-- 
2.51.0

