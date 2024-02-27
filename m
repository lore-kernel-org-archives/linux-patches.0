Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A749E13B29B;
	Tue, 27 Feb 2024 13:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041629; cv=none; b=NkYd/H6/730mhd335TZZ3Nqtgjq5vsvvIFeQhPuTT+toA2E5MazK/bMfwhaYFgLDf6YB26i8/m5GMZdfxlQVQHyagR1RlB0Je5lWzPiZptncQyKdbKewEI1L8XN5n9U1GUyAUA/frEY28bTVKxjdIXhNfG8f+8hsnnnc7D3Bnvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041629; c=relaxed/simple;
	bh=jMJG2Wyx08WMwLyUfwYyAdm6slkfCugnt1930pWZB4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI0lg8oLpcfcEV/Ay/Jx/KkuRfU8Zn/49CveJbQgmloHK6MMB/hL6qkhE5D4guU0bUoBHw/C2aM4JaVeLBAoJgArQzvETIoNHpe+RwEZwOLTIeqEFJNnRuzERD8UVh3jdihVQQr67Rp155cUF4F00nK93sTM/EEo6RJi4Tfgr2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAiGKqxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAiGKqxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33091C43390;
	Tue, 27 Feb 2024 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041629;
	bh=jMJG2Wyx08WMwLyUfwYyAdm6slkfCugnt1930pWZB4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAiGKqxmL8YIiEEwcybn1HU/d5Lr63H1lVJxBs3Dvn3YSyHKQrYXiwh0YztRdFPAI
	 sHuz7QQc3/jZi0n0/9uwwI/6UL1b/Gz+ElpdpCXseCRQHVdQch0KlhVozUgoEgEkZS
	 EPoT/wkmNCnbOqlD1SDaCK8ainMDjipJhUF91RnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/299] fbdev: savage: Error out if pixclock equals zero
Date: Tue, 27 Feb 2024 14:22:07 +0100
Message-ID: <20240227131626.356677669@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit 04e5eac8f3ab2ff52fa191c187a46d4fdbc1e288 ]

The userspace program could pass any values to the driver through
ioctl() interface. If the driver doesn't check the value of pixclock,
it may cause divide-by-zero error.

Although pixclock is checked in savagefb_decode_var(), but it is not
checked properly in savagefb_probe(). Fix this by checking whether
pixclock is zero in the function savagefb_check_var() before
info->var.pixclock is used as the divisor.

This is similar to CVE-2022-3061 in i740fb which was fixed by
commit 15cf0b8.

Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/savage/savagefb_driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/video/fbdev/savage/savagefb_driver.c b/drivers/video/fbdev/savage/savagefb_driver.c
index b5f84bd4804b8..4ba5cd55e5a52 100644
--- a/drivers/video/fbdev/savage/savagefb_driver.c
+++ b/drivers/video/fbdev/savage/savagefb_driver.c
@@ -869,6 +869,9 @@ static int savagefb_check_var(struct fb_var_screeninfo   *var,
 
 	DBG("savagefb_check_var");
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	var->transp.offset = 0;
 	var->transp.length = 0;
 	switch (var->bits_per_pixel) {
-- 
2.43.0



