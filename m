Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F12472F97;
	Tue, 21 Jul 2026 19:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663500; cv=none; b=HCeXGCy6fF0Ecoya7+lnTJ982IK4teBvyMmWt98N8maN9wBb+kTbWI/UDQukLZPzOMvZjVMhd0pGo4fueNtYuNRP9mbpb6J95hZ/G1t6eg+vMkssGZaZLN+leB3E+ZP/99JV61ccX6jigwnp8jKdY6VBLQMYlG1S6auRvqeQ8rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663500; c=relaxed/simple;
	bh=VlRDZsW3R7ootmI//Euzr1waBJPsy87l26yNCzRBosw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW93V3Lmz3fRFWRFVurzfpqA8YMUL4v91EluouHgydoCODqPdZCIQI8XHajUmu3cbSaoGdzkJuz3L/RjM6Z9RYS+BthtLgEus/0hf8r9a9nhkpHjWHtylW+lu4E4x+NHC+NCUjHgFEAxKO0CN7+lMRoD8CTX7SQA0nQd4wrwnBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oN7I0chU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oN7I0chU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B46F1F000E9;
	Tue, 21 Jul 2026 19:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663499;
	bh=dFo8zPtw1B+zk4ijytGdd+9n8qFCxNnbGc07eNylXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oN7I0chUtyFZ7GOGFdeHUFLzoiOLZDiITe99PbeuMhd/E0VvPJ/j7ebdtT4f2JDCz
	 r9/qG6qdiSoy/gAb01GcyzMxPZCOZYfUu80uMlTZ5AE061/Qoh2FJCynEiryInF3ke
	 T7WhVIzqQ9W2QsxMoNHQOHTip+J9mh7a3Lk2243s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0847/1276] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:21:30 +0200
Message-ID: <20260721152505.008602445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit bb019d755366cc3e777a12d4bf457ff289837370 upstream.

In tdfxfb_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() when CONFIG_FB_3DFX_I2C is defined, is not
freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 215059d2421f ("tdfxfb: make use of DDC information about connected monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/tdfxfb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1550,6 +1550,7 @@ static int tdfxfb_probe(struct pci_dev *
 
 out_err_iobase:
 #ifdef CONFIG_FB_3DFX_I2C
+	fb_destroy_modelist(&info->modelist);
 	tdfxfb_delete_i2c_busses(default_par);
 #endif
 	arch_phys_wc_del(default_par->wc_cookie);


