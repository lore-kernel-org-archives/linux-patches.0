Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46ED3A16A0;
	Wed,  8 Apr 2026 18:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672729; cv=none; b=n3nQBd+B03yhJwvASJDS8To/AD91PLJHMH23XcEtX5XDMdws9bNGvLKwUhOKfgDt2wXjWbqxQAnjICRcVNshB7LzbH2VuNJszBQW9QfUYBw9M9Fg+eLLCZMUgey4vO6mgK3OPmoXvfJA4riCuhQsYz6SHeuzpldrblJYGhwpGyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672729; c=relaxed/simple;
	bh=I6DoBRU0xVRmGcteYsnuAg2CdscR3NGdYpxSlrYmQV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azBYiA3ueZzGMK1htTgE6nu8FVjIeRHamrIjUPBV6tpYbRPWyD2cHPLsuBYrcXS9RCPTHYpDjWizfDHgNaSbnr6s7247Y4vZ3LAw/Xq7nVSU8vEiol0SOReQlDbIBpTrSM73/IsOIMLjXj1jJKPeFH5rIx5rxQHJS3bFbqQRofQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrahNkNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrahNkNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03186C19421;
	Wed,  8 Apr 2026 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672729;
	bh=I6DoBRU0xVRmGcteYsnuAg2CdscR3NGdYpxSlrYmQV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrahNkNgQjHZMbdBT3edGyggk4RKjpVNbvQ5x4Ha5G22lpn5EIAZ2aXW9TJoc6CIr
	 4Tn3JUuSR/bTckXVs/RPswf3uKtI69qRanhlRzprRMjgSb7kUfSes3xrTCoKn0cEbM
	 0Hbw/5ifrTE8fR0342x6TcoLcBpehEupc8P4cLvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.6 119/160] comedi: ni_atmio16d: Fix invalid clean-up after failed attach
Date: Wed,  8 Apr 2026 20:03:26 +0200
Message-ID: <20260408175917.635992101@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/comedi/drivers/ni_atmio16d.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -698,7 +698,8 @@ static int atmio16d_attach(struct comedi
 
 static void atmio16d_detach(struct comedi_device *dev)
 {
-	reset_atmio16d(dev);
+	if (dev->private)
+		reset_atmio16d(dev);
 	comedi_legacy_detach(dev);
 }
 


