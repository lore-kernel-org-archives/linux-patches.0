Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040023;
	b=JlckjitsX80ZGxzoMh43Aqxxfr+eJq5kqMKTivlUyQP1GWXmbl+WA4wwbOiI5IY+2qOM
	 D5CNkSpm3ZSKmlRalM2LBDIgYcq8oT7c1RrfGx2UGwwnOrhH2VFwZpGTo+oMMm75MsO8U
	 FWA36XaxhxOwK+ch8SO8GhTES18lajjxcjFWN+CUhDbYi2snpHkZR9XFSgrXVxkdjnUhM
	 hjGdQ9fkedCUncxW7ogoNz21/IWMnOWcm8yA4hgdlDfdqsDKG3V0tw3OelKdFAgNv7b4o
	 9nBIDNwV5062BbHDiLbD1OWwAIEaJpJtFpZRtfaLxYirV7QdD08o290d1dwrYM3VY7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hjHKcQHTmJwsIt7Jg+T/wspwHmekYkZm39oH1BLNUA=;
	b=Ag0JfMn7xwA/StzxuB03ieKvfyHmmpg3vJvwsuuP4HfJnjYm6JKEqWpK0jngfophHpKG
	 8aQ7Ey1/sZipu2uymUY0EMIpaIf08Me7+JdJgDLOEgpThwxYGw0m5wmnp0+XZML2KxJtJ
	 MyKcmZfei8eaFZ1PTE3o9KYL1zCsFp3XGNQPFXCRnFMty3OQOl1s9XGfNIC/dec4RNK2Q
	 rIGI5mv8ck4RtHFQic99HBTT8vH2+jlWlgk6wLqmM8nTz63Wq8ncvIn9O8rN/y2Yvbb/q
	 5QxUnE0bo4Yb6FZiNeAZAPhfxnWJRr8v2tp7o8esNfcTWg37U1tvWqTlXb5rtyuo6cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ytdtG/qj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E58606A31C;
	Wed, 18 Nov 2026 22:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytdtG/qj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91C11F000C4;
	Wed, 18 Nov 2026 22:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040023;
	bh=/hjHKcQHTmJwsIt7Jg+T/wspwHmekYkZm39oH1BLNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytdtG/qjYGbJO1wpA+Y32qjGt1k7VS+sl0pCuhK7rK7FUPa+rcboPnBDJ9UU3henp
	 zb/Hj5S9Ej5y0nGlCDvoehg5A+NakdBSdvN/dzQnhmQ62hpngAf0aS3tzXtyVN8ZLQ
	 CdXXcW6Or3b/ckhn07bMRStojo2oB9vtTsjGw+2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2308/3318] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118150430.940003511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a2d22b3f25c388f9fbce7bf36a45a8900dce4aa3 ]

Before turning off the spindle motor, call swim_drive() to select the
appropriate drive. Remove the swim_drive() call from swim_add_floppy()
because it was already called by swim_floppy_init().

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/370f73fcceb53ce4860904ce6cf4f06ade0e43d5.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index cbf93d4873eab..73d360854ebea 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -679,8 +679,10 @@ static void floppy_release(struct gendisk *disk)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -752,8 +754,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



