Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627F91EEE0;
	Thu, 13 Jun 2024 12:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282940; cv=none; b=ME9o2dxxqvNlJPtLd9pQgAqwzVTNRcIeCntsGINcaABHq2Cp+TerDOrlYPUp0JvuUJGuDUnEeCkbhWV9r4cyhVqPFcqBqRVPM/W6IhqU4RSD4BEZztXH8ERzGr4mJJ/gWGlHef33dN450sFiG0HOWpSNpEtCnqvZd48KdDmjdlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282940; c=relaxed/simple;
	bh=+ljIlukbkzKa9V3l/Ikn1Cj7d4I3W+k+oCwYsKFDhUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apEW7q6CH5CpdbPyDfB4vrUhXm5Lctj5Xvb0LRUa9mjWe0ilyDA/TLONyeU7dKaeyWNJlw59KnUGGmLSexrDh1b8imbMTGkwsD7RuCoA39rBP9D5K1MefoRf8d5i0QIvptOQ2Zal2hQsg+U0wrdupv7vkbSNxKMcjaQbw/zdH7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COI9aZCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COI9aZCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD639C2BBFC;
	Thu, 13 Jun 2024 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282940;
	bh=+ljIlukbkzKa9V3l/Ikn1Cj7d4I3W+k+oCwYsKFDhUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COI9aZCjg8PgWIZkCpS3s6jYYPAz4/xB02EnCqm8BrcRf2RKS5/AWQ+6JUV7RlbqN
	 j9aAaGs304WmpL06mG9DHvHYUPGNH9HuPN5n3rb2HndTK8W4OQOVWKNqcIYIFmpBsO
	 BuJ2xaIEIXBTrQ9XCydrIOwBmuKt4085cQLMtNas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 44/85] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:35:42 +0200
Message-ID: <20240613113215.844662381@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2277,7 +2277,10 @@ static int savagefb_probe(struct pci_dev
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


