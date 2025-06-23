Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18AB1EEA3C;
	Mon, 23 Jun 2025 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715413; cv=none; b=NCGBkw1b7vOhnEPGQCKWCni7PM0HV5gzrsR+6Dl1lnwfq1WwX+mSg+0DQVlefIUIvLyX4UsGFJO9DiRoE2m5y7wQt7LRD8sLOlP/z+0bSwxP4aV+d+4Ixkueon/qtU8s3wKjMyYSnPmE3KoIfufzbjL3iCnR/6loM985HL1dzh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715413; c=relaxed/simple;
	bh=ksCGz9QU9kp0h1Mx6Tkp7unx907jtpq2QfQiDvlFiX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mf22svO9VR6JOFv3MKi64cqXB6lwf2Ls3X1deNmS4zv9om+baINQeOjzhOW4yvqmp/cahrkBFmNG01L5JwdPjlNKPZFLd3N1JBHL3KSTzvSHj3kzslQPubTCWLvVC4fswWsGHewELn+mxg2vP52/Nw2nag/Hn68QPFfM22gH9MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HhbAOaO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HhbAOaO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D96C4CEEA;
	Mon, 23 Jun 2025 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715413;
	bh=ksCGz9QU9kp0h1Mx6Tkp7unx907jtpq2QfQiDvlFiX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhbAOaO2oHxRYApu2uBj0/6v1rxBXa08ZrH3w1oZwoQmKM/28cNi3rOiM/1tqKjrN
	 VQscWg5ndJdKxYaHsZphF7MPiQWIlHsyULRrm9MX9EFb/J9jZeZitO+kl5qQl9Cy2G
	 VTKAmYVZvDdYC4jeVcTwrmiQGpF1T806e1b9hgd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 238/411] parisc: fix building with gcc-15
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130639.647484091@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 7cbb015e2d3d6f180256cde0c908eab21268e7b9 upstream.

The decompressor is built with the default C dialect, which is now gnu23
on gcc-15, and this clashes with the kernel's bool type definition:

In file included from include/uapi/linux/posix_types.h:5,
                 from arch/parisc/boot/compressed/misc.c:7:
include/linux/stddef.h:11:9: error: cannot use keyword 'false' as enumeration constant
   11 |         false   = 0,

Add the -std=gnu11 argument here, as we do for all other architectures.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/boot/compressed/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -22,6 +22,7 @@ KBUILD_CFLAGS += -fno-PIE -mno-space-reg
 ifndef CONFIG_64BIT
 KBUILD_CFLAGS += -mfast-indirect-calls
 endif
+KBUILD_CFLAGS += -std=gnu11
 
 OBJECTS += $(obj)/head.o $(obj)/real2.o $(obj)/firmware.o $(obj)/misc.o $(obj)/piggy.o
 


