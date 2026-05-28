Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534DC24A047;
	Thu, 28 May 2026 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999434; cv=none; b=XSR4EJeW7xm4ekh30ubfIC4D8ouuPaJYnrrKdnoF6DCa2Dlz49CwkuJJ+xkQ0PNvineMsW509wD49yaBeEa+E1BwqzijI2JlBs3Pmk2oXS9RPqyVfa4idJTrO03PY698erAFiNWygKWc+7Ja/g1YNggwalFxvs58DqopZDqc1fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999434; c=relaxed/simple;
	bh=s+X75Aku/hlmv3/bAZLp9cqrlzoWEFm4fbqde+iXGfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu8wQp23K96of5VAGyPvMLuB2Mbqf4cTBpJHLLXzQIyJrE20/Ycq6hbbA/nD8RB6lqGzhX4i52hQXcJlKO6UM5PDZkBXzfbVziVd5NtIQMkhb6HbgcdslcEK9qlCTukGg0jFOVLMyWnPdsRs9wQgv2Dg0+reVCL8KtYTQvXRwpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/km+8er; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/km+8er"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16FD1F000E9;
	Thu, 28 May 2026 20:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999433;
	bh=90SYLBPWQXIoRMsfGOuAhFitMjm96cwr6nrG0uMUeEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/km+8er1g58JPfU5Pqd2Paw6MPD5FremSs1PtISGxYc5Xa3o+1rvDCq6X6ZaBAsC
	 hA0yah7Pd4MO8JFwRfwawhGUp6rs7aoXD/OTShSSUHhyRhcVfS/Sdco4TMhv2g9Zk6
	 smmeUQ1YjzOHly57iOvklNeiH038rREEGICI1L/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Jelonek <jelonek.jonas@gmail.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 064/377] net: pse-pd: fix sign on -ENOENT check in of_load_pse_pis()
Date: Thu, 28 May 2026 21:45:02 +0200
Message-ID: <20260528194640.218715444@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jonas Jelonek <jelonek.jonas@gmail.com>

commit 33d35975cbead3fa6b738ee57e5e45e14fbe0886 upstream.

of_count_phandle_with_args() returns the count on success and a negative
errno on failure, including -ENOENT when the "pairsets" property is
absent. The existing comparison in of_load_pse_pis() checks against
ENOENT (positive 2) instead of -ENOENT, so the branch is taken for any
error return: legitimate DTs that omit "pairsets" trigger a spurious
"wrong number of pairsets" error and probe fails with -EINVAL.

Compare against -ENOENT so a missing "pairsets" property is correctly
treated as "this PI has no pairsets, continue".

Fixes: 9be9567a7c59 ("net: pse-pd: Add support for PSE PIs")
Cc: stable@vger.kernel.org
Signed-off-by: Jonas Jelonek <jelonek.jonas@gmail.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260515143103.1721888-1-jelonek.jonas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pse-pd/pse_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pse-pd/pse_core.c
+++ b/drivers/net/pse-pd/pse_core.c
@@ -210,7 +210,7 @@ static int of_load_pse_pis(struct pse_co
 			ret = of_load_pse_pi_pairsets(node, &pi, ret);
 			if (ret)
 				goto out;
-		} else if (ret != ENOENT) {
+		} else if (ret != -ENOENT) {
 			dev_err(pcdev->dev,
 				"error: wrong number of pairsets. Should be 1 or 2, got %d (%pOF)\n",
 				ret, node);


