Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C029334D397;
	Fri,  9 Oct 2026 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556335; cv=none; b=k2AuocxRdr3JvmzHArJjhdYq2WNSHGWWLIR/G1nJec/NcAF6IpVrgU30SxWmKPpvcohWmZCiToTchdtXYxsoLFsPgkehzZe8lQrzangQE3dYptfcr9fTTxApZ4BSduI2xWZF3PthjZt6ub/Y+I0biQyvhRGj+wxdn8mriwHq/2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556335; c=relaxed/simple;
	bh=9xcvrZBOhEDwf7pjaDkCnP5RuuT+pfpWFNimLpr6AsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rw24CmTlbXDqAUFKK3estr2t9ZBwCYd616ANHMXx52lAsGX/oo6H+WlMc6IWD33feh3f7eCo99QvN057IDDZ3yyPFBrabBYhjfMA/pZRJsnM8Ipr9ZgP9Xs3LmmQDS+4DrfdxWdDFYrBrzlljqCmCLRY0f6+a4c8CuCsIEHVuXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnlatHsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnlatHsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D251F000FF;
	Fri,  9 Oct 2026 14:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556334;
	bh=2/m1zgTAqe3BpfYISPiAAsBwDQMWdvPgZI8zB4irrD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnlatHsj0i3fzT/BQ41ZkmeZHn/1h+5eMWL2Qqwf1oC9QxD20Y52/PHMaESG9enDY
	 nbp+53zuz5xsnAo8PPxh5K+H3evULbJgv0V7WcsR3CeAh9XAPvYVumuuL7KVXcMAQv
	 /jHw737Y8d0BHWp8lfHOTIKwN54zNUevHGQbzV6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.18 217/403] EDAC/versalnet: Drop remote processor handle refcount on driver removal
Date: Fri,  9 Oct 2026 16:09:38 +0200
Message-ID: <20261009140957.218926982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 5f43a2d35d5e748c09a50a98fc766dc95bb3a6bd upstream.

mc_probe() acquires a reference to the remote processor with
rproc_get_by_phandle(), but mc_remove() does not release the reference.

rproc_shutdown() only balances the power reference acquired by rproc_boot();
it does not drop the device reference acquired by rproc_get_by_phandle(). As
a result, successful driver removal leaves the remoteproc reference
unbalanced.

Call rproc_put() during removal to release the reference acquired in
mc_probe().

  [ bp: Massage commit message. ]

Fixes: d5fe2fec6c40d ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260913053532.1324671-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -938,6 +938,7 @@ static void mc_remove(struct platform_de
 	remove_versalnet(priv);
 	rproc_shutdown(priv->mcdi->r5_rproc);
 	cdx_mcdi_finish(priv->mcdi);
+	rproc_put(priv->mcdi->r5_rproc);
 	kfree(priv->mcdi);
 }
 


