Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C43D8104;
	Tue, 16 Jun 2026 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632941; cv=none; b=YjlguysF9vai74YQBUHZYtjEvEDmvzuX3Zb06mrVSW/4svSiYTcu8XB0kGvw6zhdr3vBtVwnyDQxISjv4D0NfZaEZYijhdovFG4C+JCSZStdr6Uu7pH0BWaJo6lbbWiX+3rUdfPerUids3HQ1q2DjHlwpNRw3GYKJVLUTQIY3r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632941; c=relaxed/simple;
	bh=9WIbA4blcMAC+7j5qSndKSqsRac9eRvp6XEc129QANc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSykPMj2IM473aIJ/PD7lhfhazAaFqsqj9jQGkpJn50ImmKXAcnkhDNu+pGHc4hZatbs7k5sksLvyHV4fRfMngnUhH34uKHDzTR2glq49p8BzGyOWHJKcvVwIu7y043I1V0nh4tz02nuh34askZsl1Fm90wupW3ercYHQnl9C+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBsR/hqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBsR/hqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AE11F000E9;
	Tue, 16 Jun 2026 18:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632940;
	bh=4/IqUcsFeYgTeh47OTxaVZGnxF6NTjJHb4e4ZZH/5YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qBsR/hqjnmxKN+UzUHmSjbtdCsVpSzlTz197u1bb+sfiEUd3s6XwqaVwNmNSO2aVs
	 ZViPE1h6UGnG0UGeLUrK2XOM5OYuFjsMVmBHggIb3EYj0jCOrCJhQJBO5/CdXoP3uf
	 rhUPDqXb6qydm1mpcv6oB/FdK5x8vYVLuuKWmlK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sasha Levin <sashal@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.1 479/522] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Tue, 16 Jun 2026 20:30:26 +0530
Message-ID: <20260616145148.235414469@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

[ Upstream commit d98d413ca65d0790a8f3695d0a5845538958ab84 ]

We only need to update the power_supply on power role change if the port
is connected, because otherwise the online status should be the same for
both cases.

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-2-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ changed `UCSI_CONSTAT(con, CONNECTED)` accessor macro to `con->status.flags & UCSI_CONSTAT_CONNECTED` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -808,7 +808,12 @@ static void ucsi_handle_connector_change
 
 	if ((con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
-		ucsi_port_psy_changed(con);
+
+		/* Some power_supply properties vary depending on the power direction when
+		 * connected
+		 */
+		if (con->status.flags & UCSI_CONSTAT_CONNECTED)
+			ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


