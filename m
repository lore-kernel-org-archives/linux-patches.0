Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AA93909A9;
	Tue, 21 Jul 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658471; cv=none; b=ZnYBWXf7Nncl46yjMv78LsSqv0FWkLJW6pBpaY+oYPT5O5L9FYbAQ70pOl4FbzjhXmtAtjdCPZutx4Embosg8/3YEQXJbvknkKP5Ps6Fl0XzIDjvQo8QRbKYlyF7VwNmPpSfHAV4bqjb6R+qB9pHtrum8eSjopJSGf1boX+s3gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658471; c=relaxed/simple;
	bh=NpKmHahzmSDj/DjPKEtAlQsk7w1oDdf/Doc6wxgK4f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvS73Z6WwcFN8bd1QeFbpTv3wmz749OGypO1l37lzduwZ/ePqg4zR7oAEzLpYuM3jGDhPezLUtCXDBLaOzkRKIVxg7oyHTLtTWRuMQNCbSH0rsPKJyEJQAzt/kYuzflht04CGkf0WE3v6JB6ZunL/EdSSEiHdamAaVvbTa+D5lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z98wX44a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z98wX44a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB491F000E9;
	Tue, 21 Jul 2026 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658468;
	bh=yqBgttxU6+VMGrmv2KFj1GmOhFv6LJGWniIBLKhCGsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z98wX44a59NIpMrIcvAwJPamqXwskug8LFoV8PG/hFDhPF0x5LWXTq5uB+dRZsMu4
	 c5jmKrxZgPmKMPsc32KlDeMb8AOuwP3ml7oA/Eb3qeWEFycDuh7QKjEYG8JKQaq5e/
	 8MAyHqN6lFQdSB9eQMBcSlvM1dpufut3hF40IsmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1153/1611] fbdev: tdfxfb: fix potential memory leak in tdfxfb_probe()
Date: Tue, 21 Jul 2026 17:21:09 +0200
Message-ID: <20260721152541.355674566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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


