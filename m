Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA93E439009;
	Mon, 17 Aug 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978091; cv=none; b=OmJgJ3jBgw2qyvdJ8igZpQFUjMXnSgbPRFTlE4vlfrZC+ZNQgFYtrB+thdSwxA/y3SkFJW2jdueWKVjQgrB7NioTWO8I/KSGjN5xIQMY+G64FCxT4WvyB7+X8qQddeka6gwceHXy09m00+z6Zo6AEd5rs0paobr5Rt50hTBAo0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978091; c=relaxed/simple;
	bh=Fc4rjnM4118RX4vv4wq8lbBY0CADhAlY8oBARHS9jkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KY1cRrXILPgol2Jp6sSBBHTKIdDZAcdGtbmLIRYpDrQM5Sk75L+vHDtw4Es2/MKdeCUl5oofzIt/b0BEmKSTTAUBPRX7QW7xlNd5nisjD7/xHAas31rECLsTZY2J6PxpQ9lVgI168Ud782lJZFQwIHU3ZeKEn9EiphhBxxAj1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh+phN7n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh+phN7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F961F000E9;
	Mon, 17 Aug 2026 14:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978088;
	bh=wra2bMxBeKknolsQxFW5bxKLK4zO5pXpjIhAsL8/kb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eh+phN7nph/1CwqtPBzH8y44WsfMdyygc5QFD7nzSINHWOkNpjlJGgykKivcZVlxg
	 yIpD9gFYkoCmJ16XuZs6xSHbKNpqY8/zVB1BiCcfDcAktup/bhJ3uOsVr6mqRoOuNv
	 zd8ey72utJ+9BILDcmU2R5/S8yCJMnrr6RKlj9DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Sergey V. Frolov" <Sergey.V.Frolov@kaspersky.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 097/181] net: octeontx2-pf: Fix UB in shift operation
Date: Mon, 17 Aug 2026 15:33:11 +0200
Message-ID: <20260817132539.274311745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -78,10 +78,12 @@ static void otx2_get_egress_burst_cfg(st
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


