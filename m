Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8C31E4B2;
	Wed, 21 Feb 2024 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523202; cv=none; b=M13v3QfziyarxmTUVQy0DohNKI7kF9P5/FznHYB+wYf0iJLJlx2P3bj5a0ItxCyrf0OdYAIJOUDBggzmtFeZ/hieiuK2+DlE7CboTkKb2ctNH8dbY/JL/k0fSkYjKV14qNLiXinIEYbxIPhnKb2Q2q9vn7jpOjJJ6WyUbTECoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523202; c=relaxed/simple;
	bh=llwHlXrtnhWFBlexRiSln0jFBvN3t5BwGAJP79ab3sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AczOaD6nNo8SCAngyFtehCC847AOMZ/J9ulCyETyA344NVukVjA7Mjy0QlE4VetCvwvBJVB4xItzx72aTbQUQHjlc0F5W3Il9nCdyx8/r+3flkOtuxQLEp3j8me+HA0lCxD+tfYDtcjqjt1dgDhCsggiUmCWWvqQTzeTdItCgiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtcX0H8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtcX0H8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DCAC43390;
	Wed, 21 Feb 2024 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523202;
	bh=llwHlXrtnhWFBlexRiSln0jFBvN3t5BwGAJP79ab3sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtcX0H8qZISNxD5ZMU2sDQnXhM6TwsAoRhRK8N8m2mns1RFwJIXtYWZZa94v7SFa+
	 /NuK72z62T3LKKeMQMCdAR7C1spaZJvpNBEHT9K3QxEOM9SMMjru596tsx9vDrDboW
	 KBIvCdA30RCSUkrjU4flNe2oTmSSF6zWgzNKVgeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 366/476] usb: ucsi_acpi: Fix command completion handling
Date: Wed, 21 Feb 2024 14:06:57 +0100
Message-ID: <20240221130021.556237422@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


