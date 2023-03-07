Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA94BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B20C433EF;
	Tue,  7 Mar 2023 17:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211699;
	bh=poKDQ1Ll1fYF1E3NJ66RWLYdWhMJz9GW8Ms+/3MrkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFK6tCoKWmlEQga+IO3TShOzcqNDwY82Mux18J9Hpr+/PjFZvsIV0+bb1Fhak5vki
	 DZ7OdkVJrwaOI4s5TT8khCS2QrV+YHZqhAQf6gzS3rCLyJuVX3WOl6Pbkuc3TuEky7
	 5+sennY7B3qPOAt6lvVQuqDOGC7wquEm4/jfoPBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.2 0947/1001] ktest.pl: Give back console on Ctrt^C on monitor
Date: Tue,  7 Mar 2023 18:01:59 +0100
Message-Id: <20230307170103.229983058@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
@@ -4200,6 +4200,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
 	send_email("KTEST: Your [$name] test was cancelled",


