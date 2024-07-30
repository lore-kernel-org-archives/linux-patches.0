Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4781A76A8;
	Tue, 30 Jul 2024 17:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359489; cv=none; b=i2KvJDK3+smT4N+gRmDU/5/kT5dZ/pkte4k4kEqHMf8A6/0XjaQpa20V1zQYC8CPOqyLU00rqscWygzU0NdLZVhzF1u4j3rlxWI9Hfkw78RQ0MWUZOgaCT13K+P5B7iu8Z/xHEeB8Z1TXKsQFFc8nOWUFuh9hKPC2nCI9DLN3ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359489; c=relaxed/simple;
	bh=57PrMI9Ppa7ad2VVpMJWKsUNW8YwOs5Uxi2YknwgqKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4bslmcw+q9uHUZNeXoDKGzC2UGScERYF+wH4/yPI/6GKNSxLceSNsviRMS36kw3bLKCMfi4eAkimusTbLl+EOHvDDXLditoAkK3syd6PjeeugMHnYSPKqCdA1cfxMCd44Kd1ppp0CRGszY6qH74INs0dEhqSeWsxcjsnxC6eLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrfDr3Tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrfDr3Tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888E2C32782;
	Tue, 30 Jul 2024 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359488;
	bh=57PrMI9Ppa7ad2VVpMJWKsUNW8YwOs5Uxi2YknwgqKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrfDr3TvnUgYexuoXgp5xOnUL0TOIQnmhQkMvKTZfTnoN4uBR1y2z+f7uxjrDzwpp
	 8vxzt/KZowhXlVBIiXRT3MpyEwXnAove5QNXAKdVJTJGffBiF8p5k9vBNolYaoL0ga
	 Ourl7B6g3T7M6UIf35gqFxGYAu283uMGBnazY/yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.6 487/568] selftests/sigaltstack: Fix ppc64 GCC build
Date: Tue, 30 Jul 2024 17:49:54 +0200
Message-ID: <20240730151659.062288624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


