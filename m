Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBCA23C51D;
	Mon, 17 Aug 2026 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977677; cv=none; b=cyWPVVepLej0i4JAVxQj0n7KljycAwijgWP1bOsLhaVJzqLftm/Ra61gJljYXtYW1iHaS8vj4ecXs09/6E8c4T7ZuEgFqeh7S6VbWUw+yAmZXNwFuf69guM1Pt6EOpNcFC7TkVl556sOjHqq3rye9/A5N5V0oSZkuY8mZq8D5WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977677; c=relaxed/simple;
	bh=fXmBP0b4EWDpOb6DFu6SD3wzgC9mllcD3LDRISp97Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krqj5hmcc0Ae82H6lud0j0tVn3QRlwnRWBRbwE4V5NfPZoXNI9RDGtK3rWkFIdCbOd3r9I3ujM/Lmoh7/xk29ZL1myP/nCl9xG/INJQ1LUBydNgc5Q1N1Sg7VrkdoHErawRPQ5npYoJbVsnau/J0qj6RnqzYT97zF65cvjujtqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPnzxxMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPnzxxMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795AC1F000E9;
	Mon, 17 Aug 2026 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977676;
	bh=cvAtFT6KXovSMTuMHXvZcleHPpzUpxnmDbP4Sp1iOm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPnzxxMsA75ZWGPnzRi3hQKbMYJv8mHZjZ+U6BKpGJHVmN2egPbi/lKMEuXl8fvAH
	 soBjZAmO/Aq6KWiefHfaoKAfwI5aWJuPiQo1Ju6FQNfBW/6+BHP+ZMvLgJijxs9IjF
	 xOxshiXrKLgbn+TZxOfFTdgzJ+Bo0lyzDOBUjCB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sergey V. Frolov" <Sergey.V.Frolov@kaspersky.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 412/456] net: octeontx2-pf: Fix UB in shift operation
Date: Mon, 17 Aug 2026 15:33:22 +0200
Message-ID: <20260817132555.362639631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Sergey V. Frolov <Sergey.V.Frolov@kaspersky.com>

commit 7e2d693af0d4c05bddccb3541a0aabd69f4cb244 upstream.

In function otx2_get_egress_burst_cfg, when the parameter `burst` is
255 and the max mantissa is 255 (0xFFULL), `burst_exp` is set to
`ilog2(255) - 1`, which equals 6.

This results in an unsigned wrap-around when calculating
`(1ULL << (*burst_exp - 7))`, since `*burst_exp - 7` becomes -1,
which makes the shift operand 0xFFFFFFFF. This value is greater than
the width of the left operand.

According to standard 6.5.7 p.3:
"The type of the result is that of the promoted left operand.
If the value of the right operand is negative or is greater than
or equal to the width of the promoted left operand, the behavior
is undefined."

Fix the off-by-one boundary condition.

Add a WARN_ON(*burst_exp < 7) before the else branch as an
explicit safeguard. This ensures that if max_mantissa ever changes
in a way that reintroduces this condition, it will be immediately
caught at runtime rather than silently triggering UB.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e638a83f167e ("octeontx2-pf: TC_MATCHALL egress ratelimiting offload")
Signed-off-by: Sergey V. Frolov <Sergey.V.Frolov@kaspersky.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Goutham <sgoutham@marvell.com>
Link: https://patch.msgid.link/20260804120446.1955448-1-Sergey.V.Frolov@kaspersky.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -105,10 +105,12 @@ static void otx2_get_egress_burst_cfg(st
 	if (burst) {
 		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
 		tmp = burst - rounddown_pow_of_two(burst);
-		if (burst < max_mantissa)
+		if (burst <= max_mantissa) {
 			*burst_mantissa = tmp * 2;
-		else
+		} else {
+			WARN_ON(*burst_exp < 7);
 			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
+		}
 	} else {
 		*burst_exp = MAX_BURST_EXPONENT;
 		*burst_mantissa = max_mantissa;


