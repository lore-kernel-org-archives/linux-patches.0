Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039984;
	b=XMa4CCxtKZRS5xz+ElESywGkWEBdutahnGrGPL5RyKWJ5MDv6Z3eOhzaA+yqV+ws8ELC
	 3EKxJ//BoWUQ0fLucVfELmQ69OxUYKuywzFAmVQY1SmPZYHzfEYf1xtQBB9i+7Nw+Nva0
	 iUdpMqooApMyQiFwvmlJhrprII1eiwmgtl6naEA1Bsf7atzMt1b08h76O7s0c9ahl3tvc
	 qwCb1SuKziMDHpYFzUTBSDozlHVV0czSByMMQQDJn7rxA9ALfTF024F9l5lDzlktrk7vM
	 Lfum3o6AHwKmFr+uD8vMFT1DsW1Nk/5uumBcQzhyqQpDlmn9rltzce5J61vCgpkuTdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039984;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3nJwlCNe4Gt0BBhx4X5/wJE9i/N5znnIJeNi0sSI35Y=;
	b=XMoUJf4PFt5uDMMGBXcCoc6ie0S6Myj12STXMamF3RMBbHfj5idS8GYKki3J1AhusUso
	 HcHo+4aYre41D40Up3DcrWaYMNuAcmNmha57kLgsoycI41ZUA51sBcLJsBLvhtr2/PZ6G
	 BdO4W7ACGXOCizG19uW3L1wKBxx0MKs6SJfLV3Y4BvCJ0e9wA+tHbsJgSKSCE97H4NoBF
	 b5T/NIfK1SY+P2R1kWqb3ZQU05lTfnoHOagCxrVRW0G3odJy4lrlH3505LWElJWmiFbPP
	 whsxLHSbUu3omctiKLfZ0UudR0BxEnZ5XgZtm5Q5Hstzt60Nt/g4SeoParhvm9eR9QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlHd9HJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA03606A31C;
	Wed, 18 Nov 2026 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZlHd9HJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15C91F000C4;
	Wed, 18 Nov 2026 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039984;
	bh=3nJwlCNe4Gt0BBhx4X5/wJE9i/N5znnIJeNi0sSI35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZlHd9HJyHdKdytVgxTxZ3ixbUU0dYPLez3rwG3Z68kQmKz1vmJA01DQjyNUGcR9mm
	 URvqHpUA7xVumyvNfOPEJ3aNa6Ch9X7XNf4w+cHvxSqUHK4uYlGnIw8adeDI/xkfR2
	 9a+uzGu2wIOghWbcQYC6BdXwJIEyo31FvVmy6ka4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2295/3318] ata: pata_parport: fix parport attach idr_alloc for
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150430.580581594@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 193f5b84a95c02456f51fe5067750ecf73d213d5 ]

idr_alloc() expects an inclusive start and an exclusive end, so passing
port->number as both arguments produces an empty range. Because
idr_alloc() only falls back to INT_MAX when end <= 0, the allocation
succeeds solely for parport0 and returns -ENOSPC for every other port,
which pata_parport_attach() silently ignores. As a result only
parport0 gets probed and any higher-numbered parports are never
attached.

Use port->number + 1 as the end so the range [port->number,
port->number + 1) contains exactly the desired ID.

Fixes: 246a1c4c6b7f ("ata: pata_parport: add driver (PARIDE replacement)")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/cee1a15d98cd0d55f41fd65ca9d222b68a74e7d3.1790047457.git.xiaopei01@kylinos.cn
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_parport/pata_parport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
index dd0936b5e332d..14662679375e1 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -731,7 +731,7 @@ static void pata_parport_attach(struct parport *port)
 	int pr_num, id;
 
 	mutex_lock(&pi_mutex);
-	id = idr_alloc(&parport_list, port, port->number, port->number,
+	id = idr_alloc(&parport_list, port, port->number, port->number + 1,
 		       GFP_KERNEL);
 	if (id < 0) {
 		mutex_unlock(&pi_mutex);
-- 
2.53.0



