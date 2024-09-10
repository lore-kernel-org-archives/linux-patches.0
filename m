Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0640B13AD09;
	Tue, 10 Sep 2024 09:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962067; cv=none; b=QPOse5GtDigCdIKGDkuj2l/pDUvNjpNUwyt+GE2jl5E7fLbSOh18Pk+U4eSdUSXggaN5jBSDH6ynZpqQoiIbctHO8LzO3X/ORxUrQ9xsXbMnEM42oiws/eL0f1LZbfcvwZxdsJxrUOwqRqUOxXy6LVx+S/+Xsx+D//NbTgMnUTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962067; c=relaxed/simple;
	bh=HBUeo32rqXxK+iyRaaVGJ6NKZhaV5t3k6urekQsh39g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfWMUCrDk7k1qU2qfzz8oQ6Pzfsf9tUaNRlqr/V90vyqQhz0ymXaA4A7kk9Vq7S+krAZne5awKsXsehrHX9IUE5K41Bpv4UVvUEkMC1StlNyOvQnQkwQdjmFi//a/z7kasT19luMymG43QDe5Vx+06gjlefeWvUV3Sc+7bXD2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN5ErY+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN5ErY+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE86C4CEC3;
	Tue, 10 Sep 2024 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962066;
	bh=HBUeo32rqXxK+iyRaaVGJ6NKZhaV5t3k6urekQsh39g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UN5ErY+LS0nHWbzN17FVfOldnV+nxZ//kpve2PykMebolzbCW9B65g/Zbaf/tX5GM
	 57WTuHwQF/Z9FuuGf7y/dvwY+FAJeVaeT+BP15gAQF+T5THderaB/9O3fa6H32H17o
	 AZudtz3eptUbI8wB0mkWg4i8nfZrVTwq/94zhiW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 256/375] s390/boot: Do not assume the decompressor range is reserved
Date: Tue, 10 Sep 2024 11:30:53 +0200
Message-ID: <20240910092631.156557589@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit b798b685b42c9dbe508e59a74250d97c41bec35e ]

When allocating a random memory range for .amode31 sections
the minimal randomization address is 0. That does not lead
to a possible overlap with the decompressor image (which also
starts from 0) since by that time the image range is already
reserved.

Do not assume the decompressor range is reserved and always
provide the minimal randomization address for .amode31
sections beyond the decompressor. That is a prerequisite
for moving the lowcore memory address from NULL elsewhere.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 6d88f241dd43..66ee97ac803d 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -476,8 +476,12 @@ void startup_kernel(void)
 	 * before the kernel started. Therefore, in case the two sections
 	 * overlap there is no risk of corrupting any data.
 	 */
-	if (kaslr_enabled())
-		amode31_lma = randomize_within_range(vmlinux.amode31_size, PAGE_SIZE, 0, SZ_2G);
+	if (kaslr_enabled()) {
+		unsigned long amode31_min;
+
+		amode31_min = (unsigned long)_decompressor_end;
+		amode31_lma = randomize_within_range(vmlinux.amode31_size, PAGE_SIZE, amode31_min, SZ_2G);
+	}
 	if (!amode31_lma)
 		amode31_lma = text_lma - vmlinux.amode31_size;
 	physmem_reserve(RR_AMODE31, amode31_lma, vmlinux.amode31_size);
-- 
2.43.0



