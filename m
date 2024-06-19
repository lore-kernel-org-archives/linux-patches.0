Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4FA82495;
	Wed, 19 Jun 2024 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803246; cv=none; b=E4zwONA5PTSZ3QSIOBlTjCg4hZCgwqD83i4XecwWAu29xRDwRih2shZ33JVnaPcQ16ravBrdATI9ibRzj0/0aoo7zbWmCinuFD3HQJEiaMRTMeZTKyHzcFCKbEGt1Ttyaw9GnDDExkw4ugxMPHCM2nNSy8vQ9/06arTcUfu5IM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803246; c=relaxed/simple;
	bh=jGEzDX4LQzfgPncb9NIjy3L5oBkgqeKy5FCqILsgUBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSHc1jEzpzM5i1FHVcfAY+WmKhWh7HJZXuO2JrLjc7w4YAg8IcNP2pbDjVkSTgn1PRyhOjugF0o+eN/gkSRdUeRVeR/VLTirE1oAgnrYgFbkS9Ou00a74g8LmbxeP+gNzx44MvmkXjA6+eFRI3phTovEHCibFzWHNJQeW3kIarU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIVG1IYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIVG1IYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E64C2BBFC;
	Wed, 19 Jun 2024 13:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803246;
	bh=jGEzDX4LQzfgPncb9NIjy3L5oBkgqeKy5FCqILsgUBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIVG1IYTV9TprWUrp21o9a6jXpH5KrdRbQYA++6bvuMBF1++kap7lrDeGfvFXaCD5
	 eszCoYED9q4DPgSADZkJ2/Qw3nYj9+01DsVUS2t+qmxboLM1V5mCgz0XKi8Tpis433
	 sAb+O7ZgU3aIi0+vX7hMaDKgtfsjfGmtf9CXaG3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.9 202/281] RAS/AMD/ATL: Fix MI300 bank hash
Date: Wed, 19 Jun 2024 14:56:01 +0200
Message-ID: <20240619125617.725178384@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit fe8a08973a0dea9757394c5adbdc3c0a03b0b432 upstream.

Apply the SID bits to the correct offset in the Bank value. Do this in
the temporary value so they don't need to be masked off later.

Fixes: 87a612375307 ("RAS/AMD/ATL: Add MI300 DRAM to normalized address translation support")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240607-mi300-dram-xl-fix-v1-1-2f11547a178c@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ras/amd/atl/umc.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ras/amd/atl/umc.c b/drivers/ras/amd/atl/umc.c
index 59b6169093f7..5cb92330dc67 100644
--- a/drivers/ras/amd/atl/umc.c
+++ b/drivers/ras/amd/atl/umc.c
@@ -189,16 +189,11 @@ static unsigned long convert_dram_to_norm_addr_mi300(unsigned long addr)
 
 	/* Calculate hash for PC bit. */
 	if (addr_hash.pc.xor_enable) {
-		/* Bits SID[1:0] act as Bank[6:5] for PC hash, so apply them here. */
-		bank |= sid << 5;
-
 		temp  = bitwise_xor_bits(col  & addr_hash.pc.col_xor);
 		temp ^= bitwise_xor_bits(row  & addr_hash.pc.row_xor);
-		temp ^= bitwise_xor_bits(bank & addr_hash.bank_xor);
+		/* Bits SID[1:0] act as Bank[5:4] for PC hash, so apply them here. */
+		temp ^= bitwise_xor_bits((bank | sid << NUM_BANK_BITS) & addr_hash.bank_xor);
 		pc   ^= temp;
-
-		/* Drop SID bits for the sake of debug printing later. */
-		bank &= 0x1F;
 	}
 
 	/* Reconstruct the normalized address starting with NA[4:0] = 0 */
-- 
2.45.2



