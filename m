Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE71ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73956C433C9;
	Tue, 25 Jul 2023 11:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283336;
	bh=s5+ze8UKUyFGiQ0Mtq3K4axWXtr38umOmZu0BzCSC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8YtjN/PAZlcr9MRpIPqdwjUVd8Lcya9+Q3bsOTzCtlwgxNNCdI/kOcn47BSU0eEo
	 5C/mliej/OIRM8K83BLJahwkkKlWX+Pn+ov6CqY3cDbApYP2fYRFC/TYE0hWN54IgD
	 x2Y2y4pcsJjjHjBH9Wt5GMhkFYkm3Gq7tjW8KuMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	James Clark <james.clark@arm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
	coresight@lists.linaro.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 40/78] perf build: Fix library not found error when using CSLIBS
Date: Tue, 25 Jul 2023 12:46:31 +0200
Message-ID: <20230725104452.851867826@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Clark <james.clark@arm.com>

[ Upstream commit 1feece2780ac2f8de45177fe53979726cee4b3d1 ]

-L only specifies the search path for libraries directly provided in the
link line with -l. Because -lopencsd isn't specified, it's only linked
because it's a dependency of -lopencsd_c_api. Dependencies like this are
resolved using the default system search paths or -rpath-link=... rather
than -L. This means that compilation only works if OpenCSD is installed
to the system rather than provided with the CSLIBS (-L) option.

This could be fixed by adding -Wl,-rpath-link=$(CSLIBS) but that is less
conventional than just adding -lopencsd to the link line so that it uses
-L. -lopencsd seems to have been removed in commit ed17b1914978eddb
("perf tools: Drop requirement for libstdc++.so for libopencsd check")
because it was thought that there was a chance compilation would work
even if it didn't exist, but I think that only applies to libstdc++ so
there is no harm to add it back. libopencsd.so and libopencsd_c_api.so
would always exist together.

Testing
=======

The following scenarios now all work:

 * Cross build with OpenCSD installed
 * Cross build using CSLIBS=...
 * Native build with OpenCSD installed
 * Native build using CSLIBS=...
 * Static cross build with OpenCSD installed
 * Static cross build with CSLIBS=...

Committer testing:

  ⬢[acme@toolbox perf-tools]$ alias m
  alias m='make -k BUILD_BPF_SKEL=1 CORESIGHT=1 O=/tmp/build/perf-tools -C tools/perf install-bin && git status && perf test python ;  perf record -o /dev/null sleep 0.01 ; perf stat --null sleep 0.01'
  ⬢[acme@toolbox perf-tools]$ ldd ~/bin/perf | grep csd
  	libopencsd_c_api.so.1 => /lib64/libopencsd_c_api.so.1 (0x00007fd49c44e000)
  	libopencsd.so.1 => /lib64/libopencsd.so.1 (0x00007fd49bd56000)
  ⬢[acme@toolbox perf-tools]$ cat /etc/redhat-release
  Fedora release 36 (Thirty Six)
  ⬢[acme@toolbox perf-tools]$

Fixes: ed17b1914978eddb ("perf tools: Drop requirement for libstdc++.so for libopencsd check")
Reported-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: James Clark <james.clark@arm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Uwe Kleine-König <uwe@kleine-koenig.org>
Cc: coresight@lists.linaro.org
Closes: https://lore.kernel.org/linux-arm-kernel/56905d7a-a91e-883a-b707-9d5f686ba5f1@arm.com/
Link: https://lore.kernel.org/all/36cc4dc6-bf4b-1093-1c0a-876e368af183@kleine-koenig.org/
Link: https://lore.kernel.org/r/20230707154546.456720-1-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 2c30a2b577d3e..973c0d5ed8d8b 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -143,9 +143,9 @@ FEATURE_CHECK_LDFLAGS-libcrypto = -lcrypto
 ifdef CSINCLUDES
   LIBOPENCSD_CFLAGS := -I$(CSINCLUDES)
 endif
-OPENCSDLIBS := -lopencsd_c_api
+OPENCSDLIBS := -lopencsd_c_api -lopencsd
 ifeq ($(findstring -static,${LDFLAGS}),-static)
-  OPENCSDLIBS += -lopencsd -lstdc++
+  OPENCSDLIBS += -lstdc++
 endif
 ifdef CSLIBS
   LIBOPENCSD_LDFLAGS := -L$(CSLIBS)
-- 
2.39.2



