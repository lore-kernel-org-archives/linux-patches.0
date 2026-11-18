Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055252;
	b=ZlHZRHb+QnOicbvFlZke+9ki7+y2yk8Z1nUpejoAe0OuXLfJtBg64fzgIrXdJgBGQxaY
	 n1TgMQyF7fvvs88Jci8luAi3TkJn+YS74o/roHmIgPrdySYInYD35PcjY/KrF4d+cWSy6
	 cr2J4B/3C5pdc1LM91a0CwanG1ja9NG6LAClLRR6fHigJjrnZCSPXhYTUKUPDnO+2krro
	 5EBPqaiItEm1t1B289SmmtYzbE6lQaZ0nBo5Wryg0W24NuIVNJHgmtY0ZdAyMsv71PK9+
	 8rKY7AyW4O02wqDO7owQv8k9jZbDt4lXLEDSlc6TqmEloHO88Ln3Hh+3dF5lGgLEwSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XWhHosIK9fgIMrBPiE2roMs8C5g6VEVGo49xFZPs4s8=;
	b=xUFNdNDpxsB8ahHjCOrxntLFFwb2kKcLpQE0kWyvLCioIBAi/gpZ6G3NkYQpfYvXfp41
	 YDgiHJ1TLO4ne2ROihXsdWWG+kXqnrH3Hb/RnblsdmETb3DAxQqn++s8iyBeqfHo9ogj4
	 jZfMvParHs9kwTnXZKI1UyOLg9RtbvV1lcGNI1l0GvKFBbbkqsQu5nQJMUL8YES4OKoGa
	 o8zUSbr2nG9PG4Ms6DsJzkXtrkrlvj9+TsslzrkNeLKGYL83KyEoINuQq5WwhualHFjcd
	 Gg402XUrwh6jYav2RjRoHCFkeFkjIOQw9E7EAYQbXwjhTqy5Uc9FKpcyZqUepSTurXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvvCDAhm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52215606A339;
	Thu, 19 Nov 2026 02:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvvCDAhm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB8E1F000CE;
	Thu, 19 Nov 2026 02:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055252;
	bh=XWhHosIK9fgIMrBPiE2roMs8C5g6VEVGo49xFZPs4s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvvCDAhmcvmAmrFcJvk0L5bI963uFumHE7ZfC3zHzsgK53eujfQdWTV1A1m+/y10Q
	 OJwGDLMAxD02xZgqQwJmVf1m3t+hr83lFiW9ivmPO5k6yqyZ1PYMQR9l5NoRFA/7GJ
	 SYayrvYqBLacfaFvNKiBz+ZZD8RsWXmfjBXsDoV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1566/2214] swim: Perform ISM/IWM mode switching according to specs
Date: Wed, 18 Nov 2026 15:54:02 +0100
Message-ID: <20261118150114.703192815@linuxfoundation.org>
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

[ Upstream commit 52981bb358d1b5c38040b00f81e2cf973f9148ad ]

The SWIM spec says, "MOTOREN must be low to switch modes" and "after
switching from ISM to IWM, the very first command must be a clear L7".

The ISM spec says, MOTOREN "must not be cleared until after the Action
bit is cleared". Perform those operations in the correct sequence.

When switching to ISM mode, the Mode register has to be selected with a
particular sequence of bit flips. Set q7 low then q6 low then mtrOff.

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/75714ecc9a12d59511967dc9e24163dc8f3bbdd8.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index cb0bdf5c8ac30..c9b7b8a0ad62d 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -149,6 +149,7 @@ struct iwm {
 #define ACTION		0x08
 #define WRITE_MODE	0x10
 #define HEDSEL		0x20
+#define ISM_SELECT	0x40
 #define MOTON		0x80
 
 /*----------------------------------------------------------------------------*/
@@ -222,18 +223,21 @@ extern int swim_read_sector_data(struct swim __iomem *base,
 static DEFINE_MUTEX(swim_mutex);
 static inline void set_swim_mode(struct swim __iomem *base, int enable)
 {
-	struct iwm __iomem *iwm_base;
+	struct iwm __iomem *iwm_base = (struct iwm __iomem *)base;
 	unsigned long flags;
 
 	if (!enable) {
-		swim_write(base, mode0, 0xf8);
+		swim_write(base, mode0, ACTION);
+		swim_write(base, mode0, ENBL1 | ENBL2 | MOTON);
+		swim_write(base, mode0, ISM_SELECT);
+		iwm_read(iwm_base, q7L);
 		return;
 	}
 
-	iwm_base = (struct iwm __iomem *)base;
 	local_irq_save(flags);
 
 	iwm_read(iwm_base, q7L);
+	iwm_read(iwm_base, q6L);
 	iwm_read(iwm_base, mtrOff);
 	iwm_read(iwm_base, q6H);
 
-- 
2.53.0



