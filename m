Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734739443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672B6C433B6;
	Sun, 13 Aug 2023 21:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961836;
	bh=ov/3zRzxfELGr/vF7C1FtfHn8OqGoMxxGePjtFzJtzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2KxW8JKIFX0vU7UcJ+HzQBeO6KIAa+moAiU/ZxEn46OQsjBfbqXC7g+RxNJ+Li8B
	 JqLOYHmtGnduMBZQV90KSWhzyD7PQdx0Ics4rnjkcSvrrhadHCMxorCHhnKZ3w+Y8u
	 qujjbDUkP+yz/n6qQsWrOPRh/uM28f/TGFtkEuxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Claudi <aclaudi@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 017/206] selftests: mptcp: join: fix implicit EP test
Date: Sun, 13 Aug 2023 23:16:27 +0200
Message-ID: <20230813211725.467839534@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Claudi <aclaudi@redhat.com>

commit c8c101ae390a3e817369e94a6f12a1ddea420702 upstream.

mptcp_join 'implicit EP' test currently fails when using ip mptcp:

  $ ./mptcp_join.sh -iI
  <snip>
  001 implicit EP    creation[fail] expected '10.0.2.2 10.0.2.2 id 1 implicit' found '10.0.2.2 id 1 rawflags 10 '
  Error: too many addresses or duplicate one: -22.
                     ID change is prevented[fail] expected '10.0.2.2 10.0.2.2 id 1 implicit' found '10.0.2.2 id 1 rawflags 10 '
                     modif is allowed[fail] expected '10.0.2.2 10.0.2.2 id 1 signal' found '10.0.2.2 id 1 signal '

This happens because of two reasons:
- iproute v6.3.0 does not support the implicit flag, fixed with
  iproute2-next commit 3a2535a41854 ("mptcp: add support for implicit
  flag")
- pm_nl_check_endpoint wrongly expects the ip address to be repeated two
  times in iproute output, and does not account for a final whitespace
  in it.

This fixes the issue trimming the whitespace in the output string and
removing the double address in the expected string.

Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/20230803-upstream-net-20230803-misc-fixes-6-5-v1-2-6671b1ab11cc@tessares.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -767,10 +767,11 @@ pm_nl_check_endpoint()
 	fi
 
 	if [ $ip_mptcp -eq 1 ]; then
+		# get line and trim trailing whitespace
 		line=$(ip -n $ns mptcp endpoint show $id)
+		line="${line% }"
 		# the dump order is: address id flags port dev
-		expected_line="$addr"
-		[ -n "$addr" ] && expected_line="$expected_line $addr"
+		[ -n "$addr" ] && expected_line="$addr"
 		expected_line="$expected_line $id"
 		[ -n "$_flags" ] && expected_line="$expected_line ${_flags//","/" "}"
 		[ -n "$dev" ] && expected_line="$expected_line $dev"


