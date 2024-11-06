Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77C31D5AD7;
	Wed,  6 Nov 2024 12:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895115; cv=none; b=O42vdiYTYw/RZ+qsHkayH9C4WPLFc4qwo3FkvYFWHOM4G0U3oyG20r2pyoozbr9vAoWeHCjDT7hiT+rkRiedI4UIiUGrunvq7zOydgF4Bi9mW10O1mjcRZWRY880zUHeAy5cf7NZyXuXM2iUm3gu7aNaWYHSoKEqvJpqhGHt6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895115; c=relaxed/simple;
	bh=rmBjc4/GKdQiMz5Zt1tDxTMnAPsrKLQBe/d9SIavJas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6cPmCvXWeJESHU0GyhWUwhTht/Bu9AiD0JKQAbirVkTnUhfnqXBFw+zkXMdlq4R+cMRdTOzZQVm5CLbDQZQuV+8JtQYGmKImS4wmf4Q5ly+xwtHAulMecoFCGHfxLuHiDZ9Uuc5Q2gm7KPENMNMvlT+tDxLYyQZmPLDYe+pAEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDQ4G35Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDQ4G35Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414CAC4CECD;
	Wed,  6 Nov 2024 12:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895115;
	bh=rmBjc4/GKdQiMz5Zt1tDxTMnAPsrKLQBe/d9SIavJas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDQ4G35Zz3tLTk1zshv7T2JvVZ3fEqkW5vg34iEQ3aLlWDrEeMLjZGwxJzfQsgtrJ
	 rCNXXYTiFi00bSIJVLWaiPvAescIyExdeOIMb704z/LLZvB6kSKf+jW1vnwYopuvEl
	 Ou+vIsiLPOgRO6BenFdhm1B4AWoBlj1dGoo2lEDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 110/350] USB: misc: cypress_cy7c63: check for short transfer
Date: Wed,  6 Nov 2024 13:00:38 +0100
Message-ID: <20241106120323.618331608@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 49cd2f4d747eeb3050b76245a7f72aa99dbd3310 upstream.

As we process the second byte of a control transfer, transfers
of less than 2 bytes must be discarded.

This bug is as old as the driver.

SIgned-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240912125449.1030536-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/cypress_cy7c63.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -88,6 +88,9 @@ static int vendor_command(struct cypress
 				 USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_OTHER,
 				 address, data, iobuf, CYPRESS_MAX_REQSIZE,
 				 USB_CTRL_GET_TIMEOUT);
+	/* we must not process garbage */
+	if (retval < 2)
+		goto err_buf;
 
 	/* store returned data (more READs to be added) */
 	switch (request) {
@@ -107,6 +110,7 @@ static int vendor_command(struct cypress
 			break;
 	}
 
+err_buf:
 	kfree(iobuf);
 error:
 	return retval;


