Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48732D8378;
	Sun,  7 Jun 2026 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829295; cv=none; b=FTVT3GSuarWJq+ahaieaLVpzkyGMlopSk2v4PUOwpJ4yt3JCuZ0pF7SQaRiuiYTfkBPB/mXOaJDDefp6+/if6unv1u/ZtoxycAbPMUhb1E+FihDVKKZ8sVJ2TK3KykvhY4w2rKEncbrcDYIDSOBnw8CwDctV7WwYXhjMTciGsI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829295; c=relaxed/simple;
	bh=H82ksxhcrXC002YjSkK5PfDoBDhjHWl2/sFiRcj0ytE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmqDkSirIzNuO6/oQ+1WwGdbKPr6g2080n0WmBv8Ts2siAra15OHauumSEk2gdBIYGxpy0vpMO7oInCaHRR4zvl0Yk0xagOHv4UlJAlCM/gYdkR+qP6wi2sV3JGZUkwbEraPFV//nbAuppgnm+XR9NXEkvESWqsQ6F2szqGbw5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSyWxQSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSyWxQSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23261F00893;
	Sun,  7 Jun 2026 10:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829294;
	bh=0XDHmO9X9MEiX9u+nH1UVPAhTF0LjHMiUCE/gCDqfeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xSyWxQSPhU3ms1eZgklck0Mac26Y+flVKV/hgQ057w695LseNhxqnW0X1cE/wLfDP
	 GoVXSvaoJdTOoCikekdR1FBD2T3s4NhHwZQRMwRxDcdYA8yjCOvUf8tjnwanBHTdtJ
	 B+scUUvbrUfgNRNDp2Fa40f/kXfks+xqZSMJdO2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 6.18 233/315] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Sun,  7 Jun 2026 12:00:20 +0200
Message-ID: <20260607095736.127252664@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit d98d413ca65d0790a8f3695d0a5845538958ab84 upstream.

We only need to update the power_supply on power role change if the port
is connected, because otherwise the online status should be the same for
both cases.

Cc: stable <stable@kernel.org>
Fixes: 7616f006db07 ("usb: typec: ucsi: Update power_supply on power role change")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Link: https://patch.msgid.link/20260519-ucsi-fix-2-v1-2-6f1239535187@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1255,7 +1255,12 @@ static void ucsi_handle_connector_change
 
 	if ((change & UCSI_CONSTAT_POWER_DIR_CHANGE) && role != prev_role) {
 		typec_set_pwr_role(con->port, role);
-		ucsi_port_psy_changed(con);
+
+		/* Some power_supply properties vary depending on the power direction when
+		 * connected
+		 */
+		if (UCSI_CONSTAT(con, CONNECTED))
+			ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


