Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040065;
	b=bANh5+dOpJlvq2y/PiDJHgqf9Lnou32er0UkjH835vxYSD3lUfwgizaclJoh6nz9LeE/
	 X6bOYEoJGqf/HOW0b9I4lceuXWn3f/wIMhVV43rgvcce7XVGS7ZD6op0ercQ3JV5DaCOP
	 FoeOe/dYBAnWYREr56Znd0AFWsJ2+cEKSCF0887EcSxGSsd5eh9/wnb2M/0cZnd/unLou
	 yjZEFloMH8pwuFJcTRD2XKARErih0dcJ4rU0IOi2ZmW82UD+Tu6iec1WuNYCWwgpUfM60
	 RGoeA79XAyewlRiByPxf2PPsuhN/Zke7Cii95F8iHMVpdNP2cq8/S+kf0qFOCCvuYSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e3Zgp/f3xYJqQ9N3ctHYudUjKeG2bKD8mCWAMfIrVZg=;
	b=KyjjhWetJ4kd7tD2navqa1h6dikfnxcHtcwHvovcY0aeiO5vWs7VZfk64ujCKWaOmjgO
	 EyIY8ElF3xRpah2YaWgIqJCE1625EoFE/iXFt5Z/Fy/pyJi32C9BhdFl4zGjjQO45mcOv
	 MrLRPq5ywnQhGcDUNOCz4A+5ul6+7v1ZVUOCJNULRd5Tw70Vg7/NSGoBqjiBHY0VBcrxn
	 Q3V/fIqx4KdsSOMRBkZbGB7XgLA0C5os9kZUpe7AAWWxCBxuRk5sDd5+WBr3wd8D6Xlyl
	 5XxyD4cj2r5dxcvAot/BIRbm6gL6ASXS/iqbzKztwrGdTVbx5vvjNum4ij17zXgyy/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZLkY2AH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F986606A320;
	Wed, 18 Nov 2026 22:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZLkY2AH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B731F000C4;
	Wed, 18 Nov 2026 22:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040065;
	bh=e3Zgp/f3xYJqQ9N3ctHYudUjKeG2bKD8mCWAMfIrVZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZLkY2AHh7drsNgbkg7v10NqqHJq7IOMoNirN9PU1LWd9JmSC+f57Ypa69akmstat
	 EYpw4lBDDetwFvxrK5FLYWmg35VGAZNOjwjworZufP7a09jA9gyYzz542HxvDhloK5
	 VesKtY2nCDJFFF4zlHZp7u7PDeigV8+tKh0nvj9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2325/3318] swim: Revisit delays
Date: Wed, 18 Nov 2026 15:49:07 +0100
Message-ID: <20261118150431.416173504@linuxfoundation.org>
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

[ Upstream commit bbcd3e38a4f355d6b0320f3f6916df96c109f2ad ]

AFAIK, timing requirements for the various FDHD drive mechanisms aren't
well documented. But we do have the UPD72070 spec and secondary sources
like swim3.c and mkLinux source code. This patch is needed to satisfy
the requirements in the UPD72070 spec and follows mkLinux.

Change the LSTRB pulse to 2 microseconds, because this is what mkLinux
does. Inside Macintosh says, "Hold LSTRB high for at least one usec but
not more than one msec".

When a disk is ejected, pause before de-asserting /ENBL. Wait 150 us after
the STEP command for valid signalling. Pause for 1 us after setting the
step direction before sending the STEP command.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/af356248a1e6a4fd956f71acf17feead27ba4918.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 5942ba4f126d5..6553bc574b176 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -291,7 +291,7 @@ static inline void swim_action(struct swim __iomem *base, int action)
 	swim_select(base, action);
 	udelay(1);
 	swim_write(base, phase, LSTRB | action | PHASE_PIN_DIR);
-	udelay(1);
+	udelay(2);
 	swim_write(base, phase, action | PHASE_PIN_DIR);
 	udelay(1);
 
@@ -338,6 +338,7 @@ static inline void swim_drive(struct swim __iomem *base,
 		swim_write(base, mode0, EXTERNAL_DRIVE);
 		swim_write(base, mode0, MOTON);
 	}
+	udelay(1);
 }
 
 static inline void swim_motor(struct swim __iomem *base,
@@ -356,6 +357,7 @@ static inline void swim_eject(struct swim __iomem *base)
 {
 	swim_action(base, EJECT);
 	swim_readbit_timeout(base, DISK_IN, false, 2000 * 1000);
+	msleep(1);
 }
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
@@ -369,6 +371,7 @@ static inline void swim_head(struct swim __iomem *base, enum head head)
 static inline int swim_step(struct swim __iomem *base)
 {
 	swim_action(base, STEP);
+	udelay(150);
 	return swim_readbit_timeout(base, STEP, false, 20 * 1000);
 }
 
@@ -399,6 +402,7 @@ static inline int swim_seek(struct swim __iomem *base, int step)
 		step = -step;
 	} else if (step > 0)
 		swim_action(base, SEEK_POSITIVE);
+	udelay(1);
 
 	swim_READY_timeout(base);
 
-- 
2.53.0



