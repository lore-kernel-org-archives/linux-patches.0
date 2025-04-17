Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C11B3934;
	Thu, 17 Apr 2025 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916096; cv=none; b=cxfCIKJmA5HVKun4gG3xdNclUTsiXApe1MjKi3uB4MY1sDNDtFPFqC8go0PUg7ygkfIW5SHIVnFm7f+7tXaGE07gUkbTPd7htxaJQUz9B5Ijtcpo2hBWW3Na/J8W9QoZEk2r7kg69QiCiNqmcfPd8XKFVa6Ql4zC33QwQnTVjjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916096; c=relaxed/simple;
	bh=zG72XAu77wjqfxDkDU4uD9UU+/mLJwkcfERbLg0dEZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS9TrMPdA1Pg2KB2FS62Jt3EzDPf6ZvbIG+Te9JVOazAlzR/+DAmyptxCQPlaYATy3sUmmEfcYlfbeLJMzlJVriOEWPbPpA7NKZBMXIHnC3xnNvqlVKo1OfkBhI5IIBXWl6y2Emdxi00MLGA95Ix9/CsYEedZ4KxI4iHMZG94Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wI49j1Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wI49j1Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D719BC4CEE4;
	Thu, 17 Apr 2025 18:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916096;
	bh=zG72XAu77wjqfxDkDU4uD9UU+/mLJwkcfERbLg0dEZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wI49j1TzvlXV/KL+JskVMHCAjOOfqpiATFG6x/FlQ3znT8uUhGicVE12IwseDlZa+
	 tM8+dMmVSDA8nGeHabd2yDRkY+NsDdQ1ZdlEO5DiJdnL/rW60t3RgNXAYqIv2kmTEg
	 P/+RIg+3eZR0SDYs44ki/t507QI9VAzT/rTDK0k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 341/393] gve: handle overflow when reporting TX consumed descriptors
Date: Thu, 17 Apr 2025 19:52:30 +0200
Message-ID: <20250417175121.316927274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -392,7 +392,9 @@ gve_get_ethtool_stats(struct net_device
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


