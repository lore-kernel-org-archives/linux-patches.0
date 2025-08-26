Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0232BAF7;
	Tue, 26 Aug 2025 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213322; cv=none; b=lcoxoLc2y3hVR3Ki2vg3srInSPKyvEkaDFqnlkw10wf2THIszUIAk4b4esA371hcO8ktdpNogl1AmM0mD2ZpitDu3ZnHHEbulQwP6xW2z20mSfYJAeFolZdbQ4dfwx35z+wxUbXpUoKxPSowGayobzZJnsTbJ3U5g8aiRYb5qRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213322; c=relaxed/simple;
	bh=8wrf5EBOjtsoH69hGZyrFMH93Q1oZYQJD2zL9gfXoP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIsRRkMddkg8DxwN/CAijV5Qen8tCFM3tlgCc5Ac6yjygIoXaEEO2bN1K82XaBRVsKDNcalRHH0BgsB4iqkICv5dGt90+KBxMpTvSDndWQ09zbJP3dGDuWL+Au2RLBF2A+jGGFleoM7uBcyrov7FRIfF3v4HuyZh7O6WQ9hpmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8Ihs48s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8Ihs48s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA3CC4CEF1;
	Tue, 26 Aug 2025 13:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213322;
	bh=8wrf5EBOjtsoH69hGZyrFMH93Q1oZYQJD2zL9gfXoP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8Ihs48sWq37ljvA/mL0dXwdapficlilXpyBiKe9pIjpSWusM+XwLnVk2vjjgh9FU
	 zO1iePh/r/YGhzNo8GDNezqDgbydSDoNF30dJ6KD3rojKN0UIrLXVcVt9UW62TuaEt
	 jS0XrMqI9EO5n4nJ2ZCtz0wRioNyqjD1qBp+rj9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 305/587] usb: typec: ucsi: Update power_supply on power role change
Date: Tue, 26 Aug 2025 13:07:34 +0200
Message-ID: <20250826111000.680241284@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>

commit 7616f006db07017ef5d4ae410fca99279aaca7aa upstream.

The current power direction of an USB-C port also influences the
power_supply's online status, so a power role change should also update
the power_supply.

Fixes an issue on some systems where plugging in a normal USB device in
for the first time after a reboot will cause upower to erroneously
consider the system to be connected to AC power.

Cc: stable <stable@kernel.org>
Fixes: 0e6371fbfba3 ("usb: typec: ucsi: Report power supply changes")
Signed-off-by: Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250721-fix-ucsi-pwr-dir-notify-v1-1-e53d5340cb38@qtmlabs.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -910,6 +910,7 @@ static void ucsi_handle_connector_change
 
 	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


