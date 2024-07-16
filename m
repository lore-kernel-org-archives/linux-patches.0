Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EA21DDCE;
	Tue, 16 Jul 2024 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145171; cv=none; b=LXweFtWX3q7mNPdFcP8sew3cO8mXiNiyIcUwQa1GXH8XiUOaCSCq3HzndLCuZCpkLns6rQKx5/tR3Y6fVuC+c1E2Hew82nWh99Z1E5z0ItrUXA6ZFezefSLl7CzVPT5PHFz2v7LKI9CnEls+TWlleP63VI5q9Rk8gkpt4DEfpzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145171; c=relaxed/simple;
	bh=bNf8qL0/XCB0in5xyBH5klyW16WlJ+Y38V7NwYH/bmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KN/kazvDGxfxzub14zCtA6myp41c4pQck+1dpobY1rnITMiZGY6cQmvaPTHq57vrdMQxeCpeOEvtssqW/KMpuS8scBeu0/g/exVLFIk8GbSI+ACoiL+MSCdzQ/tsWXEDxzihmp5VRRTyDlfQ+yQ5TGfRCbp8xJXnSmRbPBtePvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMldht/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMldht/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E217BC116B1;
	Tue, 16 Jul 2024 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145171;
	bh=bNf8qL0/XCB0in5xyBH5klyW16WlJ+Y38V7NwYH/bmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMldht/s7k6BLdXcc0i7E9ZDqXOMXINlmX07zOqAYt65Ognh5yazWx+nvyciUwwjg
	 Dv1kdLcCiv8/av20Kjsi4L+QIVoMa5jgFAlrnvfhVMeRI0O/XAXLSxTRRULZR4E2oO
	 UYqPqRwqnHItsqiX2uwyfSw7QD4RqSpRhiOrSyLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 121/143] wireguard: allowedips: avoid unaligned 64-bit memory accesses
Date: Tue, 16 Jul 2024 17:31:57 +0200
Message-ID: <20240716152800.636402152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@kernel.org>

commit 948f991c62a4018fb81d85804eeab3029c6209f8 upstream.

On the parisc platform, the kernel issues kernel warnings because
swap_endian() tries to load a 128-bit IPv6 address from an unaligned
memory location:

 Kernel: unaligned access to 0x55f4688c in wg_allowedips_insert_v6+0x2c/0x80 [wireguard] (iir 0xf3010df)
 Kernel: unaligned access to 0x55f46884 in wg_allowedips_insert_v6+0x38/0x80 [wireguard] (iir 0xf2010dc)

Avoid such unaligned memory accesses by instead using the
get_unaligned_be64() helper macro.

Signed-off-by: Helge Deller <deller@gmx.de>
[Jason: replace src[8] in original patch with src+8]
Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20240704154517.1572127-3-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/allowedips.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -15,8 +15,8 @@ static void swap_endian(u8 *dst, const u
 	if (bits == 32) {
 		*(u32 *)dst = be32_to_cpu(*(const __be32 *)src);
 	} else if (bits == 128) {
-		((u64 *)dst)[0] = be64_to_cpu(((const __be64 *)src)[0]);
-		((u64 *)dst)[1] = be64_to_cpu(((const __be64 *)src)[1]);
+		((u64 *)dst)[0] = get_unaligned_be64(src);
+		((u64 *)dst)[1] = get_unaligned_be64(src + 8);
 	}
 }
 


