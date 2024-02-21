Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B857D401;
	Wed, 21 Feb 2024 14:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524637; cv=none; b=ae0i78PRD9afFDNhPcIgdSFin6ojJeue/CJfr77P1MGUWq7XHl8P4AR+ChQJNKwju1UTwY8vFFPvG9EDqxQ7hSgH41F6THw8AmNN1ZdDdxI5DnYyTQXsuFyEQCs8WwSr9gdDjEQE5cIuCHq68zE7xeGb+DYsFTN1Q64wsziz6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524637; c=relaxed/simple;
	bh=yK4lBRHLiYXtvbOXdmXDD305X58PZKcuv0COvmhqVY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOj+Al+S9AZMr1dz+MyAwqgd15wtcRvPyxyR+qFs/SxwOwMAvgZl6B2cbZViNIPI1oD13nY0b4aYjzOh5Qn2INqQRl4MgzrgMPNbpzR9q5HOvJKj+VvatR3TzSlBmuQrlliqY90SjRXbpYlmHIRSE6pgiupKlUej2OdUdQj2U60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjmkPdw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjmkPdw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A998DC433F1;
	Wed, 21 Feb 2024 14:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524637;
	bh=yK4lBRHLiYXtvbOXdmXDD305X58PZKcuv0COvmhqVY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjmkPdw4TXjZPsQdXcXy6DoFK1I16n0PE0w+Iru57ta/dGK/oRq6/YqGSt+kwGxmh
	 qB+DZjlhn+ilm2qQbzs04S5CMdQn3H+gq9/SvxvBeol2pgU4bzPkUEoZXW702TnC41
	 Q/6PnapRGOqaia+0ZurGC6njUtnS0UhkEdIohWQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.10 303/379] usb: ucsi_acpi: Fix command completion handling
Date: Wed, 21 Feb 2024 14:08:02 +0100
Message-ID: <20240221130003.886037803@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,9 +70,13 @@ static int ucsi_acpi_sync_write(struct u
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
@@ -82,7 +86,10 @@ static int ucsi_acpi_sync_write(struct u
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
-	clear_bit(COMMAND_PENDING, &ua->flags);
+	if (ack)
+		clear_bit(ACK_PENDING, &ua->flags);
+	else
+		clear_bit(COMMAND_PENDING, &ua->flags);
 
 	return ret;
 }
@@ -106,8 +113,10 @@ static void ucsi_acpi_notify(acpi_handle
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
 


