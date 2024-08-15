Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2C13214;
	Thu, 15 Aug 2024 14:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731432; cv=none; b=Sby+dpiT9on5pB0hvxVcqD/1JSTK/w12A+OcL2j0H7mtnLNWHZYom9XK2yesifqm/iG/IUKkthcbxd+qAjkmBIFPpAOLJrOOHdi/bVZKBVU+1GHfiNsuuazK41bIyB/tRpPbGEIcNgNCtzSF9uwKKFk/iIw3RqNYfJeiZoigiNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731432; c=relaxed/simple;
	bh=7+Tg8p3rHpDOF7b2TPN6Y9wsfESHkWCx9q2izqWuUrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lr6AepioeygErB1FNiRPKwXT6uFvk0Uk/541VpkuhRXanTsNTAB3oQ5AUtBKVZAUfKnuI3ClHPEDKT1FbW3diptHzJP9i0BvHaBLDOEDHZQ7h85Y2IA/FK8Eote4XtnMMBY/6unNOM4mThRhK5DPDvArLutD5qSmTOMgc8LwNvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdJTTIZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdJTTIZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08357C32786;
	Thu, 15 Aug 2024 14:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731432;
	bh=7+Tg8p3rHpDOF7b2TPN6Y9wsfESHkWCx9q2izqWuUrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdJTTIZ/XIMppOk3lxTo6z9ofGfxFQc/4wHPqEoo+zHOqGa4sKo/p2HIE9UJisa+4
	 XkuBfWVH8UqOGOq3wDxpZ5TIlFQKNgTuSfqm5FMmNPs5+kh4vHIJUG++QZvrhUIkq2
	 ohpwNypJng4TPldqemr7i01nf0GH4WiAvyC1GGLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 126/259] selftests/sigaltstack: Fix ppc64 GCC build
Date: Thu, 15 Aug 2024 15:24:19 +0200
Message-ID: <20240815131907.660258530@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


