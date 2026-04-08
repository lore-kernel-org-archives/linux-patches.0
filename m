Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1728B67E;
	Wed,  8 Apr 2026 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673441; cv=none; b=YXqIuhglNabCSHrS3p3TxfkQtg5FuP4Wd5zq3lFqxT9PvlGR9yrC/r2peB/AohYsf9W1oOgwBt7pNCEpp1y+tgJIZ8d4i+XI+TEQLFMI56P7C19yM9TIYU38iNVhnsFdIfri1Rt44xqCYdE5eyH1KZq7yMvp6i9YlscpOqXr0vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673441; c=relaxed/simple;
	bh=RasWfS0OG0qCrZg8LQduVPuURjXzW7U49I6t3Sd8yJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7bf1y9AkLhFlRJlB0AwaUH4hGLdG8K8ZBCYs5UI9avWjAv10/O97YonoN62jOBS1dSojxtx35gzhD8D9tRlji5sAEwDx4XI+TYYW5NAViNmkXPYH62KfNR3dsT1iQ6eNH/HBGc43G1CTjGFtviDXvBOrF/WUNMNWnWgJHHOkyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oo4T64RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oo4T64RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A615C19421;
	Wed,  8 Apr 2026 18:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673441;
	bh=RasWfS0OG0qCrZg8LQduVPuURjXzW7U49I6t3Sd8yJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oo4T64RHpOlB2fhgzQStzVDym6O+UHGaBiM7ieRZB8G21QK+tTQQm/bk/lVRip9Un
	 taLIq3aftNkivYjIoe+BUXZVSve8sj23dBvJ+C2GTxgIUeEgQkeVGx8+ypkw/8DRVp
	 1pU/J8uPK1ulSOtngwT1OM0azasM7dSXqiw2Xcuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.18 216/277] comedi: me_daq: Fix potential overrun of firmware buffer
Date: Wed,  8 Apr 2026 20:03:21 +0200
Message-ID: <20260408175941.925193191@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit cc797d4821c754c701d9714b58bea947e31dbbe0 upstream.

`me2600_xilinx_download()` loads the firmware that was requested by
`request_firmware()`.  It is possible for it to overrun the source
buffer because it blindly trusts the file format.  It reads a data
stream length from the first 4 bytes into variable `file_length` and
reads the data stream contents of length `file_length` from offset 16
onwards.  Although it checks that the supplied firmware is at least 16
bytes long, it does not check that it is long enough to contain the data
stream.

Add a test to ensure that the supplied firmware is long enough to
contain the header and the data stream.  On failure, log an error and
return `-EINVAL`.

Fixes: 85acac61096f9 ("Staging: comedi: add me_daq driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260205140130.76697-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/me_daq.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/drivers/comedi/drivers/me_daq.c
+++ b/drivers/comedi/drivers/me_daq.c
@@ -344,6 +344,25 @@ static int me2600_xilinx_download(struct
 	unsigned int file_length;
 	unsigned int i;
 
+	/*
+	 * Format of the firmware
+	 * Build longs from the byte-wise coded header
+	 * Byte 1-3:   length of the array
+	 * Byte 4-7:   version
+	 * Byte 8-11:  date
+	 * Byte 12-15: reserved
+	 */
+	if (size >= 4) {
+		file_length = (((unsigned int)data[0] & 0xff) << 24) +
+			      (((unsigned int)data[1] & 0xff) << 16) +
+			      (((unsigned int)data[2] & 0xff) << 8) +
+			      ((unsigned int)data[3] & 0xff);
+	}
+	if (size < 16 || file_length > size - 16) {
+		dev_err(dev->class_dev, "Firmware length inconsistency\n");
+		return -EINVAL;
+	}
+
 	/* disable irq's on PLX */
 	writel(0x00, devpriv->plx_regbase + PLX9052_INTCSR);
 
@@ -358,22 +377,6 @@ static int me2600_xilinx_download(struct
 	sleep(1);
 
 	/*
-	 * Format of the firmware
-	 * Build longs from the byte-wise coded header
-	 * Byte 1-3:   length of the array
-	 * Byte 4-7:   version
-	 * Byte 8-11:  date
-	 * Byte 12-15: reserved
-	 */
-	if (size < 16)
-		return -EINVAL;
-
-	file_length = (((unsigned int)data[0] & 0xff) << 24) +
-	    (((unsigned int)data[1] & 0xff) << 16) +
-	    (((unsigned int)data[2] & 0xff) << 8) +
-	    ((unsigned int)data[3] & 0xff);
-
-	/*
 	 * Loop for writing firmware byte by byte to xilinx
 	 * Firmware data start at offset 16
 	 */


