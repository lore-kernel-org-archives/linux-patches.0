Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07DB1DFDB3;
	Wed,  6 Nov 2024 13:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898159; cv=none; b=hIRkBzyIyUDXjbTus3/yhOe2BCmgCX/hUY7Bn4gpZob433xfTEK7hEg+o4KUVYex27+s8EclBrBqRssHQkPYdT1gfSFb2fojwDkR00IieRs3nMqJZlMVDjNZiM9j2QcPIJ46CX/JGrcSB0pGCymhi0sqhzzdSlYFWwJU3naC0jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898159; c=relaxed/simple;
	bh=Ko9MA9+9WCqfDcJGorsRm1GIpUO9v31LFMrGjthD3Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnn7iSgkjBwHSG8sfR4vh1ehTsxvyqE89vnUJTHp0DrUVBClC/IVlf2ExRPstveG1Xk5dlkV5zMBV7a065qQnpLGK108/VDPbaHT3t+Fkxl4JzyoI+Y1xW92GjzEpx0ySICwfFN0B4KbPSWK1uwBsF+Nd/DrGZnCls3o2NspLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wM8SxLLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wM8SxLLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D405C4CECD;
	Wed,  6 Nov 2024 13:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898159;
	bh=Ko9MA9+9WCqfDcJGorsRm1GIpUO9v31LFMrGjthD3Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wM8SxLLXErGF6f9wW4LSBNWvCNSEjV/fAuWmMVGakpO4Np6uUjLY44iyC3y3bdMot
	 HeHS7z+g1sAi12MzcMKjugM1TO/xmDxUjlC0msHbCODg7+xl43HxG2P1YdryBcRaPF
	 5MgdGQQ57+eRz/pEVOFgptWo2rV7yfq3Y5MD8avM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 143/462] USB: misc: cypress_cy7c63: check for short transfer
Date: Wed,  6 Nov 2024 13:00:36 +0100
Message-ID: <20241106120335.043159158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


