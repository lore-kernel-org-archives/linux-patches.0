Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93FF3176E4;
	Wed,  8 Apr 2026 18:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674100; cv=none; b=S1+hOSAFZr1lP4+eDk5TTybUqbLp4riUL/ZH1erQn3DsNSEIzmSef0qSLT90e5Z686iFW5sHqWmWogREv6zijCgMRWKmP/AmQNZC6uRxhm6jA0Z8s/Ze6+Rbwblq4cifX2FVhfatCIMmHL1YKhRjcgfbFsTxBcsyYhPClrY8aKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674100; c=relaxed/simple;
	bh=aVIa/h8HgN1B9xaBtqNTSWGo2LR76dlCExH3zyhdit8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfMCdCYhMNxtp3rji1qKFg5+lb8/L8cFnO5X7lckm1seA6HFLzCUUzUBeOcRh6t8+uP439YmvlO/+TLJtBXfr0uKR8C/44Tmn+2sqT8vNp6+PvgCBDvWLswGwFeDfz5bvHcW1ks6b/Ld90RUOCRjJx/AgyR3ULm89nyPDIfkH3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtaX9FKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtaX9FKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC11C19421;
	Wed,  8 Apr 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674099;
	bh=aVIa/h8HgN1B9xaBtqNTSWGo2LR76dlCExH3zyhdit8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtaX9FKQt7KjlZ00m2Xz0ZfKxGgrNcIQ4XMNIahX+VdIEXugAymCltstDONRNB3wL
	 jjbgxVPpdLtyqT0HEVLdkxSTxeoLcqG8jl77e2erZL+NQY8OlvHcRAWH02KUnrzyl6
	 hV2PsOOdGC3UJNOffLCkw14PdysuUcVtl9bT/NYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 177/242] comedi: me4000: Fix potential overrun of firmware buffer
Date: Wed,  8 Apr 2026 20:03:37 +0200
Message-ID: <20260408175933.711931115@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 3fb43a7a5b44713f892c58ead2e5f3a1bc9f4ee7 upstream.

`me4000_xilinx_download()` loads the firmware that was requested by
`request_firmware()`.  It is possible for it to overrun the source
buffer because it blindly trusts the file format.  It reads a data
stream length from the first 4 bytes into variable `file_length` and
reads the data stream contents of length `file_length` from offset 16
onwards.

Add a test to ensure that the supplied firmware is long enough to
contain the header and the data stream.  On failure, log an error and
return `-EINVAL`.

Note: The firmware loading was totally broken before commit ac584af59945
("staging: comedi: me4000: fix firmware downloading"), but that is the
most sensible target for this fix.

Fixes: ac584af59945 ("staging: comedi: me4000: fix firmware downloading")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260205133949.71722-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/drivers/me4000.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/comedi/drivers/me4000.c
+++ b/drivers/comedi/drivers/me4000.c
@@ -315,6 +315,18 @@ static int me4000_xilinx_download(struct
 	unsigned int val;
 	unsigned int i;
 
+	/* Get data stream length from header. */
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
 	if (!xilinx_iobase)
 		return -ENODEV;
 
@@ -346,10 +358,6 @@ static int me4000_xilinx_download(struct
 	outl(val, devpriv->plx_regbase + PLX9052_CNTRL);
 
 	/* Download Xilinx firmware */
-	file_length = (((unsigned int)data[0] & 0xff) << 24) +
-		      (((unsigned int)data[1] & 0xff) << 16) +
-		      (((unsigned int)data[2] & 0xff) << 8) +
-		      ((unsigned int)data[3] & 0xff);
 	usleep_range(10, 1000);
 
 	for (i = 0; i < file_length; i++) {


