Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D126F062;
	Mon, 29 Jan 2024 17:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548458; cv=none; b=qr8puTDtMzsrEy6gYJO1kfYc4sdDyAcm4o/Y48KBdn5bW3Et3CTqoWNa/5MCRndZ6SivwYLIWtz6P8HkTIqkUNJVrMSHnbcXnzu2H2mjfsllKniLQLjB5j/sXxYOtyi7VcUCxk8b+QdgVn+kv2r0n/w67SJYOzWgdrKETLgjQuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548458; c=relaxed/simple;
	bh=t06zTkFhWp0NImkkMZU00H/70Z2B2YaxiMPLCu0vJYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCS/NVefHLrOZlVhS5zot4b/CN153QM/GY0zoov/qR3CaalPaZqvt/GOu4c0UKyU1mXNTV1tv0Ayg4OVmMntmLyoKw/1CfpNMo0J2G3w4Tv7aC9RlwrzKXZV/hEBhebKdrISlVnR8YZoy64uqLRyC1oLzmWJN2najVLO9oSahUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqzxu1uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqzxu1uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEBBC433F1;
	Mon, 29 Jan 2024 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548457;
	bh=t06zTkFhWp0NImkkMZU00H/70Z2B2YaxiMPLCu0vJYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqzxu1uycqb7r9UOyb90fOkopA8rNw4fD7Fiv3wRIAim7l0IHcKezb7CwPxtbWBD4
	 Y9LRF+7rLpR76mq7W9zfDCPwTlIkemb22gR7gznOI++xYyfv7z5P19hM1PCK6yc5Yt
	 +CeiJhNASGNxal8xNJFxqkPc//J3iOfVtAV9PGCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 070/331] parisc/firmware: Fix F-extend for PDC addresses
Date: Mon, 29 Jan 2024 09:02:14 -0800
Message-ID: <20240129170016.972370569@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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


