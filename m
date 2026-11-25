Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622338;
	b=2+JQb7okgLgcSRD718POC4YHgaMiUuhrnbU9I4vDAvEBiBLk2eUu07/nk8leUvKsI39l
	 sTWqzJaS4UVJ1cjv8VixjigRV13qJcfQzBEbpocEKm7W3I/2V6Yu2kr9HSzVapjWtTUFG
	 x6SkLJ3JLqeHCvGZ+Dv96omnI8msemFM+dDxw+X5WvHemcQ00pnZZpZYnXmosVvXD7Qet
	 P+S+VJJ0rJ50lUtUTpqcBDjtWwRijNNpsrdlrN5l45/8ktOgombQr7Qr0qcEi1DXmmgWK
	 kaLD/2pMSSk8F4jpCPOiYfOaNpF69ZCwlp/fOm2SY0X42U2poeilqWJkR7xWpta8FXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mZ/b/OiNsqKJ2H9aac8nVczKSv3AkpNBQKm5Hyb49Yg=;
	b=WOa24ObxQ+vqUaYXGUN0k8Gx2RzIFsaF676o2Jyz43/70j2NwPuPH75wZ2dicCU1legi
	 wJqLMdqbSUItkqiU8X7mtClr52MyoJgyaLies3e+eiIaSHNwwAaIaMDpSHpp+dzdG8t1T
	 r6/udnjqtu6UJKzEq71Sy1+INySorsZMMIjtUcGkEjBbUyjnArXQMd6BfmX2/bWiv5H2i
	 4PYvCqbfEZFp1q7/5YNHcWfPINPsXG+6qMlADKsqr02VOuk7FLeUkmRSdfLkXHZQsYw8d
	 0WgNJuuKBJinN2HtnUr7zDe8mBEudf8d2Ymho/RvNOoq+RZlvNYWt1HnvyODm81HDdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmoNPeXv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29F8606A682;
	Wed, 25 Nov 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AmoNPeXv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57591F000E0;
	Wed, 25 Nov 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622338;
	bh=mZ/b/OiNsqKJ2H9aac8nVczKSv3AkpNBQKm5Hyb49Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmoNPeXvyFSGi96qq2zp2A5qneU+TACPdoVuWUnV4K4sPhYbVUft0zIsmqof/Nin6
	 5i/9iBD3VFXtOAXeT3ogBRtDlvB6ciWV60zSL9r1uoJmrNMP0eVDuhDvcEB7DrVc+c
	 +cKk2kW69kXnsyJfzbzpdTPNtIwnf/h06CLyzsbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Matt Turner <mattst88@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 507/990] perf thread: Fix live-session detection in thread__e_machine()
Date: Wed, 25 Nov 2026 15:31:14 +0100
Message-ID: <20261125143833.976072794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

[ Upstream commit 15917a3a1ce0695f824892c8f9d0dc51408ee580 ]

When the per-thread e_machine cannot be determined from the DSOs in the
thread's maps, thread__e_machine_endian() decides between reading
/proc/<pid>/exe and falling back to the recorded session environment:

	bool is_live = machine->machines == NULL;

	if (!is_live) {
		/* Check if the session has a data file. */
		struct perf_session *session = container_of(...);

		is_live = !!session->data;
	}

Neither half of that works.

The back pointer added by commit a088031c4998 ("perf tools: Add machine to
machines back pointer") is set by machines__add(), which only ever adds
guests; the host machine never gets one.  Host-machine threads, which is to
say almost all of them, therefore see machine->machines == NULL and are
declared live before the session is consulted at all.

The session test is also inverted.  A session with a perf_data attached is
one being read from a perf.data file, i.e. exactly the case that is not
live, while a live session such as 'perf top' passes data=NULL to
__perf_session__new().

So a file-based session takes the live path and reads /proc/<pid>/exe on
the analysing host, which at best describes an unrelated process that has
since been given the recorded pid, and normally just fails, leaving
e_machine as EM_NONE.  The perf_env fallback that would have supplied the
recorded architecture is never reached, and thread__e_machine() returns
EM_HOST.

For a same-architecture recording this is invisible, since EM_HOST is the
right answer anyway.  Cross-architecture it is not: annotating an Alpha
perf.data on an x86_64 host selects the x86 struct arch, so the Alpha
disassembly is matched against the x86 instruction table.  Alpha's 'ret'
collides with x86's and gets ret_ops, while its calls and branches match
nothing and are left unparsed, so no call target is resolved and no jump
arrows are drawn.

Set the back pointer for the host machine and correct the session test.
The new back pointer does not disturb the other reader of the field,
machine__findnew_guest_code(), which machine__resolve() only calls when
!machine__is_host(machine).

Fixes: 70351029b55677eb ("perf thread: Add support for reading the e_machine type for a thread")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Context-only adaptation: machines__init() returns void here and the function is thread__e_machine() rather than thread__e_machine_endian(), so the two changed lines are placed in that older code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 1 +
 tools/perf/util/thread.c  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 8452d776d994a..091022e9c867f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -232,6 +232,7 @@ void machine__delete(struct machine *machine)
 void machines__init(struct machines *machines)
 {
 	machine__init(&machines->host, "", HOST_KERNEL_ID);
+	machines->host.machines = machines;
 	machines->guests = RB_ROOT_CACHED;
 }
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 9409d32dce04c..bda001ccf571d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -518,7 +518,7 @@ uint16_t thread__e_machine(struct thread *thread, struct machine *machine)
 								    struct perf_session,
 								    machines);
 
-			is_live = !!session->data;
+			is_live = !session->data;
 		}
 		/* Read from /proc/pid/exe if live. */
 		if (is_live)
-- 
2.53.0



