Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055266;
	b=RpmOuBnEwltraIwFnKSpsZAH8ybB792EIMuem8CqkizSoNiNFSwLnLL0xSNG034zAJp0
	 v4hr/vx60iFOzoN835ATRkwwSH0sM1mkCQCZjV3HAKIjCDje+6Gr0CvCuG5rHmpfEJmy0
	 nxNvrE/NXAvm6lfos1XAK6ph9lR9b9Uf1Bz1YhnOQahqtwIblFifqE+EAqebfZ8qSVdRN
	 d7pR2kdot2mWI6J8l2Wiqxaml15jOi/a/WLxKa1qligilXZY1WRGKRgtoGNQuocvxEKvt
	 dgh4Od1OKOxD65WjZUbTkcKJsN0mEch/CmCfFrcyDSJc6fyPJbX4gSA9cSwyejOBD/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SLMzeymIPQj/inP3AQv3icMcedUa12U6mrQutnz1SL0=;
	b=RjL9I7oezRgYDyS1emwBR1NtA4NycaewdVewyFCMwVwzwNXUJih5lwk5e4C7z78Rp3Mp
	 ZSCMXJnj58j9Ab2x1k5HJsPGCQ3IZT8k9NL0hK2i8g2FFpAo+8sctxx0v5aYfEyxbrOwZ
	 0xClMV07LDAAvxf13O9MBemNpBeiW1Z524nTMNNeqfo0gdh2p/0u6dqrAzf1F707pFWSI
	 hhd/q8M5LbY6/jICOXdf33d/HkgHQqP2iUSb5gZ30CdhTQopXBAXIh2SVLdecR7NGP9fC
	 /OcF9BbbsqvyR4aPqhDCWuID+6EOhVyiuxZNsjQiUZtPyIEJYtAiSZ0q9wGK2YvDDxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UKXhs/jk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D4E606A325;
	Thu, 19 Nov 2026 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKXhs/jk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27031F000C8;
	Thu, 19 Nov 2026 02:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055266;
	bh=SLMzeymIPQj/inP3AQv3icMcedUa12U6mrQutnz1SL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKXhs/jkr5jvY8FXTOntRPumnxpzOMDJrN0Y/T+iE04uBNBoiU51nm6Zfa6oex15P
	 HAwd+rwqlH+P4YqQ8NvWSIYhXKRfpUM/fQRRmw0HQH5lEeauq65tUqawNYJ+WYevI+
	 RhCUM3tTa3sKENl8L/XbNxZaSDJVoWrfbHZaJ/ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1570/2214] swim: Dont start motor until medium is present
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150114.857078780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit dbbaaae83cb277d76e70426c0f0ce289e867ed77 ]

The spindle motor should not be running when a disk is to be inserted.
Don't start the motor while the drive is empty.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/7ea60e0bf6135b9bcd4be0991a257d4c5de22bb3.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index ea64e386d2f16..ec2191ddda847 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -632,8 +632,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	swim_write(base, setup, S_IBM_DRIVE  | S_FCLK_DIV2);
 	udelay(10);
 	swim_drive(base, fs->location);
-	swim_motor(base, ON);
-	swim_action(base, SETMFM);
+
 	if (fs->ejected)
 		setup_medium(fs);
 	if (!fs->disk_in) {
@@ -641,6 +640,9 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
+	swim_motor(base, ON);
+	swim_action(base, SETMFM);
+
 	set_capacity(fs->disk, fs->total_secs);
 
 	if (mode & FMODE_NDELAY)
-- 
2.53.0



