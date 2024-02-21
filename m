Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2F87BB16;
	Wed, 21 Feb 2024 14:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525040; cv=none; b=o8wVdJNoVUnp/HlaX89Hiiqgb574Xfs3MFLhdxHz57jO/qfGZO/8L0hFOhKJCup7w5uZXLebe9Z2hCM1DWT3CZr0n08hSgEvP35jvqzwcDI2XXqA5eBlDXgoZOxwHapa+trTdYrB2ZUNIX+syJWWdaGC/UUXj5SoQT/YKJ4SSgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525040; c=relaxed/simple;
	bh=yeWQsOxemudhJmS8WjXmD3ABrBS2DOJbkSDtfnGYix0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcCIBr7hUA6V7SUHoK4qIf4evjnDs2MoFQE1uwNlU+kg2Y8z0oFjQXm/Ac2IxzLSwfc0CS9KRFC+PgRHMeAN5FD1d5jEfVoHB2agTdZc9pRB3rZyw9vYKC2FFQRB9hOOOBynW7k8+Z4kSHn7rbjguTNwybfg4sc19iAe/RUAXOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UR3NR6fb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UR3NR6fb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF23C433F1;
	Wed, 21 Feb 2024 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525040;
	bh=yeWQsOxemudhJmS8WjXmD3ABrBS2DOJbkSDtfnGYix0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UR3NR6fbz4kdWPQIqtJNe0aNTc0CznpaQAmMsAsM2TWGwE1s2o6sPh+kKtMfhk8p0
	 S278IihNDRXK2UY79gkrSZf0TAv/ceQWHlr1Ujfjos6UTN0hGNa01ULIdsyW9dJgKX
	 9qxCD9Iy0n6EF5Qp4sYAToUXcg2YYnA6u2AyNK8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 014/267] parisc/firmware: Fix F-extend for PDC addresses
Date: Wed, 21 Feb 2024 14:05:55 +0100
Message-ID: <20240221125940.501273342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -122,10 +122,10 @@ static unsigned long f_extend(unsigned l
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


