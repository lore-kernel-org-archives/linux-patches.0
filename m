Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358623203B6;
	Mon, 13 Apr 2026 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099589; cv=none; b=Km2eJGNkylGQ0jBa4meSP5T4bBDEQ8Q+EdFn39RRb4RhXWPBpK3XaQBNPxUne8crPhHCuzWa9TPlwuz6QBa9dhBRSGZu90LdcMTaw9BPKjg7kH7PEeF9zVmDOKUlYn3V4g2Xz3g/nWwf3Ik8Xe5MYL8fmNv7NdpilRv+NWH+k8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099589; c=relaxed/simple;
	bh=dRFSvkgHH4SWxDfEBngue5eE7FOH+5A+QSh3RtoCrRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uhe/Qc5xwlFjCLC1buHa5AHpl3QBpBfCugPHU3Nxpy6VArOC+Eeb4XKtcpiv9MndY0UTayFceLANa0s4QoAxHvt8ewmzc0MlHxhu9fU+rOF3f8xsNVmMIdvHf9xHfX35c0K8qQ+vTJ8cA0ULnoTw63MIW5rT0qWCLH7J3V4+KSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NF9BQ5da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NF9BQ5da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF950C2BCAF;
	Mon, 13 Apr 2026 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099589;
	bh=dRFSvkgHH4SWxDfEBngue5eE7FOH+5A+QSh3RtoCrRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NF9BQ5daDcDd0+jRieJy44JqoTJ0+cK1+w1UHz6z75Ia3vN6gPPPSgyLWh118BG9/
	 cbvt5CNr8vYWKGKRmsTOCafILG58rTodlI2jxiPQAeA8ZFj/gPV6DJk5LQvxnkcgGp
	 TJNMf7eRXsZfbTvygIJ5rI5U7xQL/VjHG9Q5zz2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.10 399/491] comedi: ni_atmio16d: Fix invalid clean-up after failed attach
Date: Mon, 13 Apr 2026 18:00:44 +0200
Message-ID: <20260413155833.970861124@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 101ab946b79ad83b36d5cfd47de587492a80acf0 upstream.

If the driver's COMEDI "attach" handler function (`atmio16d_attach()`)
returns an error, the COMEDI core will call the driver's "detach"
handler function (`atmio16d_detach()`) to clean up.  This calls
`reset_atmio16d()` unconditionally, but depending on where the error
occurred in the attach handler, the device may not have been
sufficiently initialized to call `reset_atmio16d()`.  It uses
`dev->iobase` as the I/O port base address and `dev->private` as the
pointer to the COMEDI device's private data structure.  `dev->iobase`
may still be set to its initial value of 0, which would result in
undesired writes to low I/O port addresses.  `dev->private` may still be
`NULL`, which would result in null pointer dereferences.

Fix `atmio16d_detach()` by checking that `dev->private` is valid
(non-null) before calling `reset_atmio16d()`.  This implies that
`dev->iobase` was set correctly since that is set up before
`dev->private`.

Fixes: 2323b276308a ("Staging: comedi: add ni_at_atmio16d driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260128150011.5006-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/ni_atmio16d.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -699,7 +699,8 @@ static int atmio16d_attach(struct comedi
 
 static void atmio16d_detach(struct comedi_device *dev)
 {
-	reset_atmio16d(dev);
+	if (dev->private)
+		reset_atmio16d(dev);
 	comedi_legacy_detach(dev);
 }
 


