Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5174D32470D;
	Wed, 28 Jan 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615109; cv=none; b=BIXE3NdSQTZx7QWMmlgSP1M/NvFj2h5XKJvD5RBWyods9xk3+pD4rh7lEq0NtzXlodhJX8zi+/wVk0dJ2e6SW9m03sg9t3h3XKy02fpfs8wjRVdzRFhIvANWw3Gzl98gurOUrY/hj7IL2tBs84mum9jdpuXEEey/6dhXZ2dMTbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615109; c=relaxed/simple;
	bh=VH1ZUqNShe7EENACYi+aGySGb7CRrQJhpNTztSvdeFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2fGe50NabUKD1NeR+ayqJeSA2CFyoMKsk+8wWXQO4WnPq89IvelnR6RY/MytOqhc0Rzz4AH/vFzODKTmMPbD10HdKlGnNkEiZ+lKkLDIxq2Oz80BVYqnHSErQX1vBPg8tvuMEkq0SK0TZcZv49kNMJaGof+9esUpsj3kbCLonY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXgTJysJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXgTJysJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD2DC4CEF1;
	Wed, 28 Jan 2026 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615109;
	bh=VH1ZUqNShe7EENACYi+aGySGb7CRrQJhpNTztSvdeFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXgTJysJ1UjTAXFQTlXr6rofuzljdYhS2GajXCKfNtE59GttE8C74BvDHZRQ4rAho
	 drJIQ6wiBE+8kywcLVogk2l7HCs2aFjQSqluBw6q572bxxmcVIrjMzV2yfb1fD6+0B
	 VJIkzK6G1KuNXtiOVxVYL4YIpzrWLCJY+pnR3TXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	feng <alec.jiang@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 049/169] Input: i8042 - add quirk for ASUS Zenbook UX425QA_UM425QA
Date: Wed, 28 Jan 2026 16:22:12 +0100
Message-ID: <20260128145335.781663804@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


