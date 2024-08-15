Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2261D1494C5;
	Thu, 15 Aug 2024 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729898; cv=none; b=ScBXRDLj94EtAuqZ0DA56/K1645Vig4n8OEvWMthTDN/VjuBbEsVkFrBlKL+iw5RIfuqELNoWyW+uFG/yTelWu2Rql4lz3hSmHycr1zZOFXmX5aLm6vLWd7tth8LhNitn4ALLYOMCnVkt3g4eNG52R+6UOTZ3K9aO+C+PxH4ki0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729898; c=relaxed/simple;
	bh=nfOUqX64UEBSo7Z/02aUa3JEl0HbUuJ2OoWexH+gF6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcCUJiu8e0/QaXNuvmm3dtna+8Kr+ogacJeFVtY9XDwHj/YpK2Us1efp01Wptj1a4nEnokmQOebh5vswWuhYs7oi2jFA7192/DnItvGwKjJCyutXV8tWgH5Dm128fl20Bd1UiFkKH/Rc87UF0LKUrxEIN+Aeswz7AvbB1+DIMd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHe0z62+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHe0z62+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6E2C32786;
	Thu, 15 Aug 2024 13:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729898;
	bh=nfOUqX64UEBSo7Z/02aUa3JEl0HbUuJ2OoWexH+gF6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHe0z62+LNRbQceCl0Sxg3q32CcmNadSvT3FSn7MgavEmNC/+MOVyJGY0s24QpOXh
	 AuknXQ317ykGvqUTVidAsVciRRyDR+i/UnteIUzEc29ajuf5+eQFmRsA1/Fb5BV3MZ
	 NvQ/fU3ZYWWgEiFJdzQR54sIt5YzHN+p/1Ok4dsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 242/484] selftests/sigaltstack: Fix ppc64 GCC build
Date: Thu, 15 Aug 2024 15:21:40 +0200
Message-ID: <20240815131950.750087060@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


