Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABE4152DEE;
	Tue, 20 Feb 2024 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463407; cv=none; b=K20JUpiUoh2TCMyYo+c+d6teSj5I6YRwj2r1mVlMVUo9OJhHVmWU9IjGYQtanD0e2ktkAcixYUgcqg568iHZ5krqRQHix4JrRH1+IO1clxxNH9/tstVjM2Y1jhfzMSXh5ZfmC6fwO47vXPowaYuDIVNhJfZufOcrqXFQZV8uVdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463407; c=relaxed/simple;
	bh=fa/N/tzgYV/16/IJcfnW5vVJG4RkWZf75b1ZJkENlR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aok/TaqWf0OEV6xvkmIKH3cK5QXcnsBf0gB1gfNoVsnAhFrfLc0B9bxXBcfsBqxotuELlQaSRlw1RCcCMCkiquI1YjKoUYJEf4XK9CY7eOwab5bvOjwjxI6i6WZ0JG8yNbNYcKeN7lreJs/61OSDYC/WaeyyG5BSJyYdNoo/Kes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZfBfcWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZfBfcWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACFAC433F1;
	Tue, 20 Feb 2024 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463405;
	bh=fa/N/tzgYV/16/IJcfnW5vVJG4RkWZf75b1ZJkENlR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZfBfcWF/4H/Dzqaf02+IMs2/5kcyjkCYR1djtFBB5Jfuac42wUm+VAKjyTN3lFFG
	 sPYEFFPQySGmgb0r4HnuXQ4zrX7vn3isSmtA0anPxg19br90njotUSoI2JyEsJhnZL
	 Rg54Bg186wBbr7bfCD46FKeDj21G1M79Hs9nBNU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/331] selftests: bridge_mdb: Use MDB get instead of dump
Date: Tue, 20 Feb 2024 21:52:30 +0100
Message-ID: <20240220205638.666261740@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit e8bba9e83c88ea951dafd3319c97c55a52b3637d ]

