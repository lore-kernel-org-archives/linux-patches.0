Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526601BC5B;
	Sat,  3 Feb 2024 04:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933493; cv=none; b=sIEhDhXyLLRivxwU0j8xF5ZWM2CcB4ESV6mF9BcbsnfdFwxDP7Q9uOtFUpVQEHXUzsP4Yqk2xerrGmTZUXZeHKH6WH71Jus8sYTQvq7v1K39yLPG8IImbVxNl4dxuZ19zvQcG2pIJhUxFKzWXG/67km2SpPe25hyhFEF5bkwih4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933493; c=relaxed/simple;
	bh=Fav4MeK3fFiX6Qe9NWAYDFWUGloQS1ckA/gEhDzVtws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8p+0nIwPVXNgwSjHfz0bTXFPfhD0iWZYSzNiHILAFZGeFv6U5kl8hup66JVaCFuuG0N9pNd1UhFwqA4tOTexJLicaVl1YnYULQZT7sT1upwa/CLiQufUkLpIQYEKM5QTGqGvuOPJqLpl94RVH/ueD+fINliA68ABUuVzaAK6/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJWpCMbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJWpCMbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD83C433F1;
	Sat,  3 Feb 2024 04:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933493;
	bh=Fav4MeK3fFiX6Qe9NWAYDFWUGloQS1ckA/gEhDzVtws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJWpCMbfmKa1qsV3ZZasvt3TF1YASuFHmJiHVq1ghLIeElLbwQScvdfl1YWWy/hZ9
	 aJnwcMa/j6MCYtd3XctLT2q0A+ghHyDHOp86dGeWK0gYpkHZ7ZiQGv7qvbGqDZASoJ
	 DM4o747HUGXegJV3xPAyaTp9UnEuPF24Zs01A2AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rae Moar <rmoar@google.com>,
	David Gow <davidgow@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/322] kunit: tool: fix parsing of test attributes
Date: Fri,  2 Feb 2024 20:01:59 -0800
Message-ID: <20240203035359.764739639@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Rae Moar <rmoar@google.com>

[ Upstream commit 8ae27bc7fff4ef467a7964821a6cedb34a05d3b2 ]

Add parsing of attributes as diagnostic data. Fixes issue with test plan
being parsed incorrectly as diagnostic data when located after
suite-level attributes.

Note that if there does not exist a test plan line, the diagnostic lines
between the suite header and the first result will be saved in the suite
log rather than the first test case log.

Signed-off-by: Rae Moar <rmoar@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/kunit/kunit_parser.py | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/kunit/kunit_parser.py b/tools/testing/kunit/kunit_parser.py
index 79d8832c862a..ce34be15c929 100644
--- a/tools/testing/kunit/kunit_parser.py
+++ b/tools/testing/kunit/kunit_parser.py
@@ -450,7 +450,7 @@ def parse_diagnostic(lines: LineStream) -> List[str]:
 	Log of diagnostic lines
 	"""
 	log = []  # type: List[str]
-	non_diagnostic_lines = [TEST_RESULT, TEST_HEADER, KTAP_START, TAP_START]
+	non_diagnostic_lines = [TEST_RESULT, TEST_HEADER, KTAP_START, TAP_START, TEST_PLAN]
 	while lines and not any(re.match(lines.peek())
 			for re in non_diagnostic_lines):
 		log.append(lines.pop())
@@ -726,6 +726,7 @@ def parse_test(lines: LineStream, expected_num: int, log: List[str], is_subtest:
 		# test plan
 		test.name = "main"
 		ktap_line = parse_ktap_header(lines, test)
+		test.log.extend(parse_diagnostic(lines))
 		parse_test_plan(lines, test)
 		parent_test = True
 	else:
@@ -737,6 +738,7 @@ def parse_test(lines: LineStream, expected_num: int, log: List[str], is_subtest:
 		if parent_test:
 			# If KTAP version line and/or subtest header is found, attempt
 			# to parse test plan and print test header
+			test.log.extend(parse_diagnostic(lines))
 			parse_test_plan(lines, test)
 			print_test_header(test)
 	expected_count = test.expected_count
-- 
2.43.0



