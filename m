Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB513D903F;
	Wed,  8 Apr 2026 19:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674850; cv=none; b=tTePi786QK6SiJ6xt9xwRJI+WQsJu+X7QOMVMOCTUo4Zkm3O0pswFh9qAKextqaJT2w1Gn6Fot5Gt1wZdhaSy0Vdlhmk79LtxNXPZcEfyel1mKPZBuvIPhrta523tEyR/bDlqCkLWKqJzxKLMnSOofHaRTF4H+K8t3trrWUiooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674850; c=relaxed/simple;
	bh=vBp5UnmWa1ZOCL5yIw1xSzs8AatCefvgF3kH0ZGsibI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsK4U1QHDwmGRI5VGWR0uANVa/E2R4BGU+1oWV0Wyb3keJFNN5MRsMcXWJpn4tz7FknlUooOgqfSnwHWsnj40ZA3zmZuLwHjyKsoFyVEKsyVqPkHt09Piha1AweGcWGC3K5oHo3bm8RXe7smtdmcSEqcAdqlh0KK38fb1vUVVWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm63BSoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm63BSoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63231C19421;
	Wed,  8 Apr 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674850;
	bh=vBp5UnmWa1ZOCL5yIw1xSzs8AatCefvgF3kH0ZGsibI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm63BSoq2E86tYWG46p1s/77OPHs9MdtbHm5ByLsoXgF6OTmZsWiZ70yNLV6P7HgC
	 GHTy8jQIpFpwlNCIzQz6DmkymXadOKTO137nlrHKnL/xpuMWNBSLl9IZSCGw2yAjUn
	 Wl3wyNjLQ0f1xmey+++4U628Ly+94f019lLgwM7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.19 258/311] comedi: me4000: Fix potential overrun of firmware buffer
Date: Wed,  8 Apr 2026 20:04:18 +0200
Message-ID: <20260408175949.021236431@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


