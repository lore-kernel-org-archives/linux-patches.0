Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95944604DD;
	Tue, 13 Feb 2024 17:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845702; cv=none; b=NMItd+S9Pg6JijX1bFOTjjpxp6ynyULJI5C8Ta8YrGLsjfpOxfVs6d70C50F7zJGpDSlly98vqL3LG/FXC9FPBxCjpPCVX+eNKuJaoW9LnypeOtg9VLysvvJfEq6nTC7/ud15mLpZ789ipIJG5sGo63JRD/49FRGSiZWstW7rME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845702; c=relaxed/simple;
	bh=kThvbYePJ2CAk9YeIMIQl/0/165Cqkm+zlN2M9/kSAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpT79eMLDw4W9GZ+TGhpHE0adZl0iR22iSPLc08vQWuyH7BmhEYNLkPT6duUQDDKUdK5gtfAh40M7XKxeXOBusBTRarTtNC9RNPp/QcOsJTORqhjtqRKjZvF79Yt8qqeNfHtflLOFIAHVl9fz8Q9KNjM8RA5N2ZC+S6y4/RNkI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5WpASnV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5WpASnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED01DC433F1;
	Tue, 13 Feb 2024 17:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845702;
	bh=kThvbYePJ2CAk9YeIMIQl/0/165Cqkm+zlN2M9/kSAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5WpASnVwj56r8U9k515Uhb+txdZLWkyoez0LTe3pjMznbAF1MOyleKJKPpawft4B
	 6rLToBrn7uXlm1Fj4y/PDazCOC9EKzJaMHF4vNuFUbuAEdwDQtIm+h3Cw/OLyzEHUN
	 fGxOYlgVq/R6jXhRIl2bWXmvbYUd/JXPU5FC60PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 034/124] selftests/net: convert unicast_extensions.sh to run it in unique namespace
Date: Tue, 13 Feb 2024 18:20:56 +0100
Message-ID: <20240213171854.729279113@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 0f4765d0b48d90ede9788c7edb2e072eee20f88e ]

Here is the test result after conversion.

 # ./unicast_extensions.sh
 /usr/bin/which: no nettest in (/root/.local/bin:/root/bin:/usr/share/Modules/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin)
 ###########################################################################
 Unicast address extensions tests (behavior of reserved IPv4 addresses)
 ###########################################################################
 TEST: assign and ping within 240/4 (1 of 2) (is allowed)            [ OK ]
 TEST: assign and ping within 240/4 (2 of 2) (is allowed)            [ OK ]
 TEST: assign and ping within 0/8 (1 of 2) (is allowed)              [ OK ]

 ...

 TEST: assign and ping class D address (is forbidden)                [ OK ]
 TEST: routing using class D (is forbidden)                          [ OK ]
 TEST: routing using 127/8 (is forbidden)                            [ OK ]

