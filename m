Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831042BD02A;
	Wed,  4 Feb 2026 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217799; cv=none; b=chV06SPbMJJMl0gaaNE3FqymkulM7UNrHFv/1gYQG0ioEauopgrFgJ+ylEAB/CYaAMYtaNs1HBXtpyJFGASmEC9ECZETPrMAu0ILsm1F2AQ6+i/RFb02RAUY0zxO1qLlbUQEHu+Bx6iDNrD5oEdLdNIXjd1c0r+x22H9poy9G5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217799; c=relaxed/simple;
	bh=fKtyixu/FZyUSHRmotAKMi+r0drfC2gDOwQRCSFJPzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBSouxQN+6QTm/kx4fA+GYPwYI8yEcjKuqU9cDC6TV/+4PLNlqTodkybq8HPfMfFDgFbVQgphCtzSBI6pU8vjncoy/jo+pDynx3VUKISyBYTrsN/IeGebCMvkg/+ZWwJSMlfK7hOWfyo/4AOHbt3pYKVLgW/TQx/+9grxam6+Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBzL3uEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBzL3uEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA94BC4CEF7;
	Wed,  4 Feb 2026 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217799;
	bh=fKtyixu/FZyUSHRmotAKMi+r0drfC2gDOwQRCSFJPzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBzL3uEwd/odb9qhxAAJN1gNkYHUPOuLuxfDrNrZi03h8AlpjZJZHLn7BS5n1Ydrb
	 b1xVbcZ7PdOUC4xCyEHVJ+2w5HC+1d0m9GG59B2PNO3GOo//fVZvDTMV7wgxea65jy
	 Z/uPnZMsiSGHEvS26iLXC4VZ63Xp0fwgNVG/3XMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	feng <alec.jiang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 121/280] Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA
Date: Wed,  4 Feb 2026 15:38:15 +0100
Message-ID: <20260204143913.991346067@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: feng <alec.jiang@gmail.com>

commit 2934325f56150ad8dab8ab92cbe2997242831396 upstream.

The ASUS Zenbook UX425QA_UM425QA fails to initialize the keyboard after
a cold boot.

A quirk already exists for "ZenBook UX425", but some Zenbooks report
"Zenbook" with a lowercase 'b'. Since DMI matching is case-sensitive,
the existing quirk is not applied to these "extra special" Zenbooks.

Testing confirms that this model needs the same quirks as the ZenBook
UX425 variants.

Signed-off-by: feng <alec.jiang@gmail.com>
Link: https://patch.msgid.link/20260122013957.11184-1-alec.jiang@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -116,6 +116,17 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_NEVER)
 	},
 	{
+		/*
+		 * ASUS Zenbook UX425QA_UM425QA
+		 * Some Zenbooks report "Zenbook" with a lowercase b.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Zenbook UX425QA_UM425QA"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_PROBE_DEFER | SERIO_QUIRK_RESET_NEVER)
+	},
+	{
 		/* ASUS ZenBook UX425UA/QA */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


