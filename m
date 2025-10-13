Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547E3112A4;
	Mon, 13 Oct 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369038; cv=none; b=tcOwQ/ybBx1Hk9mhJ6lzeWhRE5YoImCUww9Lrk+B+oDVb0oukFh7WcYeSHk45uhksikvRhsb95FRaUII7U37licAE2x97mlT9Gg2hFK5VV5l9daqha2EvNIwSSj/OlGE2g0w0nbggi89LQ7OAXIJuSnlSBO3sikIwgUwNhc8ZVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369038; c=relaxed/simple;
	bh=4jPOj1TvQUMgq0l1u1qmq8c7gl6I0bYfkbGg7dfurCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=up43x53Moe+yoYRvrTDZAeNBjfBzw3xzdMReefDzOLEWdlsm3BSHk68i7GNFtp7dTFRkwlMmd/R5+VbF/EzTocpYIXnMFUqrVSp95miljrw1U4ETZQgZJZA+A/kz2EHjRLLg/c/JrQRKjMVD8u6LUR+DbUr+L6r/TpwI9FMm/go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4NzAXBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4NzAXBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183CDC116B1;
	Mon, 13 Oct 2025 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369038;
	bh=4jPOj1TvQUMgq0l1u1qmq8c7gl6I0bYfkbGg7dfurCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4NzAXBsH6nSfkhMzKZC4SuxCzF1H0MvU65xW9qPQT7S5pUCoVUWcpLEuQf7xx5wZ
	 RfwtjzUN2FSqkJvEk2giB74STosMf8bxFLxVZH5AWmVXIR70TyiIfO73c/JaykhbMH
	 TUK7vTCbCXR2x5NSfjiHZc+EDz+AR5tRcvons8IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 107/563] selftests: vDSO: vdso_test_abi: Correctly skip whole test with missing vDSO
Date: Mon, 13 Oct 2025 16:39:28 +0200
Message-ID: <20251013144415.170783698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 4b59a9f7628fd82b24f2148f62cf327a84d26555 ]

If AT_SYSINFO_EHDR is missing the whole test needs to be skipped.
Currently this results in the following output:

	TAP version 13
	1..16
	# AT_SYSINFO_EHDR is not present!

This output is incorrect, as "1..16" still requires the subtest lines to
be printed, which isn't done however.

Switch to the correct skipping functions, so the output now correctly
indicates that no subtests are being run:

	TAP version 13
	1..0 # SKIP AT_SYSINFO_EHDR is not present!

Fixes: 693f5ca08ca0 ("kselftest: Extend vDSO selftest")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250812-vdso-tests-fixes-v2-2-90f499dd35f8@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_test_abi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_test_abi.c b/tools/testing/selftests/vDSO/vdso_test_abi.c
index a54424e2336f4..67cbfc56e4e1b 100644
--- a/tools/testing/selftests/vDSO/vdso_test_abi.c
+++ b/tools/testing/selftests/vDSO/vdso_test_abi.c
@@ -182,12 +182,11 @@ int main(int argc, char **argv)
 	unsigned long sysinfo_ehdr = getauxval(AT_SYSINFO_EHDR);
 
 	ksft_print_header();
-	ksft_set_plan(VDSO_TEST_PLAN);
 
-	if (!sysinfo_ehdr) {
-		ksft_print_msg("AT_SYSINFO_EHDR is not present!\n");
-		return KSFT_SKIP;
-	}
+	if (!sysinfo_ehdr)
+		ksft_exit_skip("AT_SYSINFO_EHDR is not present!\n");
+
+	ksft_set_plan(VDSO_TEST_PLAN);
 
 	version = versions[VDSO_VERSION];
 	name = (const char **)&names[VDSO_NAMES];
-- 
2.51.0



