Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2076D159583;
	Mon, 29 Jan 2024 17:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548223; cv=none; b=oFKYknOqy9qeOlm11u/BvitFRFgKliABrxuotS+XONLlhgfaAWjBt2M08qPhCwN17n7ezvNEuo/9rD5VGtGlzufwzsi/qNqlhDwUFRO9W5Zy4avFyqmVGcSpqbt64v53u5OmZfpp6PNhjRLJOZuxHO7U0eUaX2GMZK5XSqBhsGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548223; c=relaxed/simple;
	bh=dgPsUnHTZZOw7d0SbiECY4NDnQSiTeRjMC3/PAuSvFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n96F+nX1Aro73/v9FI4RUO8O7tZjjyNt8c/AoaQHzijHUUEuGP3+2a9IOrN9AzWaaYXD0PQ0/rdH3m8Mp5UGR/+uLb/EaD8PFvs74Jy2sldOpxV2C1O6IVMfgtps2kbhUFJMbmsqTWwENkkk6RHwu0lQOkJXwdimz45fHgvL5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cknaOgWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cknaOgWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA47AC433F1;
	Mon, 29 Jan 2024 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548222;
	bh=dgPsUnHTZZOw7d0SbiECY4NDnQSiTeRjMC3/PAuSvFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cknaOgWp9RoX58PGpGo8AC/mc1Pxxi+jLaNLbBN3c3Wke56hIgBQrVcg26kBkBqAk
	 oN1ipeOva889+ONl6oNlBGFDp2q5RBA1yCzPCWRP+GpJJOpjCBdomGej1szbQf1PMd
	 R63KP+S0fPETZRUGL/0JvOpn0keaeCvf6muQzyUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 027/185] parisc/firmware: Fix F-extend for PDC addresses
Date: Mon, 29 Jan 2024 09:03:47 -0800
Message-ID: <20240129165959.469755366@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 735ae74f73e55c191d48689bd11ff4a06ea0508f upstream.

When running with narrow firmware (64-bit kernel using a 32-bit
firmware), extend PDC addresses into the 0xfffffff0.00000000
region instead of the 0xf0f0f0f0.00000000 region.

This fixes the power button on the C3700 machine in qemu (64-bit CPU
with 32-bit firmware), and my assumption is that the previous code was
really never used (because most 64-bit machines have a 64-bit firmware),
or it just worked on very old machines because they may only decode
40-bit of virtual addresses.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -123,10 +123,10 @@ static unsigned long f_extend(unsigned l
 #ifdef CONFIG_64BIT
 	if(unlikely(parisc_narrow_firmware)) {
 		if((address & 0xff000000) == 0xf0000000)
-			return 0xf0f0f0f000000000UL | (u32)address;
+			return (0xfffffff0UL << 32) | (u32)address;
 
 		if((address & 0xf0000000) == 0xf0000000)
-			return 0xffffffff00000000UL | (u32)address;
+			return (0xffffffffUL << 32) | (u32)address;
 	}
 #endif
 	return address;


