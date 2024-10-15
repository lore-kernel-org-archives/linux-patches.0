Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F521C07D4;
	Tue, 15 Oct 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997187; cv=none; b=Sfc12l8lr4IhXEuOUbIYljVrS+yKeEdmiVhtgVrvOawZrlnREYD8irKVNGmG/7SBcEnyDV9WHKEaW57aYQa4DA7P1JUcWcgHYakCvzbYjdPKK2SCtBNbOyKnaOgdogRy2RW38EyhUa5vpFDndgI/0alWmKOuauOLC3+4fS8sc8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997187; c=relaxed/simple;
	bh=5ZLW8mbmqugHYxo1xyd4soVKe37e0U3otfaDqsfJ1jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOzaPhab2cjwgYxrScMu3LU2cULMhfn1WrBiwiJMd0DGsijDlg1Urc983PAhZb3+V78pNl9BB3AL0gi/1XWTAs4kPfK2I89LcRAGXLTsejsmIOpqqvnW0QylzV5ecOFUna6cSnIKrve68fwsr9Nbf2dOhZ1q1N7rBfbuKZaOGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKujm7TT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKujm7TT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A612C4CEC6;
	Tue, 15 Oct 2024 12:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997186;
	bh=5ZLW8mbmqugHYxo1xyd4soVKe37e0U3otfaDqsfJ1jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKujm7TTvfXX1i8tuMr8nhNphg5revvdZZUave720CW4PFPXkcsRKzuIJbZV53zxH
	 KjVSyKH/5iOtKE3URy2ZVdcrzGxBxxSCHBSRMA8fUgvRqW6UK2NhMR/n8bQ4LECTgV
	 o1HSZBi6CU1MOH8UjrpLQZJLBf/ecl18Tnz7JaRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/518] fbdev: hpfb: Fix an error handling path in hpfb_dio_probe()
Date: Tue, 15 Oct 2024 14:40:16 +0200
Message-ID: <20241015123921.321602366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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



