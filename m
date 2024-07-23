Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF75158A01;
	Tue, 23 Jul 2024 18:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759193; cv=none; b=M0eQKd+dRWX88XKjZU4lvhg0gUIPOrEx3x3S0aAulgzzaYTghDIqRvJlUlv9iCfrRZXjCWFCKj+rVCWZon5moK49wRPHRkXxbuUdzFMmaU/FX405TSY6dzj1VXd4sIoaHzDrIPKmmVzp9RlywGoTcFjQm/HL0OkAxKY6K32TMa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759193; c=relaxed/simple;
	bh=rfJ5d00IgqzvV8Uvag12RfRQrqHmZr5GlMS0VQMGQjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbRMErWCbHZkX6ZbEwR+MCnykr+VmDqO5kXZ0LcxBvzoms3kjp3Fow4dkSwMG8PxTRgG8FUATXfISirprqTdpuS++BIuhnDRaSqyt/W4/B5I7DcaynMwyKOc44Jk28micbDq3ohmfIvDVnydNhX16WW5ekpDCtkdDcJRvVBy7j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjYPdlsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjYPdlsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7502C4AF09;
	Tue, 23 Jul 2024 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759193;
	bh=rfJ5d00IgqzvV8Uvag12RfRQrqHmZr5GlMS0VQMGQjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjYPdlsYKFkearwFeVE17+IfLFXmC0JsLqyMylocS+RXNzHXrN6FmQ/vxa475C664
	 H2L8eym34EogmUxjwq3yHfHpGocwo4Z3iktkSNH2FhhaZwyGKU41ltbsqKUH00xNAJ
	 I/PV1wjPWZYnNBrXv2fmyBCH6fH+mRQzcU6Qcvc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/105] wifi: mac80211: fix UBSAN noise in ieee80211_prep_hw_scan()
Date: Tue, 23 Jul 2024 20:23:03 +0200
Message-ID: <20240723180404.082306018@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 92ecbb3ac6f3fe8ae9edf3226c76aa17b6800699 ]

When testing the previous patch with CONFIG_UBSAN_BOUNDS, I've
noticed the following:

UBSAN: array-index-out-of-bounds in net/mac80211/scan.c:372:4
index 0 is out of range for type 'struct ieee80211_channel *[]'
CPU: 0 PID: 1435 Comm: wpa_supplicant Not tainted 6.9.0+ #1
Hardware name: LENOVO 20UN005QRT/20UN005QRT <...BIOS details...>
Call Trace:
 <TASK>
 dump_stack_lvl+0x2d/0x90
 __ubsan_handle_out_of_bounds+0xe7/0x140
 ? timerqueue_add+0x98/0xb0
 ieee80211_prep_hw_scan+0x2db/0x480 [mac80211]
 ? __kmalloc+0xe1/0x470
 __ieee80211_start_scan+0x541/0x760 [mac80211]
 rdev_scan+0x1f/0xe0 [cfg80211]
 nl80211_trigger_scan+0x9b6/0xae0 [cfg80211]
 ...<the rest is not too useful...>

Since '__ieee80211_start_scan()' leaves 'hw_scan_req->req.n_channels'
uninitialized, actual boundaries of 'hw_scan_req->req.channels' can't
be checked in 'ieee80211_prep_hw_scan()'. Although an initialization
of 'hw_scan_req->req.n_channels' introduces some confusion around
allocated vs. used VLA members, this shouldn't be a problem since
everything is correctly adjusted soon in 'ieee80211_prep_hw_scan()'.

Cleanup 'kmalloc()' math in '__ieee80211_start_scan()' by using the
convenient 'struct_size()' as well.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Link: https://msgid.link/20240517153332.18271-2-dmantipov@yandex.ru
[improve (imho) indentation a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 933d02d7c1284..62c22ff329ad4 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -733,15 +733,21 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			local->hw_scan_ies_bufsize *= n_bands;
 		}
 
-		local->hw_scan_req = kmalloc(
-				sizeof(*local->hw_scan_req) +
-				req->n_channels * sizeof(req->channels[0]) +
-				local->hw_scan_ies_bufsize, GFP_KERNEL);
+		local->hw_scan_req = kmalloc(struct_size(local->hw_scan_req,
+							 req.channels,
+							 req->n_channels) +
+					     local->hw_scan_ies_bufsize,
+					     GFP_KERNEL);
 		if (!local->hw_scan_req)
 			return -ENOMEM;
 
 		local->hw_scan_req->req.ssids = req->ssids;
 		local->hw_scan_req->req.n_ssids = req->n_ssids;
+		/* None of the channels are actually set
+		 * up but let UBSAN know the boundaries.
+		 */
+		local->hw_scan_req->req.n_channels = req->n_channels;
+
 		ies = (u8 *)local->hw_scan_req +
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
-- 
2.43.0



