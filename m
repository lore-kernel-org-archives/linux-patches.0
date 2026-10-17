Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04642E555;
	Sat, 17 Oct 2026 17:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258504; cv=none; b=ddOmfkDo3kc/inrdj6BtaToBrOkbHVi/OU/Q/ZhLmFCCOHK4cwbwDxm8LjaVcjdsdWvCLEIBk2R8TxYTmr0tB69KCYgS2lQOfOw66h0s5jsJ8OY6y13ipYNw6CAc6K9J1uuZ9ApKVNa/vkct/8CaLgkQZUcMzH6gbr/MXeSN4q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258504; c=relaxed/simple;
	bh=H4eDfisShgpEW8XVr+eXO43BlESuMLMuMroIQCXTbX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zrc3EKiPLmrOwb+cGQbhRzNnqaUygQ9vH5vY7ks7c5j1CAyAylB9Nuc9oqZnJMlKDBbbaTb6T8oXOVmpCLNZP9sDo3W73PW/kvj+l2Erh6Dmy2q/mWM2p6KiHLpnRbqYIuTF7JNyKzKpsNUF6Q+owvCXc2ZtF5ug3yMP22pB0Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdZ+MgmC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdZ+MgmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FD51F000C4;
	Sat, 17 Oct 2026 17:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258502;
	bh=X5htLEMbaxTx4Yvgs92YxF9O0GjxJdrF8sRtVYzs8EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdZ+MgmCMrxkRtabwvXlWBKmadQFTCkFUVOYuI448dy/pVoZJ4LIWMm16Z3+qsSos
	 lFX/8MfwBs69A5h8i6pTtS/rLVBwP8WTRjMfgScEH/tVyV1n2NAppqqnvMCU6nd93f
	 Z9W2QSFN3s/Dhoc8w2aJ12RqaHrF0qt5b2IxfTvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0906/1674] HID: core: Mitigate potential OOB by removing bogus memset()
Date: Sat, 17 Oct 2026 17:52:58 +0200
Message-ID: <20261017160454.385847535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 0a3fe972a7cb1404f693d6f1711f32bc1d244b1c ]

The memset() in hid_report_raw_event() has the good intention of
clearing out bogus data by zeroing the area from the end of the incoming
data string to the assumed end of the buffer.  However, as we have
previously seen, doing so can easily result in OOB reads and writes in
the subsequent thread of execution.

The current suggestion from one of the HID maintainers is to remove the
memset() and simply return if the incoming event buffer size is not
large enough to fill the associated report.

Suggested-by Benjamin Tissoires <bentiss@kernel.org>

Signed-off-by: Lee Jones <lee@kernel.org>
[bentiss: changed the return value]
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a7ad90bce2995..9607ec8b149e8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2049,9 +2049,9 @@ int hid_report_raw_event(struct hid_device *hid, enum hid_report_type type, u8 *
 	}
 
 	if (csize < rsize) {
-		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
-			csize, rsize);
-		memset(cdata + csize, 0, rsize - csize);
+		hid_warn_ratelimited(hid, "Event data for report %d was too short (%d vs %d)\n",
+				     report->id, rsize, csize);
+		return -EINVAL;
 	}
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
-- 
2.53.0



