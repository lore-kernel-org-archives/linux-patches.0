Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042624;
	b=bDJBknocpO19tXK7X+E+Ri8hh03mrcGnb3D0nGS9Da93G4Zg/TQCP+VbtxJflJnHlhXb
	 /B/8aahMX4HVyPtjovzskLG6GYIzavzYnDJxiVu4qiElCpbprmOsOoygxIkxBtqibEFh8
	 KJD3wGqzPEXu8H96c0ist8PHYpMyid7KjWWBRZGGDzcHsEeaj3lr791TeOlU9Wz1LhMaO
	 e2OwYf7oihqoF9EFckKN+gJAUeSWT2TlPMeGRRLWrZDFlaS3tr4duJyIWwpAq1gFx504k
	 dMYjAay8k0Qv1xH3P7GYRBsILGNhZ9Bt1mhqVilf6UVmgmRr/7uVhyZRtiiB949t1Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KRZBmYL4vvlCu0cy73P10AU6bo295Q7RUx3UZOdsc34=;
	b=q06r20a9GEiaOBRYBov64shCOJISoi2AQaxD83pXeRWy+TlmcNPc35qgXmBYhE+BR1bn
	 d2Gf0JG5U8G+6vTPsUS/GwRs33HOa9mCAyzcq2Zm6gv0r7X+mQ4CGCa6M52WC/6dWK0w9
	 DBVclh8S9QJO/5um+Dsok5Lj+lSHpreupNBw62JAuCyVO1+21BbfSXAiMm7RCMKxMZf7h
	 szlng4XXya3tfTrCih4ugcjiyp2Bz2D6ZadbcL5N4yemGJArLxVsTNpzkWxR7mICb5kPU
	 Gr+JxdS6H7HkYWEORUCFTtpQf6Fpj3TXHrE7N/ImNZTb9BuXJFu7fF4PJILmINikHGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/DW4OGK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0A5606A325;
	Wed, 18 Nov 2026 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/DW4OGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31421F000C4;
	Wed, 18 Nov 2026 22:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042624;
	bh=KRZBmYL4vvlCu0cy73P10AU6bo295Q7RUx3UZOdsc34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/DW4OGKotPkf53WSYfkhZRC9EUDYWqeVl+I4dvycNv+rUFs+P94ldasshjihGrLh
	 RxmSOOiRE33em7bIb5NyBz0p2cYY/Vp1XFpkuKo7H3Y2N43PYrAFHgaUvtTjRo+xYG
	 wZdbCkFzvYPE6N1RChiQY7o7dCYJjOhnQs9EP18c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3236/3318] ice: set in_use only after preparing Tx timestamp index
Date: Wed, 18 Nov 2026 16:04:18 +0100
Message-ID: <20261118150456.772528822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 50870d62116038e6f1e17a6aedcf2a95cec37ec7 ]

The ice_ptp_request_ts() function is used to request a timestamp index for
use with a packet. When reserving an index, it sets the start time and
saves a pointer to the skb into the appropriate index. The function marks
the in_use bit first before doing any of these steps. The IRQ handler which
clears the timestamps reads the in_use bits uses a lockless flow for
reading the in_use bits to determine which ones are in-use. This is
necessary as actually processing a complete timestamp must be able to sleep
so we cannot hold the timestamp tracker lock over the entire sequence.
Additionally, blocking the Tx hotpath with such a lock indefinitely would
be problematic.

However, the existing flow now has a very narrow window where the IRQ
handler could see a timestamp as in-use but read a stale value for its
"start" time.

Fix this by ordering the sequence to mark the in_use bit last, and add a
memory barrier to prevent re-ordering of the previous writes to setup the
index.

This was found and reported by Sashiko while reviewing an unrelated change.

Closes: https://sashiko.dev/#/patchset/20260821-jk-e825c-minimized-fixes-v1-0-9d0731eb4858%40intel.com?part=7
Fixes: ea9b847cda64 ("ice: enable transmit timestamps for E810 devices")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261027-reduction-v1-2-81237c67a361@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index df88304c9a1b1..8427b36bd8b55 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -696,6 +696,12 @@ static void ice_ptp_process_tx_tstamp(struct ice_ptp_tx *tx)
 		bool drop_ts = !link_up;
 		struct sk_buff *skb;
 
+		/* Paired with smp_mb__before_atomic() in ice_ptp_request_ts()
+		 * to ensure ordering the in_use bitmap and the indexed fields
+		 * in the tstamps array.
+		 */
+		smp_rmb();
+
 		/* Drop packets which have waited for more than 2 seconds */
 		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
 			drop_ts = true;
@@ -2473,11 +2479,13 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 		 * a reference to the skb and the start time to allow discarding old
 		 * requests.
 		 */
-		set_bit(idx, tx->in_use);
-		clear_bit(idx, tx->stale);
 		tx->tstamps[idx].start = jiffies;
 		tx->tstamps[idx].skb = skb_get(skb);
 		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		clear_bit(idx, tx->stale);
+		/* Ensure index is setup before marking it as used */
+		smp_mb__before_atomic();
+		set_bit(idx, tx->in_use);
 		ice_trace(tx_tstamp_request, skb, idx);
 	}
 
-- 
2.53.0



