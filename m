Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E966C134DC
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC55C433C0;
	Mon, 26 Jun 2023 18:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804074;
	bh=U5lT5QxVboM+xA1QUoWhSuD7Z+o4phKWyxAEud5AwYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhAOGherHsYmFMx2ncOc7+tLb+/4z21U5NVhzX5L2OzwtLqAfVN8HQbPL8mnz2OwG
	 SbFHBTROZtXrQb3lX69iTkKqUqVC1t+Xw9ihHjo6ytFB9xvgDwLX3634rdfHByDNRb
	 qasMzyQs7XSQXuLRWW0qjNFcoVFEK5h0zYFha4Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 033/170] selftests: mptcp: join: skip backup if set flag on ID not supported
Date: Mon, 26 Jun 2023 20:10:02 +0200
Message-ID: <20230626180802.035210620@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 07216a3c5d926bf1b6b360a0073747228a1f9b7f upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

Commit bccefb762439 ("selftests: mptcp: simplify pm_nl_change_endpoint")
has simplified the way the backup flag is set on an endpoint. Instead of
doing:

  ./pm_nl_ctl set 10.0.2.1 flags backup

Now we do:

  ./pm_nl_ctl set id 1 flags backup

The new way is easier to maintain but it is also incompatible with older
kernels not supporting the implicit endpoints putting in place the
infrastructure to set flags per ID, hence the second Fixes tag.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: bccefb762439 ("selftests: mptcp: simplify pm_nl_change_endpoint")
Cc: stable@vger.kernel.org
Fixes: 4cf86ae84c71 ("mptcp: strict local address ID selection")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2573,7 +2573,8 @@ v4mapped_tests()
 backup_tests()
 {
 	# single subflow, backup
-	if reset "single subflow, backup"; then
+	if reset "single subflow, backup" &&
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
 		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
@@ -2583,7 +2584,8 @@ backup_tests()
 	fi
 
 	# single address, backup
-	if reset "single address, backup"; then
+	if reset "single address, backup" &&
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
 		pm_nl_set_limits $ns2 1 1
@@ -2594,7 +2596,8 @@ backup_tests()
 	fi
 
 	# single address with port, backup
-	if reset "single address with port, backup"; then
+	if reset "single address with port, backup" &&
+	   continue_if mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal port 10100
 		pm_nl_set_limits $ns2 1 1


