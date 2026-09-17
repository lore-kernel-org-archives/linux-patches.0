Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87A59D62B;
	Thu, 17 Sep 2026 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659057; cv=none; b=X5epHqDibuiNDUF+0qDmwgLPZ7xcVKGScy1OM3qmMnY022X9cChRBHFiBkgjz5WULccCalv2GGmFAzrbbB70OVbEv3Q1E5Fn6bBfTeN0VgK/AXERRIggZyI0yhfECul1+EHp6o1DnzVgW++zrnP4W4Pn/FV8Mb7UC59jQuntadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659057; c=relaxed/simple;
	bh=a/5hXz7EdqN0DVcGwgP8VpxoClQzE7q8eyj91b2vcWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH0Qth3Q+XnxwQ+1y/TQkrSKyqd6Btbx1WAOp0kq8Vne/AF+uUfnfCU/6kGbG2Q0L8ZldLBzQBZs26sJgA2lAWfeuJi/VvRay+iWGewjKDNqDeKrbOpDbnVNGl9LfTUwtmBMMD/flDnFRIAsgWuxZPZ9875/HB6AtsSZFNo/OLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6fg/Nyz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6fg/Nyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C251F00893;
	Thu, 17 Sep 2026 15:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659049;
	bh=4GS/9tk5N2dtQeufzjRu/hC9+9fUnk/Xahri/JS1njs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6fg/NyzYJaZLYHUPN2JI8vNynPDCRgNspw+PqXy74xFXfFCUPSP5BBpZWjvuntGi
	 DwIpMUraV7zo5pHyHBtt/pQCGTP4CUTw1O7fuL6kjyOyum931Ub1DEUbI77+Rm7JKd
	 bFszQzR0AdbUXP7Rf2vc1L92w3ZV+UmcegAqo7ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Lipcon <tlipcon@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 077/733] perf symbol: Do not use debug file as the binary type
Date: Thu, 17 Sep 2026 16:06:25 +0100
Message-ID: <20260917151352.799007272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 35104a56d8e38..1de5796fc4ff6 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1947,7 +1947,16 @@ int dso__load(struct dso *dso, struct map *map)
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



