Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CEA1C7274;
	Tue, 15 Oct 2024 11:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992576; cv=none; b=I/IZ1Stq7d69sNF+Wo+dP3riBfdsUan+jMJA1vk+hkZT48WYsiu5yvRz3X6geRR/wRBssOdpZSfGHaiEkyaP/N1keuExxKvDcC2yGqKoXtHZEnivAPKhVEvc+1ZrqbM1zB4DBq1QP4QAGBu0/ZZ5FVactq+8AVslbuhTnnYMfZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992576; c=relaxed/simple;
	bh=y4b3fifxRvSM9QMw/QqxT1PFY5cl+0fZfVmVTy5MJvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWIzW0kIvQQiefH2M0igpiu4Ku8lmYDV5aejuRH3qLJV9wRLbw0BRw8p/lMkvLq/UroWdNNVJlPEwLoh/4ALSd+EslOBDEQbHPIb3bRFZrz4cBZizrnQDsHkwNX1tr44bI4ugFjAVagsLx5sW+719qBIxJzvHWth3MGDK7b+Zto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MszBWc8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MszBWc8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531ABC4CEC6;
	Tue, 15 Oct 2024 11:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992575;
	bh=y4b3fifxRvSM9QMw/QqxT1PFY5cl+0fZfVmVTy5MJvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MszBWc8CrNp5773q8lIlDSO+OEdKUxtDlTVO94+RizThNyFfvFia0bzS94pWI2Eco
	 tXBqVhIlg1duZ7UI5WcaJPVN7c5XTe1//cIRVaelZBFpS6o5bmhKryd43uor7hrmM7
	 D9rx1hSwS6yIva6wxdjcI1dKGlsM2qFHiZY7w5iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/691] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Tue, 15 Oct 2024 13:21:45 +0200
Message-ID: <20241015112446.592745432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit aa578e897520f32ae12bec487f2474357d01ca9c ]

If an error occurs after request_mem_region(), a corresponding
release_mem_region() should be called, as already done in the remove
function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hpfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/hpfb.c b/drivers/video/fbdev/hpfb.c
index 8d418abdd7678..1e9c52e2714dd 100644
--- a/drivers/video/fbdev/hpfb.c
+++ b/drivers/video/fbdev/hpfb.c
@@ -344,6 +344,7 @@ static int hpfb_dio_probe(struct dio_dev *d, const struct dio_device_id *ent)
 	if (hpfb_init_one(paddr, vaddr)) {
 		if (d->scode >= DIOII_SCBASE)
 			iounmap((void *)vaddr);
+		release_mem_region(d->resource.start, resource_size(&d->resource));
 		return -ENOMEM;
 	}
 	return 0;
-- 
2.43.0



