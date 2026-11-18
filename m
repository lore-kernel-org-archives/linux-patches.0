Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048507;
	b=DZpyUhQkup6jBJ1BInKxvNmOJ2ppe1TOGCOTeIRuFf1O/z/j4ULzSww5WUSg1STLWArt
	 hEdyGt2omYkstQDaF0k3xIqsZcXR6+/A52lRmPKLaSS53poll5WPMo+h1whtS/uhSWL06
	 4koKfKZktHZzU/crggEZATcBlTaFckf8HXN7pIh0HOvi+zlA1KZkx9wWtkIjVSiv54Nu8
	 98ClimPiHR3mk3BEI8vLblxN4ADGPjbYn6q7VH+Oc6IJIHfuWpRRuzzjbJ3prF7Z49BBY
	 ec/AeitPj1ddhm2WivTpNTjmNYcmCD+18Avk8xk9km4l7vt8E+Yt/D8F3TuyY6APOBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0zJnY7xtwUXToH6OxLXDkIQKEwCHPc7ShtMQ1FVUGU=;
	b=PGjfrJUDATZ1DVH4uZtPOptiZp0h8+/M4YurPF+gGL1bnjziN2rq+J7sOz7YzbpSFVfV
	 oS7NByPgZFsnTHCjp4XNo8i+6OMDTANCJoIKhfiEv6OeTa0gpumwQruRrJjJhnUTPJYTb
	 wvwNRrDdifI17nd1VUOCZY040aGd0LOqDMz62je8lXMl0LH2joQST3willFXkPolueR8T
	 K/QdrEf+RlTQrKUJkARlC8ekLwqwSVK0UqxDMSTJ/yA9y0LAcKwBFWXXK9p1j0CDZfp7K
	 hffGj9UEMyy1sQFP3nMyC3VhGRk4XnH/YIQdw0b+tZfVochZzuNlLcJtljGEs1w115A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+AZUWlR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A50606A325;
	Thu, 19 Nov 2026 00:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+AZUWlR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313261F000C8;
	Thu, 19 Nov 2026 00:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048506;
	bh=i0zJnY7xtwUXToH6OxLXDkIQKEwCHPc7ShtMQ1FVUGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+AZUWlRDHtx2d2jadNKldU5Srdqopl5vA3d5Lyi4F8ibU12gbAD9oMHIdcO6sdYQ
	 /ub5lvEhEj64RbZUCGjlHJ8urGSwOhEjciOH/3p4QzSj4p4RggPYzufd0hqZQGvmXm
	 O8RUVYoW1RJyOtILM04W0BsioTyhjiI1ltC6de8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2018/2857] swim: Add track zero recalibration delay
Date: Wed, 18 Nov 2026 15:50:52 +0100
Message-ID: <20261118150314.060716002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit b9c1095048537cc9563f12d0a24f2f0df129e4d5 ]

The UPD72070 spec indicates that the track zero sensor can take 3 ms
to stabilize following a STEP command so add a call to msleep().
Remove the duplicate swim_readbit() call as there's no need for that
once the sensor signal has stabilized.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/6d17ca20a7286c1d74833b29510c506a66d96e6f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 0d738368da44e..796d1ddd4702b 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -402,16 +402,15 @@ static inline int swim_track00(struct swim __iomem *base)
 	for (try = 0; try < 100; try++) {
 
 		swim_select(base, RELAX);
+		msleep(3);
+
 		if (swim_readbit(base, TRACK_ZERO))
-			break;
+			return 0;
 
 		if (swim_step(base))
-			return -1;
+			break;
 	}
 
-	if (swim_readbit(base, TRACK_ZERO))
-		return 0;
-
 	pr_err("swim: track zero recalibration failed\n");
 	return -1;
 }
-- 
2.53.0



