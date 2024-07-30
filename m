Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAC31A76B6;
	Tue, 30 Jul 2024 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360496; cv=none; b=rgRqruvXQYO4JFxqscJI8HnrRslw8nswXxoaVtouUFdaxbcKCnkQNjb/Hrmrbn9qVW3EyaADuZZlfAHcrbJJDwqtGIw+lXSl7UhkXxhwm45XipGo6Mf6XjBX6PNICPg2/u9TB6t/uAcVHXsysLEcUj+0lnrqNzop+RuIuE5cqoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360496; c=relaxed/simple;
	bh=3hpi32gFloyuox/MaKoGRcaylG0DN8aV1l/iF1uvdc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxpKsnkdQcJOAedMYqEjBuMafMMA9ZrWrU0gi2crqpVMMZ9FRwfh5nb4BwSxLM/fNy8/UgVNLh9mk2CuwygRn9Mv0hLE+LuAc2qLap6i/oJTAS1AiHSmBinUKNO5uaDTvkH1JK+MmYGkA3o1BH0VFpKtDSWi5rmU4q94KejhC9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWySVfUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWySVfUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CE0C4AF0C;
	Tue, 30 Jul 2024 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360495;
	bh=3hpi32gFloyuox/MaKoGRcaylG0DN8aV1l/iF1uvdc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWySVfUveHwjrX/0jnKXBqQTn13KQO4uCDcTacxw2mpUss6DSh9MAh2/x4I/1WwpR
	 9eYqIvQvpaMvCPOPy9Oi1dV/hirHAHlFucX1+DXiVj0dLUiBpYlP3llR4vroGOU+py
	 +oWsXcP06/gCRl5d5wEkJv3/rZ8NaOmO3MH4YNnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.10 716/809] selftests/sigaltstack: Fix ppc64 GCC build
Date: Tue, 30 Jul 2024 17:49:52 +0200
Message-ID: <20240730151753.217238514@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


