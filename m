Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11431847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74645C4339B;
	Fri, 10 Mar 2023 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456357;
	bh=QhGzyI9wFajVQAMGKxlELRNxfF58F5nlciXptS6+jUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apXNg7bqYKg5IUuF2DJqvKbh/dMYzQ2mLALkRfvejY26eHUYH3EcXMYAWkJ/N9v9G
	 JUNd0lUU1WcwdXwdBUcHllOWwoTI6j/DWvuuPjITx4XA1EkMFRBk7QX3aH8qkupmL9
	 DUgYlf8DfcPH/SfYXRGyf9ULAg0QRiqPgWZSb3hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4.14 138/193] ktest.pl: Fix missing "end_monitor" when machine check fails
Date: Fri, 10 Mar 2023 14:38:40 +0100
Message-Id: <20230310133715.818627757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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

commit e8bf9b98d40dbdf4e39362e3b85a70c61da68cb7 upstream.

In the "reboot" command, it does a check of the machine to see if it is
still alive with a simple "ssh echo" command. If it fails, it will assume
that a normal "ssh reboot" is not possible and force a power cycle.

In this case, the "start_monitor" is executed, but the "end_monitor" is
not, and this causes the screen will not be given back to the console. That
is, after the test, a "reset" command needs to be performed, as "echo" is
turned off.

Cc: stable@vger.kernel.org
Fixes: 6474ace999edd ("ktest.pl: Powercycle the box on reboot if no connection can be made")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1384,7 +1384,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }


