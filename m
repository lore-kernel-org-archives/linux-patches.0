Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060753;
	b=FcZnULp7ffIgMEbIdVQputeNNkgIHCALxSyQa/VEhIgSXl/hRchS6BmbHOSSn+D0H/sH
	 v1zddInH5zk/ljyDddh0OpZAQ5b7XKoMncYS+rRWAgn2Bs2U9bQ9jV3IhzJpbcHFQG334
	 568zX8rhkBErL4s/8q4bfAhWTqBpho3nFluJ/C4oGxH1E0Z8wgf6UPrXqZuX/G3C8QPuZ
	 gGZd6Iyb70V/tj4/QhRm7b7rJoz/QFGDkdKkU22LOpdCo9rQ774Sfm8TdYU6r4LSSRkGS
	 lgTebzzed7njWxQBwHS/xpdx+3EV9eRGalwdM7MpykseuhndjHiaCq7+4BG8TXJUB9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060753;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UWJRkz2eqKc2f+E/VETFJH5Yq/rl6Djhb3HlMNYxzUM=;
	b=QJvTPRvuPLOoxSoKl1PDpQSjqPPa94AnsaX8ktqMY3B9mx4Wt1TmIeM+cMQfYCNMY7jI
	 htMdaJHSxzHkUL1xJpRWYTO/iEtLNXKWN3b05YmWBXyc75ipXdGGrh8IF/4elwuh6atsj
	 01Z+ynPYj7y03eOqbxFpRGMH+AKH1f7/Y05F1IGE2hgklH56DvSYPuOVoc286xLzyQdOd
	 T1rh9FHLqC1nvayxMoiat48drUwMJsEFff/TWFMCHLvadg+IEjOsV9jG4CSi4iJcaAAZD
	 XmnWf0q48djwWYJndgQV8YsIVQDVb4IyZO58aasNPPhEM8Y9x0bG3scd2NcRDqwrtWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeoHatqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F789606A320;
	Thu, 19 Nov 2026 03:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeoHatqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59981F000C4;
	Thu, 19 Nov 2026 03:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060753;
	bh=UWJRkz2eqKc2f+E/VETFJH5Yq/rl6Djhb3HlMNYxzUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeoHatqtMJrgkSVAsUkUC1S2fZHncINOuyLrZSZtpne7/FyWPOdJ+S9FTB4jycfTX
	 /+jsGolQQWbJMLYX+cTtxBk25AU+jfPZ7jvhJGYwk1rOocCEMWwiVX06eMXWPt81PA
	 m8E8pSDsRh3kjaHy9SevZc2NyKWpPPgr24XaCgfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1312/1848] swim: Handle FIFO timeout error
Date: Wed, 18 Nov 2026 15:55:50 +0100
Message-ID: <20261118150014.386026603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 2e9bcbecee68431b689d16b23bc5529db686f8d4 ]

When polling the FIFO for a mark byte in the sector header, don't
return zero if the timeout counter has expired, return an error code.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/aadb674d27d6e6d346d9b525597bf2e339c57e04.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 3d7a2d87595a5..208622ac4aeb9 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -79,7 +79,7 @@ wait_addr_mark_byte:
 
 	tstb	%a2@
 	dbmi	%d2, wait_addr_mark_byte
-	bpl	header_exit
+	bpl	signal_nonyb
 
 	moveb	%a3@, %d3
 	cmpb	%a0@+, %d3
@@ -136,7 +136,6 @@ crc1:	tstb	%a2@
 
 	tstb	%a3@(read_error - read_mark)
 
-header_exit:
 	moveq	#0, %d0
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
 	rts
-- 
2.53.0



