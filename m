Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6052EB5A6;
	Tue, 12 May 2026 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608391; cv=none; b=lLkNt/M9sJMrXrNgrONqgWK4Kwcqz+iTBNz3EePU7CaeObFnIB/RM3FBs0mVBhufXX/sMA7Ci8unk7LoErSoSL4nup1m6VUX+PVRh1ksWXQzjEI9xoxbAu+6CEKtrKwXgvB+s65qwJQc0WMgPZu46LDtsJM9yv4kqUa5KcvQQYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608391; c=relaxed/simple;
	bh=Nw4dpsvHqbwUjVKYT5UtrCa5lqMxkMZCXIXCfkVjcvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oemeFK8SGk+JhRXafDbTj8W+gjMOiMzrkUUt0gnCBbci36MgH9I2Be4AoHf3w1FhSXjhpVEGrua1UFprTN7EQIJCLkkGegfhSJDrXbdlDhn5jQUjGeewGciXA6Th2ZOs2fv1vy6QW0wpLiiEK+tE7JY9zyC0Z13VJekMk1Nq8Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leF5i3Mk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leF5i3Mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51980C2BCB0;
	Tue, 12 May 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608391;
	bh=Nw4dpsvHqbwUjVKYT5UtrCa5lqMxkMZCXIXCfkVjcvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leF5i3MkWGyff1I3hoBwDTbp8E7u63BDmwQbKQM4rUM8WS9bQjQomYqedUed6Z4v0
	 USBdgWXDLwU23Wrv0tUPg1XKtOGGuYLIEIlPSPdIDZlo5p2scCHkt7MwiwEQvzZFjT
	 iA0y3KY9Hh1wd6fAGxkId5sdKS7v5yqFcnGVJ0bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Vincent Danjean <vdanjean@debian.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 034/270] wifi: ath5k: do not access array OOB
Date: Tue, 12 May 2026 19:37:15 +0200
Message-ID: <20260512173939.173655175@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

commit d748603f12baff112caa3ab7d39f50100f010dbd upstream.

Vincent reports:
> The ath5k driver seems to do an array-index-out-of-bounds access as
> shown by the UBSAN kernel message:
> UBSAN: array-index-out-of-bounds in drivers/net/wireless/ath/ath5k/base.c:1741:20
> index 4 is out of range for type 'ieee80211_tx_rate [4]'
> ...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x5d/0x80
>  ubsan_epilogue+0x5/0x2b
>  __ubsan_handle_out_of_bounds.cold+0x46/0x4b
>  ath5k_tasklet_tx+0x4e0/0x560 [ath5k]
>  tasklet_action_common+0xb5/0x1c0

It is real. 'ts->ts_final_idx' can be 3 on 5212, so:
   info->status.rates[ts->ts_final_idx + 1].idx = -1;
with the array defined as:
   struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
while the size is:
   #define IEEE80211_TX_MAX_RATES  4
is indeed bogus.

Set this 'idx = -1' sentinel only if the array index is less than the
array size. As mac80211 will not look at rates beyond the size
(IEEE80211_TX_MAX_RATES).

Note: The effect of the OOB write is negligible. It just overwrites the
next member of info->status, i.e. ack_signal.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Reported-by: Vincent Danjean <vdanjean@debian.org>
Link: https://lore.kernel.org/all/aQYUkIaT87ccDCin@eldamar.lan
Closes: https://bugs.debian.org/1119093
Fixes: 6d7b97b23e11 ("ath5k: fix tx status reporting issues")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251209100459.2253198-1-jirislaby@kernel.org
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1738,7 +1738,8 @@ ath5k_tx_frame_completed(struct ath5k_hw
 	}
 
 	info->status.rates[ts->ts_final_idx].count = ts->ts_final_retry;
-	info->status.rates[ts->ts_final_idx + 1].idx = -1;
+	if (ts->ts_final_idx + 1 < IEEE80211_TX_MAX_RATES)
+		info->status.rates[ts->ts_final_idx + 1].idx = -1;
 
 	if (unlikely(ts->ts_status)) {
 		ah->stats.ack_fail++;


