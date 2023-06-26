Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70028134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED0CC433C0;
	Mon, 26 Jun 2023 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803404;
	bh=nDfkg22AH0J5XTy6BeNRipvLJqoKFi2x+u/KqqB3Ilc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThrUPtsfDkRi1lkuifVDBk/nIaTb+BnjFI/jAeknk9DM1SYL+qZLFw5u3KNPTDmBU
	 SfqICADHhj99H/6zJMeTQXRaib2OV3jykzapCJhJXfcumNMiF/2bvns3KuZiLKIkWr
	 jh55hGfkWHMv6UbDppKLC1GrsPD7ygM1B5905RR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 049/199] selftests: mptcp: join: uniform listener tests
Date: Mon, 26 Jun 2023 20:09:15 +0200
Message-ID: <20230626180807.721957971@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit 96b84195df61d374d8028cf426a115ae085031ec upstream.

The alignment was different from the other tests because tabs were used
instead of spaces.

While at it, also use 'echo' instead of 'printf' to print the result to
keep the same style as done in the other sub-tests. And, even if it
should be better with, also remove 'stdbuf' and sed's '--unbuffered'
option because they are not used in the other subtests and they are not
available when using a minimal environment with busybox.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 178d023208eb ("selftests: mptcp: listener test for in-kernel PM")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   30 +++++++++++-------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2725,43 +2725,41 @@ verify_listener_events()
 	local family
 	local saddr
 	local sport
+	local name
 
 	if [ $e_type = $LISTENER_CREATED ]; then
-		stdbuf -o0 -e0 printf "\t\t\t\t\t CREATE_LISTENER %s:%s"\
-			$e_saddr $e_sport
+		name="LISTENER_CREATED"
 	elif [ $e_type = $LISTENER_CLOSED ]; then
-		stdbuf -o0 -e0 printf "\t\t\t\t\t CLOSE_LISTENER %s:%s "\
-			$e_saddr $e_sport
+		name="LISTENER_CLOSED"
+	else
+		name="$e_type"
 	fi
 
+	printf "%-${nr_blank}s %s %s:%s " " " "$name" "$e_saddr" "$e_sport"
+
 	if ! mptcp_lib_kallsyms_has "mptcp_event_pm_listener$"; then
 		printf "[skip]: event not supported\n"
 		return
 	fi
 
-	type=$(grep "type:$e_type," $evt |
-	       sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q')
-	family=$(grep "type:$e_type," $evt |
-		 sed --unbuffered -n 's/.*\(family:\)\([[:digit:]]*\).*$/\2/p;q')
-	sport=$(grep "type:$e_type," $evt |
-		sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+	type=$(grep "type:$e_type," $evt | sed -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q')
+	family=$(grep "type:$e_type," $evt | sed -n 's/.*\(family:\)\([[:digit:]]*\).*$/\2/p;q')
+	sport=$(grep "type:$e_type," $evt | sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
 	if [ $family ] && [ $family = $AF_INET6 ]; then
-		saddr=$(grep "type:$e_type," $evt |
-			sed --unbuffered -n 's/.*\(saddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+		saddr=$(grep "type:$e_type," $evt | sed -n 's/.*\(saddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
 	else
-		saddr=$(grep "type:$e_type," $evt |
-			sed --unbuffered -n 's/.*\(saddr4:\)\([0-9.]*\).*$/\2/p;q')
+		saddr=$(grep "type:$e_type," $evt | sed -n 's/.*\(saddr4:\)\([0-9.]*\).*$/\2/p;q')
 	fi
 
 	if [ $type ] && [ $type = $e_type ] &&
 	   [ $family ] && [ $family = $e_family ] &&
 	   [ $saddr ] && [ $saddr = $e_saddr ] &&
 	   [ $sport ] && [ $sport = $e_sport ]; then
-		stdbuf -o0 -e0 printf "[ ok ]\n"
+		echo "[ ok ]"
 		return 0
 	fi
 	fail_test
-	stdbuf -o0 -e0 printf "[fail]\n"
+	echo "[fail]"
 }
 
 add_addr_ports_tests()


