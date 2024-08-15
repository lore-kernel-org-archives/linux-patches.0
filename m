Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130A1DFFB;
	Thu, 15 Aug 2024 14:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732428; cv=none; b=X3yafnjrjiveNC8y1dJ1062IAUv53l43UhpL5cDVSVfQ8ThNZWPSnJKrH6zNs2aqhkTwpq1c/8MYbHJNuGve827dmypMzB04mmSMSIgWcdxiujbXVpjPfUluo4u6zQ7GB7+F/yKKE2c97+wVfpGVYR1eNkteI04z+uyP52NjDU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732428; c=relaxed/simple;
	bh=fWyb+YmGtKzPKS3XW+xnr/r2FzIbOxcnyTmXCuZv3+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Phq/VBZWeZFKW114Dy8Gj1Zocbb6Xzo28R5q/Yy9wOEXmB/+mav9OvkIukNl2D8avQGs99H3hvXh4d9axQkkFBkXjiSXe7yglt95i+rGXIJeJ0rg6hJkzCzy2jxSbFUFZ4zXOBDQ/LlpfHqYBm2GnkWpFlHa4GRJQ7p0MUGTnL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijvg73vV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijvg73vV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180CEC32786;
	Thu, 15 Aug 2024 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732428;
	bh=fWyb+YmGtKzPKS3XW+xnr/r2FzIbOxcnyTmXCuZv3+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijvg73vVAsozxApb7OuDW5uru2veijZfYhRTfVV4c6hcGcYVOAShdL3SWtD0k+2wG
	 VPxJkeP0b8lLTtLopC90jEWqbRRKup9otrwdxlLBFj1n2/HbdD+TRr+u9/GGjeVfJz
	 SF+vr1U6vAm1bM/E5zOKXzcSoFJ7ZpvehHCzcmEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 176/352] selftests/sigaltstack: Fix ppc64 GCC build
Date: Thu, 15 Aug 2024 15:24:02 +0200
Message-ID: <20240815131926.079041523@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit 17c743b9da9e0d073ff19fd5313f521744514939 upstream.

Building the sigaltstack test with GCC on 64-bit powerpc errors with:

  gcc -Wall     sas.c  -o /home/michael/linux/.build/kselftest/sigaltstack/sas
  In file included from sas.c:23:
  current_stack_pointer.h:22:2: error: #error "implement current_stack_pointer equivalent"
     22 | #error "implement current_stack_pointer equivalent"
        |  ^~~~~
  sas.c: In function ‘my_usr1’:
  sas.c:50:13: error: ‘sp’ undeclared (first use in this function); did you mean ‘p’?
     50 |         if (sp < (unsigned long)sstack ||
        |             ^~

This happens because GCC doesn't define __ppc__ for 64-bit builds, only
32-bit builds. Instead use __powerpc__ to detect powerpc builds, which
is defined by clang and GCC for 64-bit and 32-bit builds.

Fixes: 05107edc9101 ("selftests: sigaltstack: fix -Wuninitialized")
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240520062647.688667-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/sigaltstack/current_stack_pointer.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/sigaltstack/current_stack_pointer.h
+++ b/tools/testing/selftests/sigaltstack/current_stack_pointer.h
@@ -8,7 +8,7 @@ register unsigned long sp asm("sp");
 register unsigned long sp asm("esp");
 #elif __loongarch64
 register unsigned long sp asm("$sp");
-#elif __ppc__
+#elif __powerpc__
 register unsigned long sp asm("r1");
 #elif __s390x__
 register unsigned long sp asm("%15");


