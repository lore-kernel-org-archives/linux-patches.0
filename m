Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36B3374C4;
	Tue, 26 Aug 2025 13:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216523; cv=none; b=REbQqYIHwDg+1ZrPOJpb3nl1awXWFrpgOeOktjhY5+S3JdoVFnaQLtaTlMmb1CsHR5iWnOq+2GTbAkl4S9x0DBviC7XUJ6ts6MCUueu5h6JBIeW/CAMC7q21wdSbZZ2I9JI5IgjA30RX2/emfYlSJHlNikSg+8/nVEfFvvHkHJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216523; c=relaxed/simple;
	bh=VRxjKrnMPL6BYF47KaFZgCGgiGAjPYtT2csXVc+I+sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W114i1g1+B+tfaXjtim9fHskjRxFagCEIfek+l5pymJpjMvL3aDWfLwBQ7q3y1ObtKpbuKEK8oOW088JpBI9oYhmRhQFQKWFqJumNsfO8tsqcGAb2BIFU1MqWwyF/+QZx8DQG+iW7CEjoT2g3TNEvZ3G7mEaSSyzf3s6rgto6w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHJrJIXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHJrJIXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A37C116B1;
	Tue, 26 Aug 2025 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216522;
	bh=VRxjKrnMPL6BYF47KaFZgCGgiGAjPYtT2csXVc+I+sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHJrJIXz1UYaoZqNk/AEdrRecLmysX4NygC4OL6/YJ13OnbCFHCzGWnGOuvsXEtdp
	 UeALHTNF0ew0elTSGkoO3ndonwCf6rjZzO7DM0sAnmAEEcYmFelnn8hq0LnoZI8G34
	 4DcYRSOhw5Kqw73jg+ozJJLC4hLJx4qfhNpdbwRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 443/644] usb: typec: ucsi: Update power_supply on power role change
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110957.445717797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -793,6 +793,7 @@ static void ucsi_handle_connector_change
 
 	if (con->status.change & UCSI_CONSTAT_CONNECT_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		switch (UCSI_CONSTAT_PARTNER_TYPE(con->status.flags)) {
 		case UCSI_CONSTAT_PARTNER_TYPE_UFP:


