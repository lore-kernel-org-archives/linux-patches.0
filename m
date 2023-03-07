Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0306CBA52
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79128C433EF;
	Tue,  7 Mar 2023 19:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216284;
	bh=tq0xN++537YpytXOlsaff1G3Q1pz2bnuBKNcMw/s6DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+tyrpcoGm1ECsuP7L0Q20F6OIpphFBArAblPbZ/RHqGRDxmoMp1iwg6K4XbeEkcg
	 2c7PK3eP3NHY9zdKbIMKvScrE/InT5ndebaGcIUmmiLx9EgfiB6RINQzLOoXxatswv
	 PucNotxYC/i6pw+kUGJlE6/7trxZpn7xd/rai19s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 533/567] ktest.pl: Give back console on Ctrt^C on monitor
Date: Tue,  7 Mar 2023 18:04:29 +0100
Message-Id: <20230307165929.052295506@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt <rostedt@goodmis.org>

commit 83d29d439cd3ef23041570d55841f814af2ecac0 upstream.

When monitoring the console output, the stdout is being redirected to do
so. If Ctrl^C is hit during this mode, the stdout is not back to the
console, the user does not see anything they type (no echo).

Add "end_monitor" to the SIGINT interrupt handler to give back the console
on Ctrl^C.

Cc: stable@vger.kernel.org
Fixes: 9f2cdcbbb90e7 ("ktest: Give console process a dedicated tty")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -4193,6 +4193,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
 	send_email("KTEST: Your [$name] test was cancelled",


