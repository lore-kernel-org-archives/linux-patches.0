Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD947011A;
	Tue, 21 Jul 2026 19:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663486; cv=none; b=uToILkhHKs03T+c12Y39VhNN38StSrhO8zlIXThQ5sS0RAnDmP7PqMGi/YsQGh3W3Qr5Bds86mlYRvQOr9kdWzJfAep/sg4bmmY96yQ1QGrNS6vtUqAFSZVnzTFeSmlHchY7aSu+2GVX6ccWeBrgWH1GJFiFNOB44K70VT1wsJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663486; c=relaxed/simple;
	bh=N5fLt+cN3XsGMPAI1AC3E+sSD+GbZ1K2UQk3HcljDh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNDrYNHSd3TQMmBYYRrbaoKstwvZhzC3rc/piY7I29X5+oeAR+LFR0FMY9NhAch65LxlpoeOZRaY6tdOrY+q4e38b2Ud2XiNiCEOCWuJglCT0AeTTm4D1Op8NNJ7NyyFu/eHV6jUmTj0/LlBfhst9fBaz5D/eIqbcdZaN0y4c0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dffkPjHp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dffkPjHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE1A1F00A3A;
	Tue, 21 Jul 2026 19:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663485;
	bh=livOjlEtejC/oOLtrRsEccaY9sMzuX9EWqPH88pdARk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dffkPjHpnBImWmsxpbLZSmYm4Q6L6fyvHKSr2PUzGSVCaBdxOokSwYhpt8rJCmNF+
	 wUNp/+OnmpKghO21kYxsy5LEb3NTN3cSehlla6zrVJZsggumfZaG43xhhALN8uDxKW
	 UebKqftKMWSArzdcztFPliJ85GcwHaiSlzRYGah0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0842/1276] fbdev: efifb: fix memory leak in efifb_probe()
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152504.897735508@linuxfoundation.org>
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


