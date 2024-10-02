Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552E1CF7D4;
	Wed,  2 Oct 2024 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878749; cv=none; b=KS88fLL4Dsh2PLPu8L1eOVjoiNPO4CxL1/CYs63LLd9u6ViCeroGVydWEvAKryAaBB4cF2M2Te/J75+z4v3ZW2ND9gGQ3qyz2TX6S47bVIhBX3nvs8wDoRwSggOp1TwKPmw6NdeWzfzSREgkLGXL1D8pp4D7Oo/G/yjZUgmpQM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878749; c=relaxed/simple;
	bh=EfXeNx7wBv8Fo6GKy57n/IPQ29YxMQ5j7ei86KPxOdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDBzTDAXgr2lc1XY/ONaoT1WBMOT9X3FNoYziHywwRIfDOTOT/VoSx5rFHRrfu6CcpCJru4g/YzycES8CXV4gMqmUK7FndMDu0NAMOAsRCyG1dQ140Qnz8GI9L8nMUDpZckJ6ih+qZuUw6Q8xoki1f4tbyv9WOPegb3/EBtU2PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OGZ3yyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OGZ3yyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB32C4CEC2;
	Wed,  2 Oct 2024 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878749;
	bh=EfXeNx7wBv8Fo6GKy57n/IPQ29YxMQ5j7ei86KPxOdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OGZ3yyE0yDyHXO/rNz955Rc6e1YXhRwVQJyjSTBg7ybQ0agO109L6voXyRe6a0tM
	 eaTEnoZPR0IEqth+74UoAI6DNMdCHw69l/O4FSpDdrUnFK3eV7Lg4Q7gtCHC2SRMbN
	 kJukvD0jt2fAmrnfnsP12uXCkzRsjrEtvjavlhuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.10 520/634] USB: misc: cypress_cy7c63: check for short transfer
Date: Wed,  2 Oct 2024 15:00:20 +0200
Message-ID: <20241002125831.633602052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


