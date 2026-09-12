Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8729A41687C;
	Sat, 12 Sep 2026 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210537; cv=none; b=bCQrYLREnXBJDfnVGrBBzBb3Tylkv0VSs5XGfuVPtyT3XTPXVbThgioJJpvw8Yj7G25dsLhphG3tKOsWvZEFhCdYLdqmBeSZZDu/FRKOhrSB/bOHRaW0rHJwcq1lyjMYXuMtktAW+sjaEQ+IpqjUUFYbR2Qte79+RqUl0Lzm0L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210537; c=relaxed/simple;
	bh=w3nnek0oWLu6AOBXVoFjyquvke0NR76vtIRMRRVU01c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7ms9YzTOLjX1j2FndV9BzFucf8hCyfg+Fq0MAO+BKc7PQbKGN8cwWaueV1Lxccex/6B06b+YopR9VEjkfZoDyEiMDc1CvFYJmbcSqRFuoEbqMcMSRRfdS6RQlAkdu5AsmMD3f5PYu/O1bAnEAZTBK+D5dHb8/a8flIKnjX7Ohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWipc8ia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWipc8ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5591F000FF;
	Sat, 12 Sep 2026 10:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210536;
	bh=pChh/QE5G5IZdi52MYLPc67Qj64VHqA4O1yF1E5dX60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWipc8iaMD/HCZzuodLcK4IRV/XxL5s9SI5DphcBCIW0NKR2ENCWjZez1/doYe0VL
	 MusH/Gs4JxVe27Kr2qoBwZ34onXJXlwro0WhrtYpMVssLrEByfD9POFZPjAxXdPnPL
	 aKpA0W4lDlJrShaW9NRw+3rin/LjZzKcEZaev43o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1045/1518] i3c: renesas: Dont register devices when ENTDAA times out
Date: Sat, 12 Sep 2026 08:53:34 +0200
Message-ID: <20260912065647.091983627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>

[ Upstream commit b6e56fd8c8a8ac7992868a28702192372ab04015 ]

renesas_i3c_daa() derives the number of newly assigned dynamic addresses
from cmd->rx_count, which the response ISR sets to the number of address
slots ENTDAA left unassigned. It starts out as zero, which already means
"every address was assigned", so a timed out transfer leaves that value
in place and it gets used as a result.

On a bus with no target connected the ENTDAA times out and the driver
registers RENESAS_I3C_MAX_DEVS devices that are not there, each costing
the core two seconds on a GETPID that can only time out:

  i3c i3c-0: Failed to add I3C device at address 9, error -110
  ...
  i3c i3c-0: Failed to add I3C device at address 16, error -110

Start from maxdevs instead: no address is assigned before ENTDAA runs,
and the existing rx_count >= maxdevs check then reports an empty bus.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com> # on RZ/G3S
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260731070150.2519825-1-tommaso.merciai.xr@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/renesas-i3c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/renesas-i3c.c b/drivers/i3c/master/renesas-i3c.c
index de2b495d34eff..91c04f3a4c552 100644
--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -649,7 +649,7 @@ static int renesas_i3c_daa(struct i3c_master_controller *m)
 
 	init_completion(&xfer->comp);
 	cmd = xfer->cmds;
-	cmd->rx_count = 0;
+	cmd->rx_count = i3c->maxdevs;
 
 	/* Enable I3C bus. */
 	renesas_i3c_bus_enable(m, true);
-- 
2.53.0



