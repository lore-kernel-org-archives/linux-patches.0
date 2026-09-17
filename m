Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834D759C985;
	Thu, 17 Sep 2026 15:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658788; cv=none; b=nNVGgyJK9cEC0i5CsPv1xykCqjCrI2e+JqgsnFPNnX06NwYETxW30fs6fHBUYDn7W7ECSbadaVmrEGISa3k9CM0oFNPEGq8QEyyD5Fd8D/cnO4H66zAbYYm2tUTvgpEPqR0WJAHs3w03AxGWcPFZ+zHutjxJfnnlI2pfWNbgtM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658788; c=relaxed/simple;
	bh=KCIta00qt6ifeWgPFH3BXE83nenzfPeE95+xL34k/WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBSfIQHwhiyDTwjb6ujR5NW3cAao5dGpbwYVyqxI0TEeyCofGKWhz/98k4kskVaZH23o9Zi0mKoxeebIfjC6e36nCGM/KIWA21hDQmql+g+R4bhFOSaRLaUBdQgQzG+QbaVJ00yLH1O2VhHAmZX+EZwBJEzxSWr5NeH4szRB9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndJ987aN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndJ987aN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1F41F000FF;
	Thu, 17 Sep 2026 15:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658776;
	bh=5XCyU9BXmw7U61nIyi1jSOBsS2LfzS0ww9jjGl29Hrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndJ987aNr5/qHIn2X8u+Pe4G2O1E1py59TlXZT1eFN17zfzESLPCZT4uwgdgatCkw
	 VQi+79QiJl5zxWT2WZodJnnifj8CbqpwaxNc9XTH9Qz+H8RgLrnbUEW8i4ZXmT65un
	 2fZZACIaQbE5Ntl/W3n7sLassc+Nrh8fEKNq/DbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 034/733] accel: ethosu: Dont read the U65 rounding mode as a storage mode
Date: Thu, 17 Sep 2026 16:05:42 +0100
Message-ID: <20260917151351.585270140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomeu Vizoso <tomeu@tomeuvizoso.net>

[ Upstream commit db9deec5a345abc538d081fb221dc0b00a9695bd ]

Bits 15:14 of NPU_SET_{IFM,OFM}_PRECISION select the activation storage
mode on U85 only. On U65 the same field holds the rounding mode, and the
command stream parser has read it as a storage mode since the driver was
added.

That went unnoticed while unknown values fell through the switch, but
now that they are rejected, every U65 command stream that asks for
natural rounding (2) fails CMDSTREAM_BO_CREATE with -EINVAL. Mesa emits
it for average pooling, concatenation, split, unpack, strided slice, LUT
and argmax, which is 72 failures of the Teflon test suite on an i.MX93.
Truncating rounding (1) is misread as well: it picks the two-tile
address path and computes a bogus feature map size from tile bases the
command stream never set.

Read the field as a storage mode only on the hardware where it is one.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Fixes: 6b7e0066294d ("accel: ethosu: Handle U85 internal chaining buffer")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Link: https://patch.msgid.link/20260824152612.751007-1-tomeu@tomeuvizoso.net
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ethosu/ethosu_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ethosu/ethosu_gem.c b/drivers/accel/ethosu/ethosu_gem.c
index d50fed64d4d93..fa37a190e9fff 100644
--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -204,7 +204,7 @@ static u64 feat_matrix_length(struct ethosu_device *edev,
 			      struct feat_matrix *fm,
 			      u32 x, u32 y, u32 c, bool ofm)
 {
-	u32 element_size, storage = fm->precision >> 14;
+	u32 element_size, storage = ethosu_is_u65(edev) ? 0 : fm->precision >> 14;
 	int tile = 0;
 	u64 addr;
 
-- 
2.53.0



