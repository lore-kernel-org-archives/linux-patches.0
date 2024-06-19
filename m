Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD03C12FB31;
	Wed, 19 Jun 2024 13:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802426; cv=none; b=bxnAjJblJxWsoodxjLQrIFcP6iPq1wbWzJ1gzQZtJrgHV0192HczG1ajFa/93h9JeuO2CuJuwltOL+sTWgET8vHgUyvPOnqLpiXPjsLJ5bKTqHQxJsuCgmuhrvOf8DjvWQbqgnJ5//1xsEFtIY7gw+G9fbOiz0JOdz4bJTmR83w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802426; c=relaxed/simple;
	bh=lZ36BWbBv/69Iug7UkBud50yrNLOgRMEMKoZ4fZm0bM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdFRk64sslrSgVTGvROvtCYlkUxrImj9NkLHM7dy+Gl/v0A8Tb1Yi1zxAbq5xvARtoqS3ri9MpesEhW6IhSQgP+mZ4SCfVew6tiGNlx69sbyessnBQJDT0IAeCV+4Nut5OUCFKkKJCiY4hMEYjKEiX1jPSAMgR01+gWHm6DbGh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD4nO2ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD4nO2ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41180C2BBFC;
	Wed, 19 Jun 2024 13:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802426;
	bh=lZ36BWbBv/69Iug7UkBud50yrNLOgRMEMKoZ4fZm0bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YD4nO2ky4cme4vQMt2sizgl7PPb7WUnAL9F2pHFBEdCQHX0QstvhhcuMMhhtYNyMG
	 89JKp6prCPKPK+0cnTjC43VjSKpgZ2vqG8CeJ+za+VTcaMGNeCtRDh99PkQu6CHPJd
	 w2idCAw2kZ1AYJymGHbwi+9gez1su1coC/1DUXEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.6 193/267] perf auxtrace: Fix multiple use of --itrace option
Date: Wed, 19 Jun 2024 14:55:44 +0200
Message-ID: <20240619125613.745426247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit bb69c912c4e8005cf1ee6c63782d2fc28838dee2 upstream.

If the --itrace option is used more than once, the options are
combined, but "i" and "y" (sub-)options can be corrupted because
itrace_do_parse_synth_opts() incorrectly overwrites the period type and
period with default values.

For example, with:

	--itrace=i0ns --itrace=e

The processing of "--itrace=e", resets the "i" period from 0 nanoseconds
to the default 100 microseconds.

Fix by performing the default setting of period type and period only if
"i" or "y" are present in the currently processed --itrace value.

Fixes: f6986c95af84ff2a ("perf session: Add instruction tracing options")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240315071334.3478-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1466,6 +1466,7 @@ int itrace_do_parse_synth_opts(struct it
 	char *endptr;
 	bool period_type_set = false;
 	bool period_set = false;
+	bool iy = false;
 
 	synth_opts->set = true;
 
@@ -1484,6 +1485,7 @@ int itrace_do_parse_synth_opts(struct it
 		switch (*p++) {
 		case 'i':
 		case 'y':
+			iy = true;
 			if (p[-1] == 'y')
 				synth_opts->cycles = true;
 			else
@@ -1646,7 +1648,7 @@ int itrace_do_parse_synth_opts(struct it
 		}
 	}
 out:
-	if (synth_opts->instructions || synth_opts->cycles) {
+	if (iy) {
 		if (!period_type_set)
 			synth_opts->period_type =
 					PERF_ITRACE_DEFAULT_PERIOD_TYPE;


