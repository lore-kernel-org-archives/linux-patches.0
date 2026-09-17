Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D936E4ABBAA;
	Thu, 17 Sep 2026 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660530; cv=none; b=IiqUoHgjm4qthm0+RwxMkCgyNHDW8AX+96ADhVHI9e4YA6zUc+SiIc2ZfzkmI9jJ0dl7ahP7JWPybZiiKJ8VZ08hPyOkv7ySA/0S8XbFfgfauBmZt+iln7EdQgJ+G3v/P5utzIPEJrIhFPaOuT+rFaKQcZ6ds67KalbIedI8Bcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660530; c=relaxed/simple;
	bh=QR/5aYtfheeFHlVWWO9EwHbbVinr8wtljGlL8n6NSY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnsV8QTNIsA522Ac1uTdm/epuLkxHhQV0SGONDNxwoxMwoAQg75W6zkX2fErjXsP8HnIG+fwWwNfhhKGc97sGY7S2qYOEjrTzImdk3IynWrE3OC6oWQ28ArCHHGH+Y+zxqWpPGrtPo3F5KCezBNyGuaZMOIqr8XEOtdqRdxBtwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eguk0Sfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eguk0Sfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1DB1F000FF;
	Thu, 17 Sep 2026 15:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660528;
	bh=aj6lBnr4NNicg3pLETymvCS213/39abXiuANPQmehbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eguk0Sfceideq8HbcUMGbKGBi0T6xY9cjtxvVI8DQ2+YKg6SS/pWf1eLhGslzCb6G
	 TmcSYXbhyWygG42yRclNPXsdxGnQFIUj3IVx3NCvP6VMiiszm/3ABLZN75UKLJlz5j
	 8DWGxvFs6M5jgskSQqWlFuiRO98G2xQh3iH6jo1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahmoud Nagy Adam <mngyadam@amazon.de>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 583/733] selftests: ublk: install test_common.sh and trace/ scripts
Date: Thu, 17 Sep 2026 16:14:51 +0100
Message-ID: <20260917151406.934885451@linuxfoundation.org>
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

From: Mahmoud Nagy Adam <mngyadam@amazon.de>

commit c4fa55f85c47cd5d54d717fb8170746edb10292e upstream.

Every ublk test script sources test_common.sh from its own directory:

    . "$(cd "$(dirname "$0")" && pwd)"/test_common.sh

and test_generic_02/12 additionally run bpftrace against the scripts in
trace/. Neither test_common.sh nor trace/ is listed in TEST_FILES, so
"make install" does not copy them into the install directory and every
ublk test fails when run from there:

  ./test_generic_02.sh: line 4: .../kselftest_install/ublk/test_common.sh: No such file or directory
  ./test_generic_02.sh: line 8: _have_program: command not found

The bpftrace tests are affected even when bpftrace is installed: the
missing trace/*.bt makes bpftrace exit immediately, and the tests then
report a skip rather than a failure, which hides the problem.

Add both to TEST_FILES, matching how other selftests ship their sourced
helpers (see kexec/kexec_common_lib.sh and zram/zram_lib.sh).

Fixes: 6aecda00b7d1e1 ("selftests: ublk: add kernel selftests for ublk")
Fixes: 723977cab4c0fd ("selftests: ublk: add generic_01 for verifying sequential IO order")
Cc: stable@vger.kernel.org # v6.15+
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Mahmoud Nagy Adam <mngyadam@amazon.de>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260909132602.68852-2-mngyadam@amazon.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ublk/Makefile |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/ublk/Makefile
+++ b/tools/testing/selftests/ublk/Makefile
@@ -69,6 +69,8 @@ TEST_PROGS += test_stress_08.sh
 TEST_PROGS += test_stress_09.sh
 
 TEST_FILES := settings
+TEST_FILES += test_common.sh
+TEST_FILES += trace
 
 TEST_GEN_PROGS_EXTENDED = kublk metadata_size
 STANDALONE_UTILS := metadata_size.c


