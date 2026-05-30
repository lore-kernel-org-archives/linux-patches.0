Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6D726738C;
	Sat, 30 May 2026 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166406; cv=none; b=XFtR1whSvhkKRcyEiS6bYnX1G1f0MXYVzXxzQ4RERDR22qVQnp/qk0tQEEfbk+CDe//XmINPR7Q+4IPIb2IK2MVyZ5lErHIWKOa49FBVt83ec5uKC1RjxcgCD8HE6rpnC+whG+YOF6P/rUFqKwzLUQkCqy4SF+FO6cmNLTzXNP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166406; c=relaxed/simple;
	bh=mVIgQVWC8zb0r9vxKGZCK1K4/tmTgcojfnVhnkRus+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U55N7vrOy7iKzr76+CcCzrw3Hou643RWBzj7ImUuqj6NSnx7WgtPXx0NJWr6wnJvk7fJC/tJTNAu9mMc/VjIhXb2dQ390el7M3tmIHCtreAdpKxIdkMHsZakeFuO4CbpP0nSSu2rTJ4yL8RslCiKspg0jrQyZdt0ayPKTYIQRv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDXlYSL6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDXlYSL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241941F00893;
	Sat, 30 May 2026 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166404;
	bh=W1L6rF5Plhuuh1ARj+Omc6uee35ew3geLBXvAeF/BoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDXlYSL6UKIjNfwy7AD5OeHJskMYheyKjmH6UfpOvjFn4NmRn1TyeYwzJDZiedsCe
	 WoHpsapmA4nSWgoh7wCwOPEZaY/ik5MrOLDcZVCfX/D0wyvlbVn0vDkys90aT0+GhI
	 ZsbnSiYQHU00TmrLcdXYjZKzma9iig+2lo1e0I6g=
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
Subject: [PATCH 5.10 356/589] ktest: Honor empty per-test option overrides
Date: Sat, 30 May 2026 18:03:57 +0200
Message-ID: <20260530160234.212317627@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a5c1871d3c8e7..a54ad3115dc17 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4195,7 +4195,8 @@ sub __set_test_option {
 
     my $option = "$name\[$i\]";
 
-    if (option_defined($option)) {
+    if (exists($opt{$option})) {
+	return undef if (!option_defined($option));
 	return $opt{$option};
     }
 
@@ -4203,7 +4204,8 @@ sub __set_test_option {
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



