Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1312FD7DE;
	Tue, 26 Aug 2025 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208345; cv=none; b=DFxNqNutXjvnUW0Yb/9tDf/oir6R82cwbe3nedC0omsp1tgERssiVa9MvIsLSh3AucjEX9+CqTTMlQsCrXeXtIkMPOTspF6aEF9JQmwoybsw06yom04UQWiUTNFdszY/CO8r2qO6hW4uCl3LKIlAG47U8p9PG6eaUkaCDGriUaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208345; c=relaxed/simple;
	bh=2NSnHNKgOT5K+x4hC0LnOrKz79x973HBv6Jz98osiqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8MPt4awZ0ATZDKFxet4Wlf1W4rbC+n9VbTCQtoxgqNXy3JRTRpZx28D5ffQ9cqGku6ol+KaJMSNltHG4nxK4q5xfWyUu+w/RK8W47tkvHzBsTEYO/MUg79PW2ZeArxTUcZ6g/jS+YbpoNEN8HH1j59LUSkxkFcCwQoJR8Lcjt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlnEGbOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlnEGbOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0857C4CEF1;
	Tue, 26 Aug 2025 11:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208345;
	bh=2NSnHNKgOT5K+x4hC0LnOrKz79x973HBv6Jz98osiqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlnEGbOZ+Ku2sEnXxJhGGMFqtKP9U6XMvyqfwIIf9ufQn2u/lbq5d2jT0/HNZs5UU
	 mVMK1LpbYu4TgX5EcKTR8IwLP88cdP5aDO0KoHDjGvU6wS0ctG/8p1c/ug09DOvf9V
	 m/4NpjIlCY9LEPAsJBdc2fIszeOJYE6DY85BwnBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.12 044/322] apparmor: Fix 8-byte alignment for initial dfa blob streams
Date: Tue, 26 Aug 2025 13:07:39 +0200
Message-ID: <20250826110916.474050059@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2144,12 +2144,12 @@ static int __init apparmor_nf_ip_init(vo
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


