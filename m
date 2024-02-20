Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A39214AD12;
	Tue, 20 Feb 2024 21:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463555; cv=none; b=WL3leNg5K7lgdrD3uXBszNmRkuG4EDdfHWh69njKXSQmYJYe1vU1JQx4rft02BVoy8cXAZjlzI4lp+JYtiuP7mCWm374nuscJeQ0DBXZunLxdSJ9XzT8L8uakaE6pyKeEBAMECCinRL6UgbCxP2nKHoF8LHaXLTWvD3alykyK1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463555; c=relaxed/simple;
	bh=9HYqaTWl9aL4ZGn+qB1eOCv2oeQ53xcAtcjK+ieQHDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOlcwbGwIYYFVsA9AugLkoixwgtXY4MGHzcemfFlyK/GI//tmVPDT9CvmvmWA8dLs08C1o91b+7pbQ2wOB82EKnCzo61QvlpIIro9aWYZ0d2TcBZ5Kf9m5VcWxehr5Vcg9lUe43zyRsqcDJOHN8zTIpquRLYyxusJeQqW/HLS5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjRez151; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjRez151"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC33EC433F1;
	Tue, 20 Feb 2024 21:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463555;
	bh=9HYqaTWl9aL4ZGn+qB1eOCv2oeQ53xcAtcjK+ieQHDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjRez151dvWmtzV6ZcFvQ5trstMVk5Yv0TBWCXSe1hkABTatCt9V7MrdJYzrfemzl
	 L2DO+MNmK7V57y19MCCUQ/ISnF+bU+n7JEosKLqHoyNEvtgGA0a1NcgEz5IkBp2sbl
	 LsZzdio2pQXlESx8zlAEnH9MTfXFS1bvpf4UkBTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 079/331] usb: ucsi_acpi: Fix command completion handling
Date: Tue, 20 Feb 2024 21:53:15 +0100
Message-ID: <20240220205640.061030798@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian A. Ehrhardt <lk@c--e.de>

commit 2840143e393a4ddc1caab4372969ea337371168c upstream.

In case of a spurious or otherwise delayed notification it is
possible that CCI still reports the previous completion. The
UCSI spec is aware of this and provides two completion bits in
CCI, one for normal commands and one for acks. As acks and commands
alternate the notification handler can determine if the completion
bit is from the current command.

The initial UCSI code correctly handled this but the distinction
between the two completion bits was lost with the introduction of
the new API.

To fix this revive the ACK_PENDING bit for ucsi_acpi and only complete
commands if the completion bit matches.

Fixes: f56de278e8ec ("usb: typec: ucsi: acpi: Move to the new API")
Cc: stable@vger.kernel.org
Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240121204123.275441-3-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -73,9 +73,13 @@ static int ucsi_acpi_sync_write(struct u
 				const void *val, size_t val_len)
 {
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	bool ack = UCSI_COMMAND(*(u64 *)val) == UCSI_ACK_CC_CI;
 	int ret;
 
-	set_bit(COMMAND_PENDING, &ua->flags);
+	if (ack)
+		set_bit(ACK_PENDING, &ua->flags);
+	else
+		set_bit(COMMAND_PENDING, &ua->flags);
 
 	ret = ucsi_acpi_async_write(ucsi, offset, val, val_len);
 	if (ret)
@@ -85,7 +89,10 @@ static int ucsi_acpi_sync_write(struct u
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
-	clear_bit(COMMAND_PENDING, &ua->flags);
+	if (ack)
+		clear_bit(ACK_PENDING, &ua->flags);
+	else
+		clear_bit(COMMAND_PENDING, &ua->flags);
 
 	return ret;
 }
@@ -142,8 +149,10 @@ static void ucsi_acpi_notify(acpi_handle
 	if (UCSI_CCI_CONNECTOR(cci))
 		ucsi_connector_change(ua->ucsi, UCSI_CCI_CONNECTOR(cci));
 
-	if (test_bit(COMMAND_PENDING, &ua->flags) &&
-	    cci & (UCSI_CCI_ACK_COMPLETE | UCSI_CCI_COMMAND_COMPLETE))
+	if (cci & UCSI_CCI_ACK_COMPLETE && test_bit(ACK_PENDING, &ua->flags))
+		complete(&ua->complete);
+	if (cci & UCSI_CCI_COMMAND_COMPLETE &&
+	    test_bit(COMMAND_PENDING, &ua->flags))
 		complete(&ua->complete);
 }
 


