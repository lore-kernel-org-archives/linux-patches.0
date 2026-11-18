Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060722;
	b=P4ywG/EoMftS5k1Bx2/74RIwCMyq33jIhYoDEnWyGzQQHtjb6lsClQ9YxoUm+Vw4fseq
	 AFKQXMCe5/TrrMr7UX+GpGiT9BPZeRHMKHZ0YySMolc96HKuvJXWdbMQp1OI2dDdyGO+e
	 ds86MW3lEjU6MhPiIQeePt6ADPtV7IQydxK3h3IBRiESAE17okI4Egmj6Kq37iREhQB5h
	 JWq3FZ/69finNk0z3OvHYsjxO5PU31lM9lyncClhAnguvBcNTwd1h7RNS+bq9DljW8k0c
	 lLgnpv6eAiN4K7QH07kuFQIMFQd/GNmVnuL0Jl+cngNjmgF3CPRkCcRRSZFtZbAa1tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CQtInPbsNOX0j7CK9TcwBz/53zcL/zedc6p2FlioavY=;
	b=1fAeE+MxV7r/28wOyJiCayLIQlUHSDT55ECb4r/94/ViKxh+C2XqhzbI4UHo6tk/Cm32
	 lx2/swYmG1s2HerU6+njP9ErB51qp7SduHKWYJmlVbpE4ds+GnOWPXqKnp5WHKLUNSwMt
	 EoD5IdTmg7LSMJnWlMSvKxtKFMjnaB45kG2yhGwkVeXeLvn9b5oOOprMowdTzJsNSlOE4
	 bXur0FI1ZrDb0WsgRgKWfLn4gH/X2235NsWd86cMe1amLrDv0aJwU7XQjiVL+sMcRkMwP
	 b/KpvIMeX0b6hCRJ0KJHedrw+jxkexOD6UglbZvhEdb9b1fSPG5uZPYGa5F9Mm/y3ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udgkqOPh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C1F606A325;
	Thu, 19 Nov 2026 03:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=udgkqOPh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CAB1F000C4;
	Thu, 19 Nov 2026 03:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060722;
	bh=CQtInPbsNOX0j7CK9TcwBz/53zcL/zedc6p2FlioavY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=udgkqOPhoTs2w0wyukuhkVHea7x7TVbHFeDKmoTjthP5Ytht1AdztbybX9gW2DYDs
	 xbPCtNymq0zOQ5DzkRjJw56iOrgoffDPozhIUFiHHC0RUcsoc+D3Rf/CgdiH/Se+on
	 +prsBG7raMpFeR+CA5IVrVajmfp3MKOwd3+bMM7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1302/1848] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150014.004444554@linuxfoundation.org>
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
index 35798a094b6f5..49fa12f2d97c4 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -679,8 +679,10 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -764,8 +766,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



