Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AED2DFF04;
	Sun,  7 Jun 2026 10:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829315; cv=none; b=AX4UZliAEB93MBgd+fENdj0ATmGwHqyf2anCVk43Gfn8qZSZqO5UtHC/jyu+Xz9ncL+V0qL3QoKncmEtJSnQH993sQa/Z7xZIx5g79kWE5OowvJxHDKC6RUFhWoZnHAenBO42qRd5wa7gmEzoQeLYhdEltM9Jh2o/EeXreRn4ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829315; c=relaxed/simple;
	bh=hcn5CH4o/bhPOePiFTCU+NoiE1H5ATZOmvXBp30TwIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgE2Bnb2HMn1RJEb9UiIcy5RV3W0O6ViEkoUeLPqVlwJqleqO2KJ+7QTuOhovpvyZZn+KAWS0j0kfRoyPexCsVuu0Tiajf3uRVkOjtiIuTBvA7/uudD6uDvNC3tAKEFbjCkiANAG2CqWW2yOJyXX2ynBij5wPon1soU/JoR5bm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhy+zmDJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhy+zmDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85CF1F00893;
	Sun,  7 Jun 2026 10:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829314;
	bh=lEYufNNEG/ORUiMSjMEvUO7tgi12bSx8eLS3tXmCc+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhy+zmDJn2tTpBePqdJ9Iq1YTarcZXI1Nn7xsIakeofNRq5YpyZdyz9mwv7qI//M7
	 mDN+28pcSDBjJTdFlO8E/JTDyKO5NccZDwRGwLnQfjM3ubVlrtHyyBHKMMw41XSrX1
	 /6ZbFyAVNsCyMDgv5SWJ80+z8GRS7hND8fVY+poE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 7.0 263/332] usb: typec: ucsi: Dont update power_supply on power role change if not connected
Date: Sun,  7 Jun 2026 12:00:32 +0200
Message-ID: <20260607095737.699141619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1298,7 +1298,12 @@ static void ucsi_handle_connector_change
 
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


