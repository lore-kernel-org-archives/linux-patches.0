Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C78D146597;
	Thu, 13 Jun 2024 12:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280228; cv=none; b=rx3f6ixu4NJ23OWJMZ1QNfrLKAt2V8Ne5sX88rUbmuhFkgkTQlr1U7+y2xBbIp2KDyATpWPi8IsYeo6jear1nmTFqNQFodSZJ/MUZol7h9E40QyWrTNMGCdKV/QQqEc5meqWWYiSn+pFE/irvCFDQhc2xuilUfOefoZD8zkr24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280228; c=relaxed/simple;
	bh=mrFdc0MtG5V7lKHJbTehSRf4NQHoKLCJtuSsrqFXyeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWuYybYkdtMhpc3joXtKh9w1dsXwgjFbOaKTVp8HqR2+O6wa0GwePb1w5kmg6gEVNsegxlBzGHiKCrBbnsLuXWNnvt50yFNrPNPR8uKj7wS8tuLHjaK20n+m4WRZTyJAhbboIbEfTnhGFIoiLXQxVwbbw4lND/+1XM4djvnByZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMXnNuIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMXnNuIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87735C4AF1A;
	Thu, 13 Jun 2024 12:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280227;
	bh=mrFdc0MtG5V7lKHJbTehSRf4NQHoKLCJtuSsrqFXyeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMXnNuIcGrSipSk7Z9P1EfG2en0xiJ85PedGLU3VwTb4Uq2zFxX+UJ8pEh7wAKS1l
	 kBP+KFwgXAvuIpzb9u7f6Fp9N4aOlb15IzJo38XuvOriwTpfn79hn08AXrtUi5bFwZ
	 k9pMVjge6bXBgvCkvyMkzwmU+eGhlrIh2KJHYRHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 184/202] fbdev: savage: Handle err return when savagefb_check_var failed
Date: Thu, 13 Jun 2024 13:34:42 +0200
Message-ID: <20240613113234.839027124@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2273,7 +2273,10 @@ static int savagefb_probe(struct pci_dev
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


