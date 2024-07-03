Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3B5186E31;
	Wed,  3 Jul 2024 10:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004336; cv=none; b=OFGiE4SD9kABOlX/1r6P6M7doeykyPRZG8BeBdM1NGWmKRfn+LbpMDmgGstquS9kzoV0cLiiZQhbAiP0DHAq0ISv/irkQjY5ybgYcHadTgLpMAg+muPu/3eV6Msf4BWO7UaasqA6g69jwFGwuOs/EOSbTjN0XSEcdFAM792NAcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004336; c=relaxed/simple;
	bh=q/a4CFtlv1dVdtH/gxVv37WBxuLdsqbA1k9HQ85pgmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU3IaQN2DfWMt12JawGBFv/gO1btVD36iCjm6ZmfiCCtpX36vPgqPAewx2mqiT9KeyPQ9eJvNzIHfkKjMfS7q8NbAS8UixW5iqUULcBcE2/YDr2U9hQYD8nSTnSQDahUP7LDE7wKsmr1stxsnt8iQZpgbMhR0m5yp9nRuwSeoUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3JcZVQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3JcZVQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0233FC2BD10;
	Wed,  3 Jul 2024 10:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004336;
	bh=q/a4CFtlv1dVdtH/gxVv37WBxuLdsqbA1k9HQ85pgmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3JcZVQCbq/mPvrSMrheutVNcukaMITgwcb1hFURzknFj4qQ+OW+nTZOO0rkWs6av
	 U9rErObmsyYsmBwkoHKvMAOwDeRL8BjKz7ouN0oPKej71APS1j08BjbrPNTrQXLAL3
	 6fFbTTWmhBCdWClTuIgBmacNOdeO0HJUQWrh1SuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 001/290] tracing/selftests: Fix kprobe event name test for .isra. functions
Date: Wed,  3 Jul 2024 12:36:22 +0200
Message-ID: <20240703102904.230012779@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit 23a4b108accc29a6125ed14de4a044689ffeda78 upstream.

The kprobe_eventname.tc test checks if a function with .isra. can have a
kprobe attached to it. It loops through the kallsyms file for all the
functions that have the .isra. name, and checks if it exists in the
available_filter_functions file, and if it does, it uses it to attach a
kprobe to it.

The issue is that kprobes can not attach to functions that are listed more
than once in available_filter_functions. With the latest kernel, the
function that is found is: rapl_event_update.isra.0

  # grep rapl_event_update.isra.0 /sys/kernel/tracing/available_filter_functions
  rapl_event_update.isra.0
  rapl_event_update.isra.0

It is listed twice. This causes the attached kprobe to it to fail which in
turn fails the test. Instead of just picking the function function that is
found in available_filter_functions, pick the first one that is listed
only once in available_filter_functions.

Cc: stable@vger.kernel.org
Fixes: 604e3548236d ("selftests/ftrace: Select an existing function in kprobe_eventname test")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_eventname.tc
@@ -30,7 +30,8 @@ find_dot_func() {
 	fi
 
 	grep " [tT] .*\.isra\..*" /proc/kallsyms | cut -f 3 -d " " | while read f; do
-		if grep -s $f available_filter_functions; then
+		cnt=`grep -s $f available_filter_functions | wc -l`;
+		if [ $cnt -eq 1 ]; then
 			echo $f
 			break
 		fi


