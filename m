Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FCA277808;
	Tue, 27 May 2025 17:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366780; cv=none; b=a7RS7RU57N0jIxHw9UO1CbzUNxgsGtBqUAuJKvVsL8/fWV0iyutMi64P1nOq1/KhcTFuhdOJ/Glc02mMY3fAg+oPDCbJ/QR0KxIyxVfgiQgphnCteuQsCCBjijYK273EtGB21WvtKlvPhmK+VSWJhK3/ye+BbzreKnwKWSRvnfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366780; c=relaxed/simple;
	bh=uAfYUxnLFu2yjP6WZ7HjAUUJg6Jm8HuOnFvtUNPV0i4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lED+ZqRRDlIX/yIHmNYj4fy0hwjFHM0dL3yYUzPX03cc0M2xaA2k08dANv0Zxd3mrKM/RV49VQtKeI8zeJQdnRVhdYWQH9puGwWj529cjMkEFMR9aeXy/J/ANp4oKX4PkFzaoYaOgXYT2kl32EcCW6mIDFNAcWK4/ASZHeiHNQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPTJr9BA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPTJr9BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40690C4CEE9;
	Tue, 27 May 2025 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366780;
	bh=uAfYUxnLFu2yjP6WZ7HjAUUJg6Jm8HuOnFvtUNPV0i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPTJr9BA5Qn8n0g9M9tYxxsjKShCJjnb4mXqYyhVzhk/iOobnJr0Ykg/P2l/9uVom
	 Ig4ORFEFWN/fGAqOj1keQoDjOsBsyZYNhgA0oHoYf2T+FbwVemq9WTBuRwrpWX26sX
	 pz5TOp7OeqzQdht80/UPyl7a+pAbJN0eR27LlNwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 175/783] kunit: tool: Fix bug in parsing test plan
Date: Tue, 27 May 2025 18:19:32 +0200
Message-ID: <20250527162520.288742830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rae Moar <rmoar@google.com>

[ Upstream commit 1d4c06d51963f89f67c7b75d5c0c34e9d1bb2ae6 ]

A bug was identified where the KTAP below caused an infinite loop:

 TAP version 13
 ok 4 test_case
 1..4

The infinite loop was caused by the parser not parsing a test plan
if following a test result line.

Fix this bug by parsing test plan line to avoid the infinite loop.

Link: https://lore.kernel.org/r/20250313192714.1380005-1-rmoar@google.com
Signed-off-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <shuah@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 29fc27e8949bd..da53a709773a2 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -759,7 +759,7 @@ def parse_test(lines: LineStream, expected_num: int, log: List[str], is_subtest:
 		# If parsing the main/top-level test, parse KTAP version line and
 		# test plan
 		test.name = "main"
-		ktap_line = parse_ktap_header(lines, test, printer)
+		parse_ktap_header(lines, test, printer)
 		test.log.extend(parse_diagnostic(lines))
 		parse_test_plan(lines, test)
 		parent_test = True
@@ -768,13 +768,12 @@ def parse_test(lines: LineStream, expected_num: int, log: List[str], is_subtest:
 		# the KTAP version line and/or subtest header line
 		ktap_line = parse_ktap_header(lines, test, printer)
 		subtest_line = parse_test_header(lines, test)
+		test.log.extend(parse_diagnostic(lines))
+		parse_test_plan(lines, test)
 		parent_test = (ktap_line or subtest_line)
 		if parent_test:
-			# If KTAP version line and/or subtest header is found, attempt
-			# to parse test plan and print test header
-			test.log.extend(parse_diagnostic(lines))
-			parse_test_plan(lines, test)
 			print_test_header(test, printer)
+
 	expected_count = test.expected_count
 	subtests = []
 	test_num = 1
-- 
2.39.5



