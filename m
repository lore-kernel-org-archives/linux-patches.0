Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD55371041;
	Thu, 17 Sep 2026 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668778; cv=none; b=rLI9BPzj36PHnEf/TGXraZYpd/QAJDVGm6KHMnT28zKV932PDqxvTbfPp6OML+4n7ysCthB7rWCy1AahBUpn4BTvC3e64BpXd6g8DKZEdiycETcztoiYkRZI+CFT/YJUn4NWNel3UeTzPbDLIyIJxKKdMiQj6ZT/q61GJHWVLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668778; c=relaxed/simple;
	bh=Yyo1IHH81h5HzoxDOEgbYfK6mhpg+QVdhvjbCHNLPwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6GKoB2/0omwpRxZa6P4T9O0RrG1w7oTOMBlYm9XSIM28AooalmbO1FwmE3RAcJSl9c/L4JchTrYwUjiphQPBrPuVcqsm+k/IsYaFJckK5xYqD4sCVaY22oNGKSDJ2NCtDgSA3zumeXsk/mfilvb30zFL7oLsAmxwU4TF2Im9Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQm1tP8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQm1tP8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87191F000FF;
	Thu, 17 Sep 2026 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668776;
	bh=S5FvbGZdJqU6m/xVmH2aio3slqBmJ5JP+LgrwNPSTCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQm1tP8uprefDsIfiq3goeCG1vKfd6JWu27Nq8PlFuCK1Ldm6CAPvX6lSAHau++TE
	 ZaJ+6lcTHMjN5Jneq4qxxpDbWH6Fcgb5FbzQqXZvfWKfA99SuwKI0EYswYObyKxKx+
	 nWNJi0VGX07JeDgqaQTL+k0Ii00nMwcZtdXv3i5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Lipcon <tlipcon@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0537/1102] perf symbol: Do not use debug file as the binary type
Date: Thu, 17 Sep 2026 16:08:00 +0100
Message-ID: <20260917151553.294862774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ae9464c65e9d1ad4df4fed516cee9bca3bc614cc ]

dso__load() sets the binary type of a DSO to the type of the first symbol
source found. For a DSO with a separate debug file linked via
.gnu-debuglink, that is DSO_BINARY_TYPE__DEBUGLINK, which makes
dso__get_filename() return the name of the debug file instead of the file
that was actually executed.

Consumers that need to read instruction bytes, such as Intel PT decoding
in 'perf script', then read from the debug file and produce wrong
instructions.

Prefer DSO_BINARY_TYPE__BUILD_ID_CACHE, and otherwise
DSO_BINARY_TYPE__SYSTEM_PATH_DSO, over debug-only types, which restores
the behaviour of using a file that contains the executed instructions.

This is a workaround. Properly separating the binary file used for
instructions from the file used for debug symbols is left for later.

Example:

 Create a shared object with a separate .gnu_debuglink debug file. Note
 that 'objcopy --only-keep-debug' leaves .text as NOBITS, so instructions
 read from the debug file are zeros:

  # cat > foo.c << EOF
  unsigned long foo_work(unsigned long n)
  {
        unsigned long s = 0;

        for (unsigned long i = 0; i < n; i++)
                s = s * 31 + i;
        return s;
  }
  EOF
  # cat > main.c << EOF
  #include <stdio.h>
  unsigned long foo_work(unsigned long n);
  int main(void)
  {
        printf("%lu\n", foo_work(1000));
        return 0;
  }
  EOF
  # gcc -g -O2 -shared -fPIC -o libfoo.so foo.c
  # gcc -g -O2 -o main main.c -L. -lfoo -Wl,-rpath,'$ORIGIN'
  # objcopy --only-keep-debug libfoo.so libfoo.so.debug
  # objcopy --strip-debug libfoo.so
  # objcopy --add-gnu-debuglink=libfoo.so.debug libfoo.so
  # perf record -e intel_pt//u ./main

 Note that branch samples must be requested, because it is the resolving
 of the branch target symbol that causes dso__load() to be called, and
 hence the binary type to be set, before the decoder walks the code.
 With '--itrace=e' alone, nothing loads symbols for libfoo.so, the binary
 type is left as DSO_BINARY_TYPE__NOT_FOUND, the correct file is read
 anyway, and no errors are reported either way.

 Before:

  # perf.before script --itrace=be 2>&1 | grep "instruction trace error"
   instruction trace error type 1 time 2350.467489498 cpu 9 pid 75634 tid 75634 ip 0x77d48480718f code 6: Trace doesn't match instruction
   instruction trace error type 1 time 2350.467489832 cpu 9 pid 75634 tid 75634 ip 0x77d484807341 code 6: Trace doesn't match instruction
   instruction trace error type 1 time 2350.467496412 cpu 9 pid 75634 tid 75634 ip 0x5b4de37a8074 code 6: Trace doesn't match instruction
   instruction trace error type 1 time 2350.467593393 cpu 9 pid 75634 tid 75634 ip 0x77d4848070d0 code 6: Trace doesn't match instruction
   instruction trace error type 1 time 2350.467593954 cpu 9 pid 75634 tid 75634 ip 0x77d4848075a8 code 6: Trace doesn't match instruction
   instruction trace error type 1 time 2350.467595728 cpu 9 pid 75634 tid 75634 ip 0x77d4848324de code 6: Trace doesn't match instruction
  6 instruction trace errors

 After:

  # perf script --itrace=be 2>&1 | grep "instruction trace error"
  #

Fixes: 5363c306787c8 ("perf symbol: Set binary_type of dso when loading")
Reported-by: Todd Lipcon <tlipcon@google.com>
Closes: https://lore.kernel.org/all/CAGH6UiG=RJLqBU3kLu9XJciPyPO1HZkbAPERguVUMRuWQgqf=A@mail.gmail.com/
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 249de806f8e0d..b3f25a937b71e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1933,7 +1933,16 @@ int dso__load(struct dso *dso, struct map *map)
 		if (next_slot) {
 			ss_pos++;
 
-			if (dso__binary_type(dso) == DSO_BINARY_TYPE__NOT_FOUND)
+			/*
+			 * The binary type is used to find the file containing
+			 * the executed instructions, so prefer the types that
+			 * refer to the actual object over debug-only files such
+			 * as DSO_BINARY_TYPE__DEBUGLINK.
+			 */
+			if (dso__binary_type(dso) == DSO_BINARY_TYPE__NOT_FOUND ||
+			    symtab_type == DSO_BINARY_TYPE__BUILD_ID_CACHE ||
+			    (symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_DSO &&
+			     dso__binary_type(dso) != DSO_BINARY_TYPE__BUILD_ID_CACHE))
 				dso__set_binary_type(dso, symtab_type);
 
 			if (syms_ss && runtime_ss)
-- 
2.53.0