Test the new MDB get functionality by converting dump and grep to MDB
get.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dd6b34589441 ("selftests: forwarding: Suppress grep warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/forwarding/bridge_mdb.sh    | 184 +++++++-----------
 1 file changed, 71 insertions(+), 113 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 529a56adbb88..ebeb43f6606c 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -145,14 +145,14 @@ cfg_test_host_common()
 
 	# Check basic add, replace and delete behavior.
 	bridge mdb add dev br0 port br0 grp $grp $state vid 10
-	bridge mdb show dev br0 vid 10 | grep -q "$grp"
+	bridge mdb get dev br0 grp $grp vid 10 &> /dev/null
 	check_err $? "Failed to add $name host entry"
 
 	bridge mdb replace dev br0 port br0 grp $grp $state vid 10 &> /dev/null
 	check_fail $? "Managed to replace $name host entry"
 
 	bridge mdb del dev br0 port br0 grp $grp $state vid 10
-	bridge mdb show dev br0 vid 10 | grep -q "$grp"
+	bridge mdb get dev br0 grp $grp vid 10 &> /dev/null
 	check_fail $? "Failed to delete $name host entry"
 
 	# Check error cases.
@@ -200,7 +200,7 @@ cfg_test_port_common()
 
 	# Check basic add, replace and delete behavior.
 	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
-	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 10 &> /dev/null
 	check_err $? "Failed to add $name entry"
 
 	bridge mdb replace dev br0 port $swp1 $grp_key permanent vid 10 \
@@ -208,31 +208,31 @@ cfg_test_port_common()
 	check_err $? "Failed to replace $name entry"
 
 	bridge mdb del dev br0 port $swp1 $grp_key permanent vid 10
-	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 10 &> /dev/null
 	check_fail $? "Failed to delete $name entry"
 
 	# Check default protocol and replacement.
 	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "static"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "static"
 	check_err $? "$name entry not added with default \"static\" protocol"
 
 	bridge mdb replace dev br0 port $swp1 $grp_key permanent vid 10 \
 		proto 123
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "123"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "123"
 	check_err $? "Failed to replace protocol of $name entry"
 	bridge mdb del dev br0 port $swp1 $grp_key permanent vid 10
 
 	# Check behavior when VLAN is not specified.
 	bridge mdb add dev br0 port $swp1 $grp_key permanent
-	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 10 &> /dev/null
 	check_err $? "$name entry with VLAN 10 not added when VLAN was not specified"
-	bridge mdb show dev br0 vid 20 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 20 &> /dev/null
 	check_err $? "$name entry with VLAN 20 not added when VLAN was not specified"
 
 	bridge mdb del dev br0 port $swp1 $grp_key permanent
-	bridge mdb show dev br0 vid 10 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 10 &> /dev/null
 	check_fail $? "$name entry with VLAN 10 not deleted when VLAN was not specified"
-	bridge mdb show dev br0 vid 20 | grep -q "$grp_key"
+	bridge mdb get dev br0 $grp_key vid 20 &> /dev/null
 	check_fail $? "$name entry with VLAN 20 not deleted when VLAN was not specified"
 
 	# Check behavior when bridge port is down.
@@ -298,21 +298,21 @@ __cfg_test_port_ip_star_g()
 	RET=0
 
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "exclude"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "exclude"
 	check_err $? "Default filter mode is not \"exclude\""
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
 
 	# Check basic add and delete behavior.
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10 filter_mode exclude \
 		source_list $src1
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q -v "src"
+	bridge -d mdb get dev br0 grp $grp vid 10 &> /dev/null
 	check_err $? "(*, G) entry not created"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 &> /dev/null
 	check_err $? "(S, G) entry not created"
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q -v "src"
+	bridge -d mdb get dev br0 grp $grp vid 10 &> /dev/null
 	check_fail $? "(*, G) entry not deleted"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 &> /dev/null
 	check_fail $? "(S, G) entry not deleted"
 
 	## State (permanent / temp) tests.
@@ -321,18 +321,15 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp permanent vid 10 \
 		filter_mode exclude source_list $src1
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "permanent"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "permanent"
 	check_err $? "(*, G) entry not added as \"permanent\" when should"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | \
 		grep -q "permanent"
 	check_err $? "(S, G) entry not added as \"permanent\" when should"
 
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_err $? "(*, G) \"permanent\" entry has a pending group timer"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
 	check_err $? "\"permanent\" source entry has a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -342,18 +339,14 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "temp"
 	check_err $? "(*, G) EXCLUDE entry not added as \"temp\" when should"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "temp"
 	check_err $? "(S, G) \"blocked\" entry not added as \"temp\" when should"
 
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_fail $? "(*, G) EXCLUDE entry does not have a pending group timer"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
 	check_err $? "\"blocked\" source entry has a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -363,18 +356,14 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode include source_list $src1
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "temp"
 	check_err $? "(*, G) INCLUDE entry not added as \"temp\" when should"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "temp"
 	check_err $? "(S, G) entry not added as \"temp\" when should"
 
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_err $? "(*, G) INCLUDE entry has a pending group timer"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
 	check_fail $? "Source entry does not have a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -383,8 +372,7 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode include source_list $src1
 
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 grp $grp src $src1 vid 10 | grep -q " 0.00"
 	check_err $? "(S, G) entry has a pending group timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -396,11 +384,9 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
 		filter_mode include source_list $src1
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "include"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "include"
 	check_err $? "(*, G) INCLUDE not added with \"include\" filter mode"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "blocked"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "blocked"
 	check_fail $? "(S, G) entry marked as \"blocked\" when should not"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -410,11 +396,9 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
 		filter_mode exclude source_list $src1
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "exclude"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "exclude"
 	check_err $? "(*, G) EXCLUDE not added with \"exclude\" filter mode"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "blocked"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "blocked"
 	check_err $? "(S, G) entry not marked as \"blocked\" when should"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -426,11 +410,9 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10 \
 		filter_mode exclude source_list $src1 proto zebra
 
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "zebra"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "zebra"
 	check_err $? "(*, G) entry not added with \"zebra\" protocol"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "zebra"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "zebra"
 	check_err $? "(S, G) entry not marked added with \"zebra\" protocol"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -443,20 +425,16 @@ __cfg_test_port_ip_star_g()
 
 	bridge mdb replace dev br0 port $swp1 grp $grp permanent vid 10 \
 		filter_mode exclude source_list $src1
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "permanent"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "permanent"
 	check_err $? "(*, G) entry not marked as \"permanent\" after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "permanent"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "permanent"
 	check_err $? "(S, G) entry not marked as \"permanent\" after replace"
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "temp"
 	check_err $? "(*, G) entry not marked as \"temp\" after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "temp"
 	check_err $? "(S, G) entry not marked as \"temp\" after replace"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -467,20 +445,16 @@ __cfg_test_port_ip_star_g()
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode include source_list $src1
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "include"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "include"
 	check_err $? "(*, G) not marked with \"include\" filter mode after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "blocked"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "blocked"
 	check_fail $? "(S, G) marked as \"blocked\" after replace"
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "exclude"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "exclude"
 	check_err $? "(*, G) not marked with \"exclude\" filter mode after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "blocked"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "blocked"
 	check_err $? "(S, G) not marked as \"blocked\" after replace"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -491,20 +465,20 @@ __cfg_test_port_ip_star_g()
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1,$src2,$src3
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 &> /dev/null
 	check_err $? "(S, G) entry for source $src1 not created after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src2"
+	bridge -d mdb get dev br0 grp $grp src $src2 vid 10 &> /dev/null
 	check_err $? "(S, G) entry for source $src2 not created after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src3"
+	bridge -d mdb get dev br0 grp $grp src $src3 vid 10 &> /dev/null
 	check_err $? "(S, G) entry for source $src3 not created after replace"
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1,$src3
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src1"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 &> /dev/null
 	check_err $? "(S, G) entry for source $src1 not created after second replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src2"
+	bridge -d mdb get dev br0 grp $grp src $src2 vid 10 &> /dev/null
 	check_fail $? "(S, G) entry for source $src2 created after second replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -q "src $src3"
+	bridge -d mdb get dev br0 grp $grp src $src3 vid 10 &> /dev/null
 	check_err $? "(S, G) entry for source $src3 not created after second replace"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -515,11 +489,9 @@ __cfg_test_port_ip_star_g()
 
 	bridge mdb replace dev br0 port $swp1 grp $grp temp vid 10 \
 		filter_mode exclude source_list $src1 proto bgp
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep -v "src" | \
-		grep -q "bgp"
+	bridge -d mdb get dev br0 grp $grp vid 10 | grep -q "bgp"
 	check_err $? "(*, G) protocol not changed to \"bgp\" after replace"
-	bridge -d mdb show dev br0 vid 10 | grep "$grp" | grep "src" | \
-		grep -q "bgp"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep -q "bgp"
 	check_err $? "(S, G) protocol not changed to \"bgp\" after replace"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -532,8 +504,8 @@ __cfg_test_port_ip_star_g()
 	bridge mdb add dev br0 port $swp2 grp $grp vid 10 \
 		filter_mode include source_list $src1
 	bridge mdb add dev br0 port $swp1 grp $grp vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$swp1" | grep "$grp" | \
-		grep "$src1" | grep -q "added_by_star_ex"
+	bridge -d mdb get dev br0 grp $grp src $src1 vid 10 | grep "$swp1" | \
+		grep -q "added_by_star_ex"
 	check_err $? "\"added_by_star_ex\" entry not created after adding (*, G) entry"
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
 	bridge mdb del dev br0 port $swp2 grp $grp src $src1 vid 10
@@ -606,27 +578,23 @@ __cfg_test_port_ip_sg()
 	RET=0
 
 	bridge mdb add dev br0 port $swp1 $grp_key vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | grep -q "include"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "include"
 	check_err $? "Default filter mode is not \"include\""
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
 	# Check that entries can be added as both permanent and temp and that
 	# group timer is set correctly.
 	bridge mdb add dev br0 port $swp1 $grp_key permanent vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "permanent"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "permanent"
 	check_err $? "Entry not added as \"permanent\" when should"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 $grp_key vid 10 | grep -q " 0.00"
 	check_err $? "\"permanent\" entry has a pending group timer"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
 	bridge mdb add dev br0 port $swp1 $grp_key temp vid 10
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "temp"
 	check_err $? "Entry not added as \"temp\" when should"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 $grp_key vid 10 | grep -q " 0.00"
 	check_fail $? "\"temp\" entry has an unpending group timer"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
@@ -650,24 +618,19 @@ __cfg_test_port_ip_sg()
 	# Check that we can replace available attributes.
 	bridge mdb add dev br0 port $swp1 $grp_key vid 10 proto 123
 	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 proto 111
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "111"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "111"
 	check_err $? "Failed to replace protocol"
 
 	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 permanent
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "permanent"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "permanent"
 	check_err $? "Entry not marked as \"permanent\" after replace"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 $grp_key vid 10 | grep -q " 0.00"
 	check_err $? "Entry has a pending group timer after replace"
 
 	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 temp
-	bridge -d mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "temp"
+	bridge -d mdb get dev br0 $grp_key vid 10 | grep -q "temp"
 	check_err $? "Entry not marked as \"temp\" after replace"
-	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q " 0.00"
+	bridge -d -s mdb get dev br0 $grp_key vid 10 | grep -q " 0.00"
 	check_fail $? "Entry has an unpending group timer after replace"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
@@ -675,7 +638,7 @@ __cfg_test_port_ip_sg()
 	# (*, G) ports need to be added to it.
 	bridge mdb add dev br0 port $swp2 grp $grp vid 10
 	bridge mdb add dev br0 port $swp1 $grp_key vid 10
-	bridge mdb show dev br0 vid 10 | grep "$grp_key" | grep $swp2 | \
+	bridge mdb get dev br0 $grp_key vid 10 | grep $swp2 | \
 		grep -q "added_by_star_ex"
 	check_err $? "\"added_by_star_ex\" entry not created after adding (S, G) entry"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
@@ -1136,7 +1099,7 @@ ctrl_igmpv3_is_in_test()
 	$MZ $h1.10 -c 1 -a own -b 01:00:5e:01:01:01 -A 192.0.2.1 -B 239.1.1.1 \
 		-t ip proto=2,p=$(igmpv3_is_in_get 239.1.1.1 192.0.2.2) -q
 
-	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -q 192.0.2.2
+	bridge mdb get dev br0 grp 239.1.1.1 src 192.0.2.2 vid 10 &> /dev/null
 	check_fail $? "Permanent entry affected by IGMP packet"
 
 	# Replace the permanent entry with a temporary one and check that after
@@ -1149,12 +1112,10 @@ ctrl_igmpv3_is_in_test()
 	$MZ $h1.10 -a own -b 01:00:5e:01:01:01 -c 1 -A 192.0.2.1 -B 239.1.1.1 \
 		-t ip proto=2,p=$(igmpv3_is_in_get 239.1.1.1 192.0.2.2) -q
 
-	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | grep -v "src" | \
-		grep -q 192.0.2.2
+	bridge -d mdb get dev br0 grp 239.1.1.1 vid 10 | grep -q 192.0.2.2
 	check_err $? "Source not add to source list"
 
-	bridge -d mdb show dev br0 vid 10 | grep 239.1.1.1 | \
-		grep -q "src 192.0.2.2"
+	bridge mdb get dev br0 grp 239.1.1.1 src 192.0.2.2 vid 10 &> /dev/null
 	check_err $? "(S, G) entry not created for new source"
 
 	bridge mdb del dev br0 port $swp1 grp 239.1.1.1 vid 10
@@ -1176,8 +1137,7 @@ ctrl_mldv2_is_in_test()
 	$MZ -6 $h1.10 -a own -b 33:33:00:00:00:01 -c 1 -A fe80::1 -B ff0e::1 \
 		-t ip hop=1,next=0,p="$p" -q
 
-	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | \
-		grep -q 2001:db8:1::2
+	bridge mdb get dev br0 grp ff0e::1 src 2001:db8:1::2 vid 10 &> /dev/null
 	check_fail $? "Permanent entry affected by MLD packet"
 
 	# Replace the permanent entry with a temporary one and check that after
@@ -1190,12 +1150,10 @@ ctrl_mldv2_is_in_test()
 	$MZ -6 $h1.10 -a own -b 33:33:00:00:00:01 -c 1 -A fe80::1 -B ff0e::1 \
 		-t ip hop=1,next=0,p="$p" -q
 
-	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | grep -v "src" | \
-		grep -q 2001:db8:1::2
+	bridge -d mdb get dev br0 grp ff0e::1 vid 10 | grep -q 2001:db8:1::2
 	check_err $? "Source not add to source list"
 
-	bridge -d mdb show dev br0 vid 10 | grep ff0e::1 | \
-		grep -q "src 2001:db8:1::2"
+	bridge mdb get dev br0 grp ff0e::1 src 2001:db8:1::2 vid 10 &> /dev/null
 	check_err $? "(S, G) entry not created for new source"
 
 	bridge mdb del dev br0 port $swp1 grp ff0e::1 vid 10
@@ -1212,8 +1170,8 @@ ctrl_test()
 	ctrl_mldv2_is_in_test
 }
 
-if ! bridge mdb help 2>&1 | grep -q "replace"; then
-	echo "SKIP: iproute2 too old, missing bridge mdb replace support"
+if ! bridge mdb help 2>&1 | grep -q "get"; then
+	echo "SKIP: iproute2 too old, missing bridge mdb get support"
 	exit $ksft_skip
 fi
 
-- 
2.43.0