Acked-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: e71e016ad0f6 ("selftests: net: fix tcp listener handling in pmtu.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/unicast_extensions.sh       | 99 +++++++++----------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/testing/selftests/net/unicast_extensions.sh
index 2d10ccac898a..b7a2cb9e7477 100755
--- a/tools/testing/selftests/net/unicast_extensions.sh
+++ b/tools/testing/selftests/net/unicast_extensions.sh
@@ -28,8 +28,7 @@
 # These tests provide an easy way to flip the expected result of any
 # of these behaviors for testing kernel patches that change them.
 
-# Kselftest framework requirement - SKIP code is 4.
-ksft_skip=4
+source ./lib.sh
 
 # nettest can be run from PATH or from same directory as this selftest
 if ! which nettest >/dev/null; then
@@ -61,20 +60,20 @@ _do_segmenttest(){
 	# foo --- bar
 	# Arguments: ip_a ip_b prefix_length test_description
 	#
-	# Caller must set up foo-ns and bar-ns namespaces
+	# Caller must set up $foo_ns and $bar_ns namespaces
 	# containing linked veth devices foo and bar,
 	# respectively.
 
-	ip -n foo-ns address add $1/$3 dev foo || return 1
-	ip -n foo-ns link set foo up || return 1
-	ip -n bar-ns address add $2/$3 dev bar || return 1
-	ip -n bar-ns link set bar up || return 1
+	ip -n $foo_ns address add $1/$3 dev foo || return 1
+	ip -n $foo_ns link set foo up || return 1
+	ip -n $bar_ns address add $2/$3 dev bar || return 1
+	ip -n $bar_ns link set bar up || return 1
 
-	ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
-	ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
+	ip netns exec $foo_ns timeout 2 ping -c 1 $2 || return 1
+	ip netns exec $bar_ns timeout 2 ping -c 1 $1 || return 1
 
-	nettest -B -N bar-ns -O foo-ns -r $1 || return 1
-	nettest -B -N foo-ns -O bar-ns -r $2 || return 1
+	nettest -B -N $bar_ns -O $foo_ns -r $1 || return 1
+	nettest -B -N $foo_ns -O $bar_ns -r $2 || return 1
 
 	return 0
 }
@@ -88,31 +87,31 @@ _do_route_test(){
 	# Arguments: foo_ip foo1_ip bar1_ip bar_ip prefix_len test_description
 	# Displays test result and returns success or failure.
 
-	# Caller must set up foo-ns, bar-ns, and router-ns
+	# Caller must set up $foo_ns, $bar_ns, and $router_ns
 	# containing linked veth devices foo-foo1, bar1-bar
-	# (foo in foo-ns, foo1 and bar1 in router-ns, and
-	# bar in bar-ns).
-
-	ip -n foo-ns address add $1/$5 dev foo || return 1
-	ip -n foo-ns link set foo up || return 1
-	ip -n foo-ns route add default via $2 || return 1
-	ip -n bar-ns address add $4/$5 dev bar || return 1
-	ip -n bar-ns link set bar up || return 1
-	ip -n bar-ns route add default via $3 || return 1
-	ip -n router-ns address add $2/$5 dev foo1 || return 1
-	ip -n router-ns link set foo1 up || return 1
-	ip -n router-ns address add $3/$5 dev bar1 || return 1
-	ip -n router-ns link set bar1 up || return 1
-
-	echo 1 | ip netns exec router-ns tee /proc/sys/net/ipv4/ip_forward
-
-	ip netns exec foo-ns timeout 2 ping -c 1 $2 || return 1
-	ip netns exec foo-ns timeout 2 ping -c 1 $4 || return 1
-	ip netns exec bar-ns timeout 2 ping -c 1 $3 || return 1
-	ip netns exec bar-ns timeout 2 ping -c 1 $1 || return 1
-
-	nettest -B -N bar-ns -O foo-ns -r $1 || return 1
-	nettest -B -N foo-ns -O bar-ns -r $4 || return 1
+	# (foo in $foo_ns, foo1 and bar1 in $router_ns, and
+	# bar in $bar_ns).
+
+	ip -n $foo_ns address add $1/$5 dev foo || return 1
+	ip -n $foo_ns link set foo up || return 1
+	ip -n $foo_ns route add default via $2 || return 1
+	ip -n $bar_ns address add $4/$5 dev bar || return 1
+	ip -n $bar_ns link set bar up || return 1
+	ip -n $bar_ns route add default via $3 || return 1
+	ip -n $router_ns address add $2/$5 dev foo1 || return 1
+	ip -n $router_ns link set foo1 up || return 1
+	ip -n $router_ns address add $3/$5 dev bar1 || return 1
+	ip -n $router_ns link set bar1 up || return 1
+
+	echo 1 | ip netns exec $router_ns tee /proc/sys/net/ipv4/ip_forward
+
+	ip netns exec $foo_ns timeout 2 ping -c 1 $2 || return 1
+	ip netns exec $foo_ns timeout 2 ping -c 1 $4 || return 1
+	ip netns exec $bar_ns timeout 2 ping -c 1 $3 || return 1
+	ip netns exec $bar_ns timeout 2 ping -c 1 $1 || return 1
+
+	nettest -B -N $bar_ns -O $foo_ns -r $1 || return 1
+	nettest -B -N $foo_ns -O $bar_ns -r $4 || return 1
 
 	return 0
 }
@@ -121,17 +120,15 @@ segmenttest(){
 	# Sets up veth link and tries to connect over it.
 	# Arguments: ip_a ip_b prefix_len test_description
 	hide_output
-	ip netns add foo-ns
-	ip netns add bar-ns
-	ip link add foo netns foo-ns type veth peer name bar netns bar-ns
+	setup_ns foo_ns bar_ns
+	ip link add foo netns $foo_ns type veth peer name bar netns $bar_ns
 
 	test_result=0
 	_do_segmenttest "$@" || test_result=1
 
-	ip netns pids foo-ns | xargs -r kill -9
-	ip netns pids bar-ns | xargs -r kill -9
-	ip netns del foo-ns
-	ip netns del bar-ns
+	ip netns pids $foo_ns | xargs -r kill -9
+	ip netns pids $bar_ns | xargs -r kill -9
+	cleanup_ns $foo_ns $bar_ns
 	show_output
 
 	# inverted tests will expect failure instead of success
@@ -147,21 +144,17 @@ route_test(){
 	# Returns success or failure.
 
 	hide_output
-	ip netns add foo-ns
-	ip netns add bar-ns
-	ip netns add router-ns
-	ip link add foo netns foo-ns type veth peer name foo1 netns router-ns
-	ip link add bar netns bar-ns type veth peer name bar1 netns router-ns
+	setup_ns foo_ns bar_ns router_ns
+	ip link add foo netns $foo_ns type veth peer name foo1 netns $router_ns
+	ip link add bar netns $bar_ns type veth peer name bar1 netns $router_ns
 
 	test_result=0
 	_do_route_test "$@" || test_result=1
 
-	ip netns pids foo-ns | xargs -r kill -9
-	ip netns pids bar-ns | xargs -r kill -9
-	ip netns pids router-ns | xargs -r kill -9
-	ip netns del foo-ns
-	ip netns del bar-ns
-	ip netns del router-ns
+	ip netns pids $foo_ns | xargs -r kill -9
+	ip netns pids $bar_ns | xargs -r kill -9
+	ip netns pids $router_ns | xargs -r kill -9
+	cleanup_ns $foo_ns $bar_ns $router_ns
 
 	show_output
 
-- 
2.43.0



