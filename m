Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55177296BDF;
	Tue, 26 Aug 2025 11:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207126; cv=none; b=Mj4auVjfrpemsvuejRp9FcM7U9cs0WTZ1dHGABjru5ZSpUPwlSexUintKa+RtAr2xLJeV6FH9yrW3neYyOwo0EMfUepAbK9duneUwZHdX9VXE7lITctlKy6lLmZ8to1fxm4jkdd4U/YYAkplW89snat3Yn1nX4HdUwJn2654030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207126; c=relaxed/simple;
	bh=FXYH2ZKj2jm4vPB/8o1MpUKtguk29zpZU0QQH/M+Ahw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pk8oWZ91Gt27Pe5FpddkBv8wcwDf0p/CJMHrLBgDVDzDz30XwqUsBq3KtlV78yiEXTgN0HtlFhirfUMKsAvgQoh8G6asRa0dBwSXZembRHHVfBzbIdXVdRy/WUW5poV1ZbQzUwSNWyzPeP5ycmVouPf5KQQwYiCZoEbGyLMXwAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPBX4HKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPBX4HKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA191C4CEF1;
	Tue, 26 Aug 2025 11:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207126;
	bh=FXYH2ZKj2jm4vPB/8o1MpUKtguk29zpZU0QQH/M+Ahw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPBX4HKFy+ZXGo9Dy+uUTajvP7JC37urDUJXdztGXoen3D6E4spa4R3W39PWpHSUS
	 /TQM2B7rBeb5cmBfIK2ZfbNcBZ3cLDjCf4qddHGWzdpzyIPRmDLHVcHELM5f0lb2vX
	 ZD2I2FqosikwsD4IuFyrJcxpJtSGM1Akru1T+F94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.16 061/457] apparmor: Fix 8-byte alignment for initial dfa blob streams
Date: Tue, 26 Aug 2025 13:05:45 +0200
Message-ID: <20250826110938.864597506@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit c567de2c4f5fe6e079672e074e1bc6122bf7e444 upstream.

The dfa blob stream for the aa_dfa_unpack() function is expected to be aligned
on a 8 byte boundary.

The static nulldfa_src[] and stacksplitdfa_src[] arrays store the initial
apparmor dfa blob streams, but since they are declared as an array-of-chars
the compiler and linker will only ensure a "char" (1-byte) alignment.

Add an __aligned(8) annotation to the arrays to tell the linker to always
align them on a 8-byte boundary. This avoids runtime warnings at startup on
alignment-sensitive platforms like parisc such as:

 Kernel: unaligned access to 0x7f2a584a in aa_dfa_unpack+0x124/0x788 (iir 0xca0109f)
 Kernel: unaligned access to 0x7f2a584e in aa_dfa_unpack+0x210/0x788 (iir 0xca8109c)
 Kernel: unaligned access to 0x7f2a586a in aa_dfa_unpack+0x278/0x788 (iir 0xcb01090)

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Fixes: 98b824ff8984 ("apparmor: refcount the pdb")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/lsm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -2149,12 +2149,12 @@ static int __init apparmor_nf_ip_init(vo
 __initcall(apparmor_nf_ip_init);
 #endif
 
-static char nulldfa_src[] = {
+static char nulldfa_src[] __aligned(8) = {
 	#include "nulldfa.in"
 };
 static struct aa_dfa *nulldfa;
 
-static char stacksplitdfa_src[] = {
+static char stacksplitdfa_src[] __aligned(8) = {
 	#include "stacksplitdfa.in"
 };
 struct aa_dfa *stacksplitdfa;


