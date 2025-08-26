Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EBF341AA6;
	Tue, 26 Aug 2025 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219495; cv=none; b=e77xqSqufADF9h6BJ3eZ/617w+jb/26rBW5jUNj5ybB7A4pHCEerStR7dQO8wcaSvxnm3AlFvHv9I7CRQ+JgcRcMu0S/9IWIM+AdazoN0bF+tpci/gnVrVn9xlOACJGlRUVq7gJDE9T+ovNDXJGHf7+VDf/Ew8yEtNUIOMrJ4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219495; c=relaxed/simple;
	bh=xnRSBTlmvlORcuXWCZtYqGEpRvA6Qbj51tCaRepXVoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7yTe5G9Io3pHM9uUoX7jneVlRPa0fvMg0y8mrHBIEGHcaNPfnKeDE5lpOeGb1e4yUDjO0WSnFLm89zBPaS9oRXVHag2BdYmu1vrUCgXqIz0XWM0tliFj1WYiT2Bn9GXGr/Q5P0+reo251gTGgvculQ8+4gwDKXDhIqcoz6M+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7xw/9xK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7xw/9xK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B932C4CEF1;
	Tue, 26 Aug 2025 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219494;
	bh=xnRSBTlmvlORcuXWCZtYqGEpRvA6Qbj51tCaRepXVoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7xw/9xKjIJWC2Z7haQfR/iMRcSkVurkc+uYmGI6PybahBt54xYLljkeP1IkTHBa2
	 2xkBPZ1ykWPI/yZdS4HQdhAuZxbfgtX83wH3pQZDtsJwS/2hVsWXKhQCvrka87RK4D
	 L0bGW7cCmRzS+D6yqpgOCL/oBsYVUGQk8YnqD2zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@mellanox.com>,
	Ido Schimmel <idosch@mellanox.com>,
	"David S. Miller" <davem@davemloft.net>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 386/403] selftests: forwarding: tc_actions.sh: add matchall mirror test
Date: Tue, 26 Aug 2025 13:11:52 +0200
Message-ID: <20250826110917.682840395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@mellanox.com>

[ Upstream commit 075c8aa79d541ea08c67a2e6d955f6457e98c21c ]

Add test for matchall classifier with mirred egress mirror action.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/tc_actions.sh |   26 +++++++++++++------
 1 file changed, 18 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -2,7 +2,8 @@
 # SPDX-License-Identifier: GPL-2.0
 
 ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
-	mirred_egress_mirror_test gact_trap_test"
+	mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
+	gact_trap_test"
 NUM_NETIFS=4
 source tc_common.sh
 source lib.sh
@@ -50,6 +51,9 @@ switch_destroy()
 mirred_egress_test()
 {
 	local action=$1
+	local protocol=$2
+	local classifier=$3
+	local classifier_args=$4
 
 	RET=0
 
@@ -62,9 +66,9 @@ mirred_egress_test()
 	tc_check_packets "dev $h2 ingress" 101 1
 	check_fail $? "Matched without redirect rule inserted"
 
-	tc filter add dev $swp1 ingress protocol ip pref 1 handle 101 flower \
-		$tcflags dst_ip 192.0.2.2 action mirred egress $action \
-		dev $swp2
+	tc filter add dev $swp1 ingress protocol $protocol pref 1 handle 101 \
+		$classifier $tcflags $classifier_args \
+		action mirred egress $action dev $swp2
 
 	$MZ $h1 -c 1 -p 64 -a $h1mac -b $h2mac -A 192.0.2.1 -B 192.0.2.2 \
 		-t ip -q
@@ -72,10 +76,11 @@ mirred_egress_test()
 	tc_check_packets "dev $h2 ingress" 101 1
 	check_err $? "Did not match incoming $action packet"
 
-	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $swp1 ingress protocol $protocol pref 1 handle 101 \
+		$classifier
 	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
 
-	log_test "mirred egress $action ($tcflags)"
+	log_test "mirred egress $classifier $action ($tcflags)"
 }
 
 gact_drop_and_ok_test()
@@ -187,12 +192,17 @@ cleanup()
 
 mirred_egress_redirect_test()
 {
-	mirred_egress_test "redirect"
+	mirred_egress_test "redirect" "ip" "flower" "dst_ip 192.0.2.2"
 }
 
 mirred_egress_mirror_test()
 {
-	mirred_egress_test "mirror"
+	mirred_egress_test "mirror" "ip" "flower" "dst_ip 192.0.2.2"
+}
+
+matchall_mirred_egress_mirror_test()
+{
+	mirred_egress_test "mirror" "all" "matchall" ""
 }
 
 trap cleanup EXIT


