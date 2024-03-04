Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665A5200CD;
	Mon,  4 Mar 2024 21:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588829; cv=none; b=lG+1MGElxcb62BjG2m9dNQwhyOEvSlbnGsfkP7gNaznoJxiuPDrYDZmYRluEiEHyb7V0x8FZmnZpWOgbjdS96ZXreWMqx8vaMg3yv6jFnd+R1KYGKnBIZyWelMX0hEoq/n2BQHkO3dzw5rJs6xq8gc62rzw37X/+HWdEN/LAFNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588829; c=relaxed/simple;
	bh=0n6nD3YiMStxXwW4X2r2zjkYccV3JDr7EROAzf6LC/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH85GIWqQr6HQok0x4Mz5cLs0zucOybZ83huc/p3S0C/jrFMQnJ47oIavO0DHxQHKjTFenK/mD28NCAtMslDX2fnuJLkrJwpiv2c4L2L5aghxH3O4TKUgiP7kg0OWpQPpgSAViTRoKrPzsk5KbvFDjKekimFrcqrenG7S5h4Ojc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vy10zzYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vy10zzYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4E3C433C7;
	Mon,  4 Mar 2024 21:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588829;
	bh=0n6nD3YiMStxXwW4X2r2zjkYccV3JDr7EROAzf6LC/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vy10zzYdJtVPlhq8z6vJUDI4X49DXe+4cgmvq47Zgr99JHA4LFK6IH+w4lRwz0epA
	 Cj3Eo318QsTImkLwPp1BufqnWTSNVo+w+IhGkhGNk3cd2ZRj+/Lo4HL27Jz70uJO9L
	 6EkibHgR5X0NU0vAr87PbUMb5kBpS2+yrzeBXH14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Bohac <jbohac@suse.cz>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 095/215] x86/e820: Dont reserve SETUP_RNG_SEED in e820
Date: Mon,  4 Mar 2024 21:22:38 +0000
Message-ID: <20240304211600.042011798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Bohac <jbohac@suse.cz>

commit 7fd817c906503b6813ea3b41f5fdf4192449a707 upstream.

SETUP_RNG_SEED in setup_data is supplied by kexec and should
not be reserved in the e820 map.

Doing so reserves 16 bytes of RAM when booting with kexec.
(16 bytes because data->len is zeroed by parse_setup_data so only
sizeof(setup_data) is reserved.)

When kexec is used repeatedly, each boot adds two entries in the
kexec-provided e820 map as the 16-byte range splits a larger
range of usable memory. Eventually all of the 128 available entries
get used up. The next split will result in losing usable memory
as the new entries cannot be added to the e820 map.

Fixes: 68b8e9713c8e ("x86/setup: Use rng seeds from setup_data")
Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/ZbmOjKnARGiaYBd5@dwarf.suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/e820.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index fb8cf953380d..b66f540de054 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1017,10 +1017,12 @@ void __init e820__reserve_setup_data(void)
 		e820__range_update(pa_data, sizeof(*data)+data->len, E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
 
 		/*
-		 * SETUP_EFI and SETUP_IMA are supplied by kexec and do not need
-		 * to be reserved.
+		 * SETUP_EFI, SETUP_IMA and SETUP_RNG_SEED are supplied by
+		 * kexec and do not need to be reserved.
 		 */
-		if (data->type != SETUP_EFI && data->type != SETUP_IMA)
+		if (data->type != SETUP_EFI &&
+		    data->type != SETUP_IMA &&
+		    data->type != SETUP_RNG_SEED)
 			e820__range_update_kexec(pa_data,
 						 sizeof(*data) + data->len,
 						 E820_TYPE_RAM, E820_TYPE_RESERVED_KERN);
-- 
2.44.0



