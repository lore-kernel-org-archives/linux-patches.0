Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4955F3218CB;
	Mon, 18 Aug 2025 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522679; cv=none; b=NzSnkFSSNeX582+M5IOSbLwVT/CjtmgfchJURCepKRYjUSgb+kSjVCIqQl4/E1rA1p4fVwP4xWnTZXFZIAk5+RPpidVyS/QpCnqUF61YVuF9ObwmAUPg+76ybHP/2FiP4WCtBH8z+3EJFn11jzxW3RjkZznKRlZwy9uaq8b631I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522679; c=relaxed/simple;
	bh=lSgXTWRnXojVT66Uvd8cd6WcrhRbBDIDyDkK28BX0G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNwDxXu+lpbYYUciSQ3xNHxTxKKtcd5+3KrxezUjwOlGXUK2kHzm5iZ/LdJS8dMkGhPejn9n1jA/1Hg8kF+N0eZPLh0ftyDeef40kK20j2jI8ZOKdqbX1Cui/6R3q00S35ToAfEEcijj+1DvMIBnhB163RDcA58egBZ/FuOmxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKbvjZPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKbvjZPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59558C4CEEB;
	Mon, 18 Aug 2025 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522677;
	bh=lSgXTWRnXojVT66Uvd8cd6WcrhRbBDIDyDkK28BX0G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKbvjZPiw2Ibfr2Pq/a9UB7UJxA1sp7OCMe3WyRT2Dq/jCGLLR0onBQaz9cwegCL8
	 AmFdHbF103ou26SQfsJLFsnftXuFopLFS0F1mYYdOi8oRIF8pEcBsfF3GUbu+GNulf
	 E/DXO0HfMXXv1kVBaI4VwBCoiPToBuu/eI9V4sW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Myrrh Periwinkle <myrrhperiwinkle@qtmlabs.xyz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 387/444] usb: typec: ucsi: Update power_supply on power role change
Date: Mon, 18 Aug 2025 14:46:53 +0200
Message-ID: <20250818124503.409019362@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1225,6 +1225,7 @@ static void ucsi_handle_connector_change
 
 	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
+		ucsi_port_psy_changed(con);
 
 		/* Complete pending power role swap */
 		if (!completion_done(&con->complete))


