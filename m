Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFC3A6B82;
	Fri,  4 Sep 2026 05:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498608; cv=none; b=mvFIqBCEmxKOO62gJvFU0prw4WR/EmaZsCB60qzeQ5LofYlGVN4K5jUUrdCv6Hn6CFCyVhPuFovDZUMP1wF/cCAIPg/vquR76WHNmQzx7+YxN12LXLbt+Z7DMih1NUKxDuxOcBhHqQqly5LLSC43kouKmh2UnMO/hgM8cPhKh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498608; c=relaxed/simple;
	bh=HbdwMtr5TYpUwaddcIx4jPgNxnMS2hHqsDDw8qZF8PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkI04tmL2bNmuzT6wqnPHTO3G9Kt740Z0xPBsaXuJLERkXxAPaOXcuw3DugsOef85fmuR4FgsjsHQeHRZzwyMn5NHDr3utIAjku5qMs+qktmvYOIgI/Zqk60Wv2UoQZyl1uoSS/48dFK7c4ckenv+zkmguI/8yTr/Af2jNRFqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3yZ1DBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3yZ1DBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792EB1F00A3D;
	Fri,  4 Sep 2026 05:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498607;
	bh=msbAmkfov5fBOXoKROUJ88dcBrjnuxM+fRYbuasJCoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3yZ1DBepw5T361KSGZigrJW8a+8TUkJWKfvk0bnErXbjmcOUV55dxkcifLsSSD+T
	 pnB+pdf7qR6QpqMs8Ol1hp58MJRhDFHtSGzQk45DnjqtBT/43hY0ypKfTx744nrqXo
	 JvVkSwM9YVBYMIPyJjAbYJOBOEdePFXzTJ0Wsxow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 121/713] i3c: renesas: Fix out-of-bounds access for newdevs mask
Date: Fri,  4 Sep 2026 06:51:29 +0200
Message-ID: <20260904045806.548691758@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 50dec95c9d1f1f82819bc898ef2b60fa83fd4ccd upstream.

When software initiates DAA (Dynamic Address Assignment), the controller
reports the result via the NRSPQP (Normal Response Queue Port Register).
The data length field of the response descriptor, which is accessible
through the NRSPQP register, indicates the number of devices remaining
after DAA. Consequently, when the bus is empty, this field contains the
maximum number of devices supported by the controller (8 for the Renesas
I3C controller).

Adjust the condition that computes the newly discovered devices bitmask
to prevent an out-of-bounds when the I3C bus is empty.

Fixes: e7218986319b ("i3c: renesas: Add suspend/resume support")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-9-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -689,7 +689,11 @@ static int renesas_i3c_daa(struct i3c_ma
 
 	renesas_i3c_wait_xfer(i3c, xfer);
 
-	newdevs = GENMASK(i3c->maxdevs - cmd->rx_count - 1, 0);
+	if (cmd->rx_count >= i3c->maxdevs)
+		newdevs = 0;
+	else
+		newdevs = GENMASK(i3c->maxdevs - cmd->rx_count - 1, 0);
+
 	newdevs &= ~olddevs;
 
 	for (pos = 0; pos < i3c->maxdevs; pos++) {


