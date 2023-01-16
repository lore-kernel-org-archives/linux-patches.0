Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B46FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67575C433EF;
	Mon, 16 Jan 2023 16:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888042;
	bh=7ljI8XXa+5WY5aATGjgL3h+133pgo1lhOuDbPirtP1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSjhQ1LsKJbTnBOrWyyJx4hrliZrDT0P3lls7YszxFjxVnVNDqumans4egVfkGf4C
	 pvl6Sgmdqn8ezpnZ7sJd1KaB5+Vda1SmSScTmhipCGcWoMYzhH4zyob/N7CiQmJs9f
	 ygP4LsR1zFXWknpG6qkClT/lai+BXWvPaTorSE7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"John Warthog9 Hawley (VMware)" <warthog9@eaglescrag.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 378/521] ktest.pl minconfig: Unset configs instead of just removing them
Date: Mon, 16 Jan 2023 16:50:40 +0100
Message-Id: <20230116154904.015086872@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

commit ef784eebb56425eed6e9b16e7d47e5c00dcf9c38 upstream.

After a full run of a make_min_config test, I noticed there were a lot of
CONFIGs still enabled that really should not be. Looking at them, I
noticed they were all defined as "default y". The issue is that the test
simple removes the config and re-runs make oldconfig, which enables it
again because it is set to default 'y'. Instead, explicitly disable the
config with writing "# CONFIG_FOO is not set" to the file to keep it from
being set again.

With this change, one of my box's minconfigs went from 768 configs set,
down to 521 configs set.

Link: https://lkml.kernel.org/r/20221202115936.016fce23@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: 0a05c769a9de5 ("ktest: Added config_bisect test type")
Reviewed-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/ktest/ktest.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -3706,9 +3706,10 @@ sub test_this_config {
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-    delete $configs{$config};
+    $configs{$config} = "# $config is not set";
     make_new_config ((values %configs), (values %keep_configs));
     make_oldconfig;
+    delete $configs{$config};
     undef %configs;
     assign_configs \%configs, $output_config;
 


