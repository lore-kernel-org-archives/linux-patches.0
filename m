Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FBF2798E3;
	Wed, 23 Apr 2025 15:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421539; cv=none; b=OF3oNJN4iArfFI4dU0lluAN3imMFzveTNrpI1big68fPnTYFFFFHqa4Zpy01VOeVPkIJ3zyEP3rQnYUGGInOy880sajN/13RYlKyKsPZvpxFLYUfzM5k9+DeQ5gNH33oxXKlct6qI8QQCC+i9ibPB3n18FL8vOKCBjPgEBwBWnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421539; c=relaxed/simple;
	bh=NTrhA1LC68tM7w4YInmesCQ4dRqESnYOb0Ril3YTrR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iS34CymEgHK49Q+KydMXp2auG9ZGlPLgQzNzCNb1sgMToP+fFHvI2Q7WwaqQngGMfV7WUnBaTSQosz34WdNXJ87MM5w323d4FVbHYLKFX8oUeC8AgGaKm2V+ZlkRS8LgV71Uo3g7mBNHdrfcEXPOW+CW/e13vzjWfi5SjXieOo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQDZ1LRt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQDZ1LRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34728C4CEE3;
	Wed, 23 Apr 2025 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421539;
	bh=NTrhA1LC68tM7w4YInmesCQ4dRqESnYOb0Ril3YTrR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQDZ1LRtL1CfkpFm/GwScHOtc+kjTJVBw7Qki1uuji2muyCJbDj60quUyVqFE+8bN
	 bmpPYNhT51+CvuzWnLgPltmByx0URdfEgPtJwhVyoDeyaFwvRd/P4bfhbgttWCj89Q
	 hrR7m8oZ7THtr+mV+QyJL0M7jtD2Jy5Er6sfIDDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 148/291] gve: handle overflow when reporting TX consumed descriptors
Date: Wed, 23 Apr 2025 16:42:17 +0200
Message-ID: <20250423142630.448146254@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joshua Washington <joshwash@google.com>

commit 15970e1b23f5c25db88c613fddf9131de086f28e upstream.

When the tx tail is less than the head (in cases of wraparound), the TX
consumed descriptor statistic in DQ will be reported as
UINT32_MAX - head + tail, which is incorrect. Mask the difference of
head and tail according to the ring size when reporting the statistic.

Cc: stable@vger.kernel.org
Fixes: 2c9198356d56 ("gve: Add consumed counts to ethtool stats")
Signed-off-by: Joshua Washington <joshwash@google.com>
Signed-off-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250402001037.2717315-1-hramamurthy@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -327,7 +327,9 @@ gve_get_ethtool_stats(struct net_device
 				 */
 				data[i++] = 0;
 				data[i++] = 0;
-				data[i++] = tx->dqo_tx.tail - tx->dqo_tx.head;
+				data[i++] =
+					(tx->dqo_tx.tail - tx->dqo_tx.head) &
+					tx->mask;
 			}
 			do {
 				start =


