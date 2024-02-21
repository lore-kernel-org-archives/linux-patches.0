Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A4B69D2B;
	Wed, 21 Feb 2024 13:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521191; cv=none; b=Dm862ZJwR4q/Z+EsaSVo4RUvF7nH9DDw8aaR9XYyo5qibPflWMlOYYiaI463yUXir28cr3Onjf+ox1UCvVI5tPmisiR0+R9GGyd9wV2kCjimxvufhVwEht6ezI/1JPxc1jCjKjdMa0Xgr2BTFTW+wv+Cdx/+k3fbcMqxm/YciCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521191; c=relaxed/simple;
	bh=IGDPAZoMU1lfGQ8LhLEApoABS8tbamW5TzM2nQePsfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksci+PLhiTralGaPi6do7lkMTn4j9KqjI7GeS/AlsMY6N5GM0vH/ic4/PY4oH6QUxW9vbmuqFP/rIZ5SoJBTf2hsAEXp1yejodGMQSCVZMyvhD9fLYZdUhNqSbPCiG0zD9JYyKjVG8nRAMNNWzF1aaFnptNA25Zu+ZY3/zWla5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFb/nUUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFb/nUUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D26DC433F1;
	Wed, 21 Feb 2024 13:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521191;
	bh=IGDPAZoMU1lfGQ8LhLEApoABS8tbamW5TzM2nQePsfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFb/nUUhnDc7W0jpwoS1sx5PNwqxZ0yHAlzXX4dIawhtFrFmCtJb3QxAhKcBIDziY
	 myTP0MLdTidjv5OIPPyEmhayZxu8q274f8Bfgp19i6vq/gMuTtEDSr+gGBJ+/My/oc
	 01Fn9J8UMLOHmvkxPrlZ55ZbeixBmP2fFKT+CG9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 015/202] parisc/firmware: Fix F-extend for PDC addresses
Date: Wed, 21 Feb 2024 14:05:16 +0100
Message-ID: <20240221125932.248501328@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -127,10 +127,10 @@ static unsigned long f_extend(unsigned l
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


