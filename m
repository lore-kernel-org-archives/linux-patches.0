Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA1B1E9919;
	Thu, 20 Aug 2026 16:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243694; cv=none; b=fyuRMBzpvxjOhY2AVt+IJfZTBw0icyT1hJwLna8zGG1XbNuz4r8xdzrU1A4P922UbYuFMv6KHNep4D+KIlrWEkMZqQ+vVUZjJKHViWQddEk6lgOdkSVmSX6XrUf5RH5nRPjalbF1ckZAfd917qT/GOHXjVhzEofSuVin8S/2tBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243694; c=relaxed/simple;
	bh=RERr08YhW/v49D6KOnd7YxeckykjXkM2SGIr0PYz9Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwT3bFLEow79azxeBcIE/ATrph39aHFz0lY+e6zu8axUSnDyCAuKq5jq5WV0uXxf07MgqB9GZLc5psALTQeQgbNgJ3aAbFUQySC7gAR3Gzu52m9BBOfDxuITg2DVfANe8jl2Uo9Z59fZ6ILTom+So3x7Ap/oxUKzR311Pc0fGIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cHQkCZSC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cHQkCZSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672791F00A3A;
	Thu, 20 Aug 2026 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243693;
	bh=41Fy7g7A+pwknnkuzidXvH45ixs+p5PW3898MrNPUwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHQkCZSCLZk0/XY9g4hTbXBuswxPrRMj46l40MGa5T4yVZhcanpx7aw48EUOh8tKu
	 ZHYFCVxOohWHfB8MIhp7YP0tU9eQmgacz8Xc/rTwtZKfWrOs0O/cipYaZIdG9lQDuU
	 Ni/X/pCsf2SSmL7qYIikVGepwLevkIVkKj1aNO6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/272] media: marvell-cam: fix missing pci_disable_device() on remove
Date: Thu, 20 Aug 2026 16:56:07 +0200
Message-ID: <20260820145236.956663500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 033ff0420e4c9c240ae5523fff39770298efa964 ]

During manual code audit, we found that cafe_pci_probe() enables the
PCI device with pci_enable_device(), and its probe error path properly
calls pci_disable_device() on failure.

However, cafe_pci_remove() tears down the controller and frees the
driver data without disabling the PCI device, leaving the remove path
inconsistent with probe cleanup.

Add the missing pci_disable_device() call to cafe_pci_remove().

Fixes: abfa3df36c01 ("[media] marvell-cam: Separate out the Marvell camera core")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -610,6 +610,7 @@ static void cafe_pci_remove(struct pci_d
 		return;
 	}
 	cafe_shutdown(cam);
+	pci_disable_device(pdev);
 	kfree(cam);
 }
 


