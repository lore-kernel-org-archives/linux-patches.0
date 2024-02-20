Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FF476C9C;
	Tue, 20 Feb 2024 21:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464126; cv=none; b=k8+wUffKAE7PRwRdZkpimi+aU+X56zHF/dQ4PX4DNyeWmyNtP5Qdi39EqIH/LxjToN7bbb56SvYvQ9/soS4hC4DXo2kHTdNO1+q4t6tEkCiOlEwbEZ82ju2tuSQ9zcaGW+ZdmZUP/wwVRqKxT0AG7rNnrCq65A2hz7gMyPBdEck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464126; c=relaxed/simple;
	bh=2nGN83HAGOmyYvggYgsDTSRnb9E7tidHIwhUAkRMWak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWkZI5X6p2Eo76ejoHTirviCkgIcKONZXx64CDZyzaBhV1Q51b8Li9NTjeUjx1dmurShu83VFg9dcySDZYVK7okw/ndWQCUVae6YtuVKAkXST/tjf9+Fr/N3IktMyxo5pfV+ELcdAgYs1wjBEQdTVozpEJWp7jKER826Xl/wx04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdLXE5Gx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdLXE5Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A878C433C7;
	Tue, 20 Feb 2024 21:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464125;
	bh=2nGN83HAGOmyYvggYgsDTSRnb9E7tidHIwhUAkRMWak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdLXE5Gx2VvRdMeEY8R8nu9PgWipeT1NDrlO/Ey3rddzApo9eGH2FY9D1M3L1L7X0
	 qD5gsO/Zn7gPFPjfrIY4rxQl+LrwpT3wMJC4aBGSP+FTuwUDEiGR51MsMGdOAjN/uF
	 DlMb8pTQiETOqFkbcDtHwnV82E/HgAcmKdWWAbWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 242/331] LoongArch: Fix earlycon parameter if KASAN enabled
Date: Tue, 20 Feb 2024 21:55:58 +0100
Message-ID: <20240220205645.403103350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 639420e9f6cd9ca074732b17ac450d2518d5937f upstream.

The earlycon parameter is based on fixmap, and fixmap addresses are not
supposed to be shadowed by KASAN. So return the kasan_early_shadow_page
in kasan_mem_to_shadow() if the input address is above FIXADDR_START.
Otherwise earlycon cannot work after kasan_init().

Cc: stable@vger.kernel.org
Fixes: 5aa4ac64e6add3e ("LoongArch: Add KASAN (Kernel Address Sanitizer) support")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/mm/kasan_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.c
index cc3e81fe0186..c608adc99845 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -44,6 +44,9 @@ void *kasan_mem_to_shadow(const void *addr)
 		unsigned long xrange = (maddr >> XRANGE_SHIFT) & 0xffff;
 		unsigned long offset = 0;
 
+		if (maddr >= FIXADDR_START)
+			return (void *)(kasan_early_shadow_page);
+
 		maddr &= XRANGE_SHADOW_MASK;
 		switch (xrange) {
 		case XKPRANGE_CC_SEG:
-- 
2.43.2



