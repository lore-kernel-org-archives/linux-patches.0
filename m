Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033409;
	b=xA8knGzGzoe5ULZwAondEwliKSNVeZdZmWJgqIv05sEWZXdOZ4+B/wmSjrvOSy+Ui4YI
	 wnAeppUL+wyp/z6pNYzCAI+62q7X/YuZgPeQkg/MCEX/oQhcYb3xmAVsY0401FCe3NnGo
	 vmrHnGmdzfqrOq5USmcigDw2B0e2COKvSTCEgrR37auQBfkPwhFctFAAxGkSj2DPsU2UD
	 Rt6Xbr9K7eZbtYmiK0vaU6KhWBX3sJ7Qn485QzYXMtO2eqDa5yYKOMgxA5AzAqFdjbkhR
	 HM96pf4a34hBhpV3x68KByrYBtPK9uvHssOPHjKVycrqOjrUSXcG0z2EYludH7GZsCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WedX5ijGvWHP3Qx1efz4lyHjR92Ee1qtYLqR4IYscE4=;
	b=dewX6uzVswERREGd5DCxsh3q+JzMwvWr6WeDR9pUZWvT+9dKzakFWP2b7dIwkr3hwThV
	 F6bjRI/HG8ADSX+ZoH/2E6yMMl9BnXKrhd1+Gy+01RWhEZxG5hJ90Ie7fvsCgEj65q7k3
	 oKO4iriTTxYdZ8KDVdsi0ra6V8qGxCpjzG2XCoj/kc0opvoKrwp1xxQdequC+2izVQVlD
	 QZV2OOX858d+9LfNU90RXYBC1AnbRl3JNSPydvrNktBBRr72tVvIWxGKaV1vAzvZrTkJX
	 aoCYe2+llcJSaSArh1Z/BkUchnGiRWahSxTQiMIClJwSgRkYBNEgAcEnMoWUp1IK4Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8VtELeE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B0D606A32A;
	Wed, 18 Nov 2026 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O8VtELeE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7460C1F000C4;
	Wed, 18 Nov 2026 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033409;
	bh=WedX5ijGvWHP3Qx1efz4lyHjR92Ee1qtYLqR4IYscE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8VtELeEEkeHV+MOryo5bef9iX/YK/9Dsiz1G4UVvOTstPcRGDXm0KUwNHkiLgd5O
	 8ssMTW2gsptSyM/cg5sHcNe1CNfVeghmkqvVZaC3OKZm9JR41UATolRqFhFtSxdOgj
	 Wg7Mb0dXXnKVHQYTldd8VTWS9EN2Conalk5kj36U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.12 1740/1756] perf libunwind: Fixup conversion perf_sample->user_regs to a pointer
Date: Wed, 18 Nov 2026 16:04:27 +0100
Message-ID: <20261118150118.817622574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 4e82c88a90a99b50f6488defd0d3d85ddc47c068 upstream.

The dc6d2bc2d893a878 ("perf sample: Make user_regs and intr_regs optional") misses
the changes to a file, resulting in this problem:

  $ make LIBUNWIND=1 -C tools/perf O=/tmp/build/perf-tools-next install-bin
  <SNIP>
    CC      /tmp/build/perf-tools-next/util/unwind-libunwind-local.o
    CC      /tmp/build/perf-tools-next/util/unwind-libunwind.o
  <SNIP>
  util/unwind-libunwind-local.c: In function ‘access_mem’:
  util/unwind-libunwind-local.c:582:56: error: ‘ui->sample->user_regs’ is a pointer; did you mean to use ‘->’?
    582 |         if (__write || !stack || !ui->sample->user_regs.regs) {
        |                                                        ^
        |                                                        ->
  util/unwind-libunwind-local.c:587:38: error: passing argument 2 of ‘perf_reg_value’ from incompatible pointer type [-Wincompatible-pointer-types]
    587 |         ret = perf_reg_value(&start, &ui->sample->user_regs,
        |                                      ^~~~~~~~~~~~~~~~~~~~~~
        |                                      |
        |                                      struct regs_dump **
<SNIP>
  ⬢ [acme@toolbox perf-tools-next]$ git bisect bad
  dc6d2bc2d893a878e7b58578ff01b4738708deb4 is the first bad commit
  commit dc6d2bc2d893a878e7b58578ff01b4738708deb4 (HEAD)
  Author: Ian Rogers <irogers@google.com>
  Date:   Mon Jan 13 11:43:45 2025 -0800

      perf sample: Make user_regs and intr_regs optional

Detected using:

  make -C tools/perf build-test

Fixes: dc6d2bc2d893a878 ("perf sample: Make user_regs and intr_regs optional")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250313033121.758978-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/unwind-libunwind-local.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/tools/perf/util/unwind-libunwind-local.c
+++ b/tools/perf/util/unwind-libunwind-local.c
@@ -579,12 +579,12 @@ static int access_mem(unw_addr_space_t _
 	int ret;
 
 	/* Don't support write, probably not needed. */
-	if (__write || !stack || !ui->sample->user_regs.regs) {
+	if (__write || !stack || !ui->sample->user_regs || !ui->sample->user_regs->regs) {
 		*valp = 0;
 		return 0;
 	}
 
-	ret = perf_reg_value(&start, &ui->sample->user_regs,
+	ret = perf_reg_value(&start, perf_sample__user_regs(ui->sample),
 			     perf_arch_reg_sp(arch));
 	if (ret)
 		return ret;
@@ -628,7 +628,7 @@ static int access_reg(unw_addr_space_t _
 		return 0;
 	}
 
-	if (!ui->sample->user_regs.regs) {
+	if (!ui->sample->user_regs || !ui->sample->user_regs->regs) {
 		*valp = 0;
 		return 0;
 	}
@@ -637,7 +637,7 @@ static int access_reg(unw_addr_space_t _
 	if (id < 0)
 		return -EINVAL;
 
-	ret = perf_reg_value(&val, &ui->sample->user_regs, id);
+	ret = perf_reg_value(&val, perf_sample__user_regs(ui->sample), id);
 	if (ret) {
 		if (!ui->best_effort)
 			pr_err("unwind: can't read reg %d\n", regnum);
@@ -741,7 +741,7 @@ static int get_entries(struct unwind_inf
 	unw_cursor_t c;
 	int ret, i = 0;
 
-	ret = perf_reg_value(&val, &ui->sample->user_regs,
+	ret = perf_reg_value(&val, perf_sample__user_regs(ui->sample),
 			     perf_arch_reg_ip(arch));
 	if (ret)
 		return ret;
@@ -808,7 +808,7 @@ static int _unwind__get_entries(unwind_e
 		.best_effort  = best_effort
 	};
 
-	if (!data->user_regs.regs)
+	if (!data->user_regs || !data->user_regs->regs)
 		return -EINVAL;
 
 	if (max_stack <= 0)


