Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9211288C01;
	Tue, 22 Jul 2025 13:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192668; cv=none; b=TIqiP48Lx03iCOxhTjoA//ztjOTe0Is9BWNGEV4XVgi7RmtQDYtS7Y3V+8bqliEWFKViK6romv3b1tSZSCb5nZuQLYZ1+P/OhTExgW0ncfK1YxbTZbjisDPxIuhBVqHFiKQ/eustSMGzaVLDw0AdWq2cQxTwy1y6pNBjuSjt9Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192668; c=relaxed/simple;
	bh=YC1Kokoq79/GSkTjnOmsdqwMBbCI65bh6Tq8AwOEiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XILvZktGS9esRS40ztWDO/UE8S1/8+MlVA5AGFrArBfn1+Rrx9m5lL5FVVJRe/Fk+8homn0mYkyF1UAW5C9nFZzuTxpTzDWrP4XCSHBFrYQZQg9eU1r0iEQYE1qDDHAYok5bn+SGRMDIuoACrj0p8KRCEuf3h+hFX7BcnUFehC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jTxfvP/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTxfvP/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CE7C4CEEB;
	Tue, 22 Jul 2025 13:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192668;
	bh=YC1Kokoq79/GSkTjnOmsdqwMBbCI65bh6Tq8AwOEiFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTxfvP/OTiewLIbj4/0Y+PgHTRjMzp4wSTCuARQXctDL7IqulGjJHXC6YgJTX3z0Y
	 X7esfzS0bxde8MtvPcaGrjSYdqpzZpQ81zmz5WuJInlK3arT19eTMuw7PLLLOi0Rsx
	 5LQ4yt13S0+ra2cxeIc1dnO99nKUNsTwMumwv7J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 022/158] HID: core: ensure the allocated report buffer can contain the reserved report ID
Date: Tue, 22 Jul 2025 15:43:26 +0200
Message-ID: <20250722134341.564094278@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Benjamin Tissoires <bentiss@kernel.org>

commit 4f15ee98304b96e164ff2340e1dfd6181c3f42aa upstream.

When the report ID is not used, the low level transport drivers expect
the first byte to be 0. However, currently the allocated buffer not
account for that extra byte, meaning that instead of having 8 guaranteed
bytes for implement to be working, we only have 7.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Closes: https://lore.kernel.org/linux-input/c75433e0-9b47-4072-bbe8-b1d14ea97b13@rowland.harvard.edu/
Cc: stable@vger.kernel.org
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20250710-report-size-null-v2-1-ccf922b7c4e5@kernel.org
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1873,9 +1873,12 @@ u8 *hid_alloc_report_buf(struct hid_repo
 	/*
 	 * 7 extra bytes are necessary to achieve proper functionality
 	 * of implement() working on 8 byte chunks
+	 * 1 extra byte for the report ID if it is null (not used) so
+	 * we can reserve that extra byte in the first position of the buffer
+	 * when sending it to .raw_request()
 	 */
 
-	u32 len = hid_report_len(report) + 7;
+	u32 len = hid_report_len(report) + 7 + (report->id == 0);
 
 	return kzalloc(len, flags);
 }


