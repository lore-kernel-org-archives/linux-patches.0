Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16689371CEA;
	Wed, 20 May 2026 18:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302302; cv=none; b=CTcaqFq4p/o+FHiBU/PhSFqF1CuHvKg54eswZrpQzu/9gumbiiMIiu7KplH2ymGNbJRBWHnKxZHe9xc7rnc1B7vdwxET03gRxJaoEkrlsb/geq7clzqdsc1rdR9IGBwY6rjaYsWmst/wHGDdCjsFSF7uHo98ah/H9iHSZulKRto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302302; c=relaxed/simple;
	bh=BNXH+elWxFBEOMLrusUykcbQlyy4mbFjY1yG8KLSyjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lH7O07Pwv2sfr1cmoI4Wn3l8uXuQWeYr+8WI7JEUjgiNsav394uLfBMENx4IdLsh0xt3sw6Tx8KqQaqLnfW/eLspiKXYCvs+qpo2RTOyYoJxQyXWQm0Q07jyPa3l5o/bQWsJ3ZaJxoF83b5SH/kKqLFwNYsXaOQrQidJRaIQuG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxK4Z4uc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxK4Z4uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836E61F000E9;
	Wed, 20 May 2026 18:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302301;
	bh=HZ108OrMHe2C8RT2E0R+0dyc0mw2tbBqxZAGZk+Ev/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxK4Z4ucjji/PZTAcH7QwnmRq+1bJyKB/6ijljQPr4Hk166OGQmI46reiUQKAVNHH
	 AVvCojXJJUpeIqk6vum672WivlWcUaL5rk6M5KGdSjBvYV9ta1ujSZFQ/BBO82o7dF
	 RZlPHHuBW3QKQeXQNAkk/A91CxEnmv4coudkZ300=
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
Subject: [PATCH 6.6 174/508] ktest: Honor empty per-test option overrides
Date: Wed, 20 May 2026 18:19:57 +0200
Message-ID: <20260520162102.409204748@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4eca66310d9b4..13686e7629c4d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4113,7 +4113,8 @@ sub __set_test_option {
 
     my $option = "$name\[$i\]";
 
-    if (option_defined($option)) {
+    if (exists($opt{$option})) {
+	return undef if (!option_defined($option));
 	return $opt{$option};
     }
 
@@ -4121,7 +4122,8 @@ sub __set_test_option {
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



