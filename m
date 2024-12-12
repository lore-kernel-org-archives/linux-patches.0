Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A575F223E71;
	Thu, 12 Dec 2024 16:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021079; cv=none; b=OuAzZNaeXGkByVWj1+E+CCzd8CJ3EVfntJsaoPW+EPgRUkbiOSijNRHw+GBAA3y1hu6xkfzY73StxC0s/Krgn7kbjUH4AFtdx+NOeqBgg6tGfMRo4050XxI2GWRDh7jkNzt5Bi/XGubkaqb4/c22f8q4qcr6vZCpboQ1aFpwFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021079; c=relaxed/simple;
	bh=WaaOzXn1lzKTc8HKCkLo7mEbfEM2Gk4xFu2pn1mj2I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcm2tVhHZIDM+FeVMVijvHWOgOHAtlQfMG2AbqgknYm/8z7j1ahtLtHFg+emejWQzHmz8zVVAOICqOSDmFiFly9jHBxPEQm43Hi6HJbMBqq0Q2RSNrY16lGkhtPAXj14vDl9R84WIa80SiaKbqqiUeVHc+gzjxkemai0qEbZn44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6rdScpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6rdScpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE808C4CECE;
	Thu, 12 Dec 2024 16:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021079;
	bh=WaaOzXn1lzKTc8HKCkLo7mEbfEM2Gk4xFu2pn1mj2I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6rdScpQCR/XljNeCYcF3pi1eQRsgE7a9peWd5cwA6xNOHv92WeHbCq817tTCcEJ5
	 Yk8vYhG9PSqK3qHAop8xLIAxRhWht1RNwiQatdbahT0/pWRek8quOhPAannqB0+3AL
	 DM2Hkv4yby1S6HQ1VsP1A+0JZfrxjlY+of39lB78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 639/772] lib: stackinit: hide never-taken branch from compiler
Date: Thu, 12 Dec 2024 15:59:44 +0100
Message-ID: <20241212144416.336523121@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit 5c3793604f91123bf49bc792ce697a0bef4c173c upstream.

The never-taken branch leads to an invalid bounds condition, which is by
design. To avoid the unwanted warning from the compiler, hide the
variable from the optimizer.

../lib/stackinit_kunit.c: In function 'do_nothing_u16_zero':
../lib/stackinit_kunit.c:51:49: error: array subscript 1 is outside array bounds of 'u16[0]' {aka 'short unsigned int[]'} [-Werror=array-bounds=]
   51 | #define DO_NOTHING_RETURN_SCALAR(ptr)           *(ptr)
      |                                                 ^~~~~~
../lib/stackinit_kunit.c:219:24: note: in expansion of macro 'DO_NOTHING_RETURN_SCALAR'
  219 |                 return DO_NOTHING_RETURN_ ## which(ptr + 1);    \
      |                        ^~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/20241117113813.work.735-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/stackinit_kunit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/stackinit_kunit.c
+++ b/lib/stackinit_kunit.c
@@ -199,6 +199,7 @@ static noinline void test_ ## name (stru
 static noinline DO_NOTHING_TYPE_ ## which(var_type)		\
 do_nothing_ ## name(var_type *ptr)				\
 {								\
+	OPTIMIZER_HIDE_VAR(ptr);				\
 	/* Will always be true, but compiler doesn't know. */	\
 	if ((unsigned long)ptr > 0x2)				\
 		return DO_NOTHING_RETURN_ ## which(ptr);	\


