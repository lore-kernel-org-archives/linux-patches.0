Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0CD38656D;
	Thu, 30 Jul 2026 16:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428083; cv=none; b=WKYUUfDu8XBL7rYSMJ/Yh2y5YmIs/7ohVq68f2jQvD2fz5rb7xCGX3Gc2UkoVgO9uAW9cWh2w1rMGfYIHTTpKRukX2mSDQP5OQkGWztgKimIYXymNPfexG5ff8Pa7cxEmNIb9yGfi1s3aZ50dmzHBHiUhF/CcO6GHYHaQ2NjU7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428083; c=relaxed/simple;
	bh=RTdkZbUg2Nmkt4sbuC7nVTpdZeP4DaehlBEDNtjnbRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIRVpwf39XM3EBAx30reWo3ZYx6Kln6bqfyoSKgLtQ4l3I8xQwgOoAra5LIVJ+PsE/dZR+zvHd/wHqXXv+CZlTN1if4b+DkGJ8ZmD29L2MQnM7nj8M9MUXJ0h3dpPeoAcBtf3VCjGFGqKyoVxl7CELXyoeJqAiFEgbft3WbNMXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9asoxBT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9asoxBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F00F1F000E9;
	Thu, 30 Jul 2026 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428082;
	bh=R7F3oqzJvAOyAVDcZeIhyMF2MZbGkBPO0/+6HrN4e0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9asoxBTI3DIsmjiSB7dzu8XtyzQqbGsYAdwgq2mkRUuahm0lxNPaivv8c7V2lFMH
	 /YCtLe3I2ZMrsom+XGBLxuQm8na93ByiVgZwhmpPcMTnEaQFvuCYGO6uDSczfEfO7b
	 jfsYMh8+suRvYPZiTsLekgH6LCsIGj9AttTUTXtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/484] fbdev: efifb: fix memory leak in efifb_probe()
Date: Thu, 30 Jul 2026 16:14:54 +0200
Message-ID: <20260730141432.099966119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 9b6eaf101656958397a6012bf43f6e2e42c9e5cb ]

Since commit 73ce73c30ba9 ("fbdev: Transfer video= option strings to
caller; clarify ownership") the string returned from fb_get_options()
is expected to be freed by the caller, but the string is not freed in
efifb_probe(). Fix that by freeing the option string after setup.

Fixes: 73ce73c30ba9 ("fbdev: Transfer video= option strings to caller; clarify ownership")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/efifb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -375,6 +375,7 @@ static int efifb_probe(struct platform_d
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;
 	efifb_setup(si, option);
+	kfree(option);
 
 	/* We don't get linelength from UGA Draw Protocol, only from
 	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not


