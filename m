Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC1C4C957E;
	Fri, 15 May 2026 16:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861180; cv=none; b=N3/GMJvXYRxVEId1/6hC5xNDIlBnSJFbKPmREz3motB8ZPjor6X4PB7dV1MARC+libI4rGhcJQpjxMf7cT7mHwNXzEIvJphAVthWbbfMMYN6533g2oIWSXPr8rGIhKEt1TYE1TdoO6Sr54dlYVy7v6mEE7X9/d/31JMQQQyJqhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861180; c=relaxed/simple;
	bh=68WuKXRBJ/a0KbuFfrFzqgRwyT2T32+skapk1FCRBsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0u2lcKxaylnIM569Hqtw1Vzh9iAzUeJEZCePjG3FlxG/sR9oSr1Va46OytyjOHY3E8hLvAxMZzb4MmJs4Tai4Y9Vu0siC5saDvJjXvSNORvcCobSVq0MbD5KDuxnzpgOgpVYLymwCT8hosWcPVw3h2emGdWaUsO9kpaTmLQXRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlZpeqiQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlZpeqiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A3C2BCB3;
	Fri, 15 May 2026 16:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861179;
	bh=68WuKXRBJ/a0KbuFfrFzqgRwyT2T32+skapk1FCRBsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlZpeqiQwNRrMuiY0cJ5GYVItULTGgGFQ/4PwuDDoZfsAdVWapJm/cgqH1slNuqoF
	 E/B/lI8fXlPPE3vEJ5e3NOBGWWF5lJgkqDQBLh5u1iTbX9TqokvFvl66iv0Jkgxb7D
	 Z2vcDAeK1tDn9ds86Y7epb8RkZ1Bx4raobw+r6zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 202/474] powerpc/kdump: fix KASAN sanitization flag for core_$(BITS).o
Date: Fri, 15 May 2026 17:45:11 +0200
Message-ID: <20260515154719.385722155@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit b3a97f9484080c6e71db9e803e3cc1bb372a9bc7 upstream.

KASAN instrumentation is intended to be disabled for the kexec core
code, but the existing Makefile entry misses the object suffix. As a
result, the flag is not applied correctly to core_$(BITS).o.

So when KASAN is enabled, kexec_copy_flush and copy_segments in
kexec/core_64.c are instrumented, which can result in accesses to
shadow memory via normal address translation paths. Since these run
with the MMU disabled, such accesses may trigger page faults
(bad_page_fault) that cannot be handled in the kdump path, ultimately
causing a hang and preventing the kdump kernel from booting. The same
is true for kexec as well, since the same functions are used there.

Update the entry to include the “.o” suffix so that KASAN
instrumentation is properly disabled for this object file.

Fixes: 2ab2d5794f14 ("powerpc/kasan: Disable address sanitization in kexec paths")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/1dee8891-8bcc-46b4-93f3-fc3a774abd5b@linux.ibm.com/
Cc: stable@vger.kernel.org
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Acked-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Reviewed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260407124349.1698552-1-sourabhjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -14,4 +14,4 @@ GCOV_PROFILE_core_$(BITS).o := n
 KCOV_INSTRUMENT_core_$(BITS).o := n
 UBSAN_SANITIZE_core_$(BITS).o := n
 KASAN_SANITIZE_core.o := n
-KASAN_SANITIZE_core_$(BITS) := n
+KASAN_SANITIZE_core_$(BITS).o := n


