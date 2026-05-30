Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA21B87C0;
	Sat, 30 May 2026 18:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166442; cv=none; b=j54ygGb3HBvig49wyUaXwyDWlydWNFr6w9jB3sFxMrqkY7GccHB/IRiX6TXNgIRxJv5NMtXZG06EWI0Qp8YmyaBVS6u8nP8CnOBnE7Aont4vSS6ja5wwWizC15CYBnrSLn2pzl0SUQ/EejBeXwmKkEcuM4BPY8wXOlgINZylVoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166442; c=relaxed/simple;
	bh=h4PER/U2LvoQvtBLU1WJyuaoEQmDpVto1X4EXmDTR0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWmcPcLoGCbZ40bVeGPZTHGGBrkhspHxFoTL+M+lDfp05V4A4ZvIz5we8Iha+5U3t27C/fVSUdo2iw3mKALGiXdChThWRd4SF4bSNcDZ/MbYCQDc20t2O1kBKoM9jibOeX4zapf9MRsr4+N/7Nc4rx8qt2gp0VsngQzOrBHRgJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rkrnj9sw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rkrnj9sw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8ED1F00893;
	Sat, 30 May 2026 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166441;
	bh=4PQ8Im96SEf3S+UJEOyUR3Cq8B2oSH5bYMGWLfG5RY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rkrnj9swCFJY21kluFBBhmYqpMHMU2STCyp5tKiVutCFgh0af6e/7fG5jWChiikgf
	 qoMln99NhDIHn9sf48e19nd1wmwCydfdENr2JwYh+LDztIjMzSg9xGlKtmZ4w9SIrb
	 Wa2UU41U1BxILK5lvlGoujXxjnOjuQgpmJK5xm/E=
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
Subject: [PATCH 5.10 357/589] ktest: Run POST_KTEST hooks on failure and cancellation
Date: Sat, 30 May 2026 18:03:58 +0200
Message-ID: <20260530160234.235722908@linuxfoundation.org>
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

[ Upstream commit bc6e165a452da909cef0efbc286e6695624db372 ]

PRE_KTEST can be useful for setting up the environment and POST_KTEST to
tear it down, however POST_KTEST only runs on the normal end-of-run path.
It is skipped when ktest exits through dodie() or cancel_test(). Final
cleanup hooks are skipped.

Factor the final hook execution into run_post_ktest(), call it from the
normal exit path and from the early exit paths, and guard it so the hook
runs at most once.

Cc: John Hawley <warthog9@eaglescrag.net>
Cc: Andrea Righi <arighi@nvidia.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Link: https://patch.msgid.link/20260307-ktest-fixes-v1-8-565d412f4925@suse.com
Fixes: 921ed4c7208e ("ktest: Add PRE/POST_KTEST and TEST options")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index a54ad3115dc17..cadeaa54a71be 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -98,6 +98,7 @@ my $test_type;
 my $build_type;
 my $build_options;
 my $final_post_ktest;
+my $post_ktest_done = 0;
 my $pre_ktest;
 my $post_ktest;
 my $pre_test;
@@ -1477,6 +1478,24 @@ sub get_test_name() {
     return $name;
 }
 
+sub run_post_ktest {
+    my $cmd;
+
+    return if ($post_ktest_done);
+
+    if (defined($final_post_ktest)) {
+	$cmd = $final_post_ktest;
+    } elsif (defined($post_ktest)) {
+	$cmd = $post_ktest;
+    } else {
+	return;
+    }
+
+    my $cp_post_ktest = eval_kernel_version($cmd);
+    run_command $cp_post_ktest;
+    $post_ktest_done = 1;
+}
+
 sub dodie {
 
     # avoid recursion
@@ -1538,6 +1557,7 @@ sub dodie {
     if (defined($post_test)) {
 	run_command $post_test;
     }
+    run_post_ktest;
 
     die @_, "\n";
 }
@@ -4313,6 +4333,7 @@ sub cancel_test {
         send_email("KTEST: Your [$name] test was cancelled",
                 "Your test started at $script_start_time was cancelled: sig int");
     }
+    run_post_ktest;
     die "\nCaught Sig Int, test interrupted: $!\n"
 }
 
@@ -4524,11 +4545,7 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
     success $i;
 }
 
-if (defined($final_post_ktest)) {
-
-    my $cp_final_post_ktest = eval_kernel_version $final_post_ktest;
-    run_command $cp_final_post_ktest;
-}
+run_post_ktest;
 
 if ($opt{"POWEROFF_ON_SUCCESS"}) {
     halt;
-- 
2.53.0



