Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082DE3375D7;
	Mon, 18 Aug 2025 14:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526277; cv=none; b=p22G03kk1U37kDWp7NwK+LmLjhLl2MTrqah0n6GTBDtn9MYY3aXoJcFroPQAxpCEFU8mKifSPTmcXoAH0jU3YW2At4OCMTTVRcYhDnUnf0H5dK8h7PzSPK9llC00le+8Bf61xHs/Uh1JkKFdK/VANQcbavV47QEUWN9GN1Uzpqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526277; c=relaxed/simple;
	bh=t++WW4QRF21kpU5ppWCljZSZccdbBPnTLgx4FUsWllY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIZHlU+EmUaN3mh9bFMX+99I+GNTAjr6TL9lgqgKyto1Fjs7025OvFQhKPbQtdDnld2ConSFBYF7/XA21CIWGffcxU23ffbsDnUOdT4QOxLcTLix4ve96yH6PlYT2CIPwVDkZkYGJkf1AeXSV/yt7FPt9lN5W6QwKI1Agq2CQKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6THb8qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6THb8qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AA8C4CEEB;
	Mon, 18 Aug 2025 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526276;
	bh=t++WW4QRF21kpU5ppWCljZSZccdbBPnTLgx4FUsWllY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6THb8qyliMJkx7pd+UFDiTcq/pXg+6C+YgCfxskmkqTTTPXrEyXGHU37VsDieAk/
	 ey878X6p8d1uIhxEcwB90cBj8CwFjB9RdwDajfENvb9Fn4UdSarOapgj0p0CrzxA7b
	 yS5EE688CV5kBdKdnYceol327+/g3WycixbtYn+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.16 507/570] usb: typec: ucsi: Update power_supply on power role change
Date: Mon, 18 Aug 2025 14:48:14 +0200
Message-ID: <20250818124525.396009412@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1246,6 +1246,7 @@ static void ucsi_handle_connector_change
 
 	if (change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


