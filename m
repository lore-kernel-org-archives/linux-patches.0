Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17C01DE2A5;
	Tue,  8 Oct 2024 13:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392670; cv=none; b=n+nHVSvROxXqtSHXkFf2zVoePBxNrotBWT8yXhOJf/i/xdgF2Fmfut/YUDK6ZCV810daSd52sckySeieZ2n9xCncNuF/G3ZC17Xo+X1VcYzsRVGqSms6y0uIR3tn77OpL7Uc8S7yXnwiLH8dqPKnJw7W1UQLrqI+3baj3PP72O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392670; c=relaxed/simple;
	bh=MPT1gJv/Qv0182ozBiSDAgSFxhRCrghwcK1/qM7kQF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGvxM73VyW8eeLHGvMI5dCPFppXB2Snf51lxgSRB3idxFU/gYHMdYUsSyiWTfwGyNTnN8xtQhimhu+OIkARlMJ9mfNkz1AcNidAgtLwy7Ic0YjzkcjhVQ2+Y3BnpdleHWvUYca1vpHXBLQVMXYeajjROWBIH3IC2WoDnQdJQxOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjawc9RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjawc9RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9A6C4CECC;
	Tue,  8 Oct 2024 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392670;
	bh=MPT1gJv/Qv0182ozBiSDAgSFxhRCrghwcK1/qM7kQF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjawc9RHT0VGQuGnf1p228B/jgWP6UnxSNlX7pPXhV86eZsBzdsE0A4M1HYsuQoSO
	 dohO4gsDofXpVcG3gt26aP7lJYyAgHHRFD/lLLsn3YRRHldCtiA06dfgi40z3Ka5tC
	 btSDA2AwfWPJIIS6eBL0b5fNZChuKzRJrIt/cLwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 477/558] kselftests: mm: fix wrong __NR_userfaultfd value
Date: Tue,  8 Oct 2024 14:08:27 +0200
Message-ID: <20241008115721.011890270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit f30beffd977e98c33550bbeb6f278d157ff54844 upstream.

grep -rnIF "#define __NR_userfaultfd"
tools/include/uapi/asm-generic/unistd.h:681:#define __NR_userfaultfd 282
arch/x86/include/generated/uapi/asm/unistd_32.h:374:#define
__NR_userfaultfd 374
arch/x86/include/generated/uapi/asm/unistd_64.h:327:#define
__NR_userfaultfd 323
arch/x86/include/generated/uapi/asm/unistd_x32.h:282:#define
__NR_userfaultfd (__X32_SYSCALL_BIT + 323)
arch/arm/include/generated/uapi/asm/unistd-eabi.h:347:#define
__NR_userfaultfd (__NR_SYSCALL_BASE + 388)
arch/arm/include/generated/uapi/asm/unistd-oabi.h:359:#define
__NR_userfaultfd (__NR_SYSCALL_BASE + 388)
include/uapi/asm-generic/unistd.h:681:#define __NR_userfaultfd 282

The number is dependent on the architecture. The above data shows that:
x86	374
x86_64	323

The value of __NR_userfaultfd was changed to 282 when asm-generic/unistd.h
was included.  It makes the test to fail every time as the correct number
of this syscall on x86_64 is 323.  Fix the header to asm/unistd.h.

Link: https://lkml.kernel.org/r/20240923053836.3270393-1-usama.anjum@collabora.com
Fixes: a5c6bc590094 ("selftests/mm: remove local __NR_* definitions")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index fc90af2a97b8..bcc73b4e805c 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -15,7 +15,7 @@
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <math.h>
-#include <asm-generic/unistd.h>
+#include <asm/unistd.h>
 #include <pthread.h>
 #include <sys/resource.h>
 #include <assert.h>
-- 
2.46.2



