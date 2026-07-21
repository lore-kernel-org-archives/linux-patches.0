Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90923E63AE;
	Tue, 21 Jul 2026 17:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654114; cv=none; b=NXeBDPhfteH4eRiYaV95kN0mfcg8OBufd2u0ecnkn/9TkeTkRQqjI5hPauHRziRVNcUPUndOgAn8uf3W3kux5RoHOL4efycDQGI2hatgioD1inDwzjLLHJQeyFu1+5DiNNfpPUtKgfilakUZT/FQKxNFGzzNcAHHqKGjQ/mRH4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654114; c=relaxed/simple;
	bh=cV1FEU92iEoiCEo0j/9jfPxrcARz7v3RvR3y1ewwyqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVtjpZhsXU3m6Cb/4AQzZRtYdaCr4kswaxlngMaCEf76yCSbrtFmehdVHnW7pE+ekcthOWulYdaKFJFER2yRx92GsQBU6vFUCj6tcd/b4X2r/d2ufuyZJJEhgRT0+Z9WOghugX88YlkV3sC2fofIgjbsTUuDUVghaVFBOPlEp3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrWozxF5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrWozxF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82DB1F00A3A;
	Tue, 21 Jul 2026 17:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654113;
	bh=jGHfjr307AiCt+dVGl4i/sdOSo5pisV9POkwcjVLlJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrWozxF5PujkMbqFe8Yilb1DZ3e1O83i+GYqonlRECY434JrT7V1z+nn3IccayAj+
	 iUMDrrWIQ/mduHV0PtEdsR1ZfRk03BnQGfTJSPvGrQWPboIMQtzELdbMxApfsAHaHs
	 7BJ2LDGB0KFgDN9NO2AMdvD8TqHB92AhVKWyphes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.1 1583/2077] fbdev: efifb: fix memory leak in efifb_probe()
Date: Tue, 21 Jul 2026 17:20:56 +0200
Message-ID: <20260721152630.111784006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 9b6eaf101656958397a6012bf43f6e2e42c9e5cb upstream.

Since commit 73ce73c30ba9 ("fbdev: Transfer video= option strings to
caller; clarify ownership") the string returned from fb_get_options()
is expected to be freed by the caller, but the string is not freed in
efifb_probe(). Fix that by freeing the option string after setup.

Fixes: 73ce73c30ba9 ("fbdev: Transfer video= option strings to caller; clarify ownership")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/efifb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -377,6 +377,7 @@ static int efifb_probe(struct platform_d
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;
 	efifb_setup(si, option);
+	kfree(option);
 
 	/* We don't get linelength from UGA Draw Protocol, only from
 	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not


