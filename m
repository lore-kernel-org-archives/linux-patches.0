Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F33209;
	Thu, 13 Jun 2024 12:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281645; cv=none; b=OER7Fu+32vQ28RZbjUpGHb1nzb4oLzNFOvUf28CniVBJuedhj4ZEh6SUd1EzjOoNouPgikng/1rQQdq0qEm88MAUPulsvtyTMlc5ANZ19InoS8NegQMZLkehexBoPcAAynk7FzyXyihhbXDYk68R4jBEGmuJxEFlLpeh7sw1FVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281645; c=relaxed/simple;
	bh=0AGlWFyGXxx2lJqEYhYziZM3GssaRQ2XT6Lt96GQrgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cya/47QkdX92pukFPv8oA874xG0hI+VBsu/z0MVpQY59bgsi58E+019nkKeF9Y3/hoQ1ujghUEq4Jaw4f94KaeMv9AqcbceMV07za4fES6ztTNGBAep/P7cAz23j3jLsc5fxP9Y74L/CkvR92Z0uUkBVB6I6ML+goBMh1g6YUrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO5Fcyfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO5Fcyfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A48C2BBFC;
	Thu, 13 Jun 2024 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281645;
	bh=0AGlWFyGXxx2lJqEYhYziZM3GssaRQ2XT6Lt96GQrgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO5FcyfzTBQ4mUMCAVvcqXtcN7E/KCTj0NW/9K8OaO269Fh0FYwYh4qHHrjcuDsL5
	 nthpWLh9SrLUCN3CUGC76BjyGVnCE0IPOkMPGJ/R1AMWT6bg7lyGYlGi2XdqZ44lcU
	 PvUz4+eeF7czV+dGPvseEy1fCfHD5xa2c18BsuKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 294/317] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:35:12 +0200
Message-ID: <20240613113258.923752717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cai Xinchen <caixinchen1@huawei.com>

commit 6ad959b6703e2c4c5d7af03b4cfd5ff608036339 upstream.

The commit 04e5eac8f3ab("fbdev: savage: Error out if pixclock equals zero")
checks the value of pixclock to avoid divide-by-zero error. However
the function savagefb_probe doesn't handle the error return of
savagefb_check_var. When pixclock is 0, it will cause divide-by-zero error.

Fixes: 04e5eac8f3ab ("fbdev: savage: Error out if pixclock equals zero")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -2271,7 +2271,10 @@ static int savagefb_probe(struct pci_dev
 	if (info->var.xres_virtual > 0x1000)
 		info->var.xres_virtual = 0x1000;
 #endif
-	savagefb_check_var(&info->var, info);
+	err = savagefb_check_var(&info->var, info);
+	if (err)
+		goto failed;
+
 	savagefb_set_fix(info);
 
 	/*


