Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2256D30C608;
	Mon, 13 Oct 2025 15:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368122; cv=none; b=OFkzyqhkU7+zEwtgCa1Hb1YFSCEI3D0chmZD1Gxh6l1yvmFYeclaGdPdQ3BaEcifUVkjcy26D0DdLcNQuXFxJyzJWEDwYCpqxCo5FgWP6F+A6aEllr/enlQkohXo3HbPzigL6zqUrKL6h66frL40Aq5ZOyiUYu0TCdl2Z0PiPI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368122; c=relaxed/simple;
	bh=6jZvPQxLp5OKhTphoNXMqvHT6Tj87R0kVPZJlUa7WVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spctYSIpUs4L9K/yTpjHNlsxq0VyGW5X1pamjySHrLwfCX2qsYbSHfm/m3/hmyUVaj2/P/7HWj4aipRA4FRKQ/k/bbJ/QbnZPS5VlEapx4qCcu7UI8X4/CqmY/TR2t49ZQo0w4EZDL2hOPPlhzXoRI5l0lINzD5Gw6YKG8RP0rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HDBIEXa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDBIEXa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFAAC4CEE7;
	Mon, 13 Oct 2025 15:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368121;
	bh=6jZvPQxLp5OKhTphoNXMqvHT6Tj87R0kVPZJlUa7WVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDBIEXa9O37zLdOqX4P4Yr1y1kF/X/F+BwQ1oF3gr66yoqgZxdgXZyKFmIJWqEd9O
	 JnnH7/mGqgtX2sFhbiCjHIr7RqgBT/Eqow41InW6bQ+ABmmOUJo0ZGezD0fSWujBwX
	 YqMGGUM5Lu3LILfrYsNtDvQyDQhn0JM+SQeRcukU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/262] selftests: vDSO: vdso_test_abi: Correctly skip whole test with missing vDSO
Date: Mon, 13 Oct 2025 16:43:13 +0200
Message-ID: <20251013144327.967008913@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



