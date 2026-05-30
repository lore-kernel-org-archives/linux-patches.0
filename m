Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A47355F53;
	Sat, 30 May 2026 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164186; cv=none; b=Oep9OSutGyTLrRMQEDSXwcB7RsBUbeJ5u2iinskqJ/rZOfDe+YNtkjqa7sSgihRSLMDqit6zxGIlyltFoB+cwm6t/3SvoX8JVs1TLkDRdWm7SBiGlrGl8pQbDAdPWxCrhqxM+uSt5+CYU26MPSFFDsSpvY5q7CzasFEv7qbUufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164186; c=relaxed/simple;
	bh=rkjFYqrKSPlq98SMbYAl83sMzurt4LWgWY38xHMKAuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKebzOvBRsvfZ/b/dAl7VDdVWtO5ZvEUECIxD3s8cJH1GCEjlYlN55patWX4tDAHz0PErCRWF/9OBcaGvRO9+rq+5TSNiJqkpZfX4pF8vVvz90VedZW7xXApBc2EIj4FTtQYHqGBQSmInJR5irlTsHR372x7o/5cEj31zxkuU0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ow31CMY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ow31CMY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD111F00893;
	Sat, 30 May 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164185;
	bh=0efNi06mULXjjZrO5B/6TCGS+If23i+VHLjvfcUbmfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ow31CMY9SXaYXuo3Erv/+RQXl8qIXoeTdEw7h8zLjOia4qf2usdo2fbSHOeDBFehp
	 oWiQQ8MGgaWlQqskN+plaU5OoDGrsLVKugaQNiEayrJuC1y1mdtwQcIKLXVZF3LUP5
	 t2Q/nHX0yQZZdvBcAxGtu8vwIDl+kksDwOOk+ixg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	Andrea Righi <arighi@nvidia.com>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pedro Falcato <pfalcato@suse.de>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/776] ktest: Honor empty per-test option overrides
Date: Sat, 30 May 2026 18:03:13 +0200
Message-ID: <20260530160252.718701432@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit a2de57a3c8192dcd67cccaff6c341b93748d799b ]

A per-test override can clear an inherited default option by assigning an
empty value, but __set_test_option() still used option_defined() to decide
whether a per-test key existed. That turned an empty per-test assignment
back into "fall back to the default", so tests still could not clear
inherited settings.

For example:

  DEFAULTS
  (...)
  LOG_FILE = /tmp/ktest-empty-override.log
  CLEAR_LOG = 1
  ADD_CONFIG = /tmp/.config

  TEST_START
  TEST_TYPE = build
  BUILD_TYPE = nobuild
  ADD_CONFIG =

This would run the test with ADD_CONFIG[1] = /tmp/.config

Fix by checking whether the per-test key exists before falling back. If it
does exist but is empty, treat it as unset for that test and stop the
fallback chain there.

Cc: John Hawley <warthog9@eaglescrag.net>
Cc: Andrea Righi <arighi@nvidia.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Link: https://patch.msgid.link/20260307-ktest-fixes-v1-4-565d412f4925@suse.com
Fixes: 22c37a9ac49d ("ktest: Allow tests to undefine default options")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index d752c4bd0d8b3..28eebfa32621d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4106,7 +4106,8 @@ sub __set_test_option {
 
     my $option = "$name\[$i\]";
 
-    if (option_defined($option)) {
+    if (exists($opt{$option})) {
+	return undef if (!option_defined($option));
 	return $opt{$option};
     }
 
@@ -4114,7 +4115,8 @@ sub __set_test_option {
 	if ($i >= $test &&
 	    $i < $test + $repeat_tests{$test}) {
 	    $option = "$name\[$test\]";
-	    if (option_defined($option)) {
+	    if (exists($opt{$option})) {
+		return undef if (!option_defined($option));
 		return $opt{$option};
 	    }
 	}
-- 
2.53.0



