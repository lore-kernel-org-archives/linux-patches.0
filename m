Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B4B6CDC9;
	Tue, 14 May 2024 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685468; cv=none; b=DKICr1EMwpPSH5tVUjKWFGaeQxRBhOYEJcSZBPEw1qIIKvecm8KAxtYkEOyVlYAe5J7MyLnPmXQX10Ez/OY7K7aTsJrOHHainzy7yEbVnZCu05aC/yRhp4KROoFzleaifuOaDn6RBauG8vLZ3qf2ez75WJkuYztAVRXz839Hv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685468; c=relaxed/simple;
	bh=DsRtHs0D5LF44jBz8GxTS7BIaO3CdGwNPrMmLtBgFvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFaui78r6Pg9luCQemDJq9aPOqOZ7LuEz+YTzjp1UQvWEAnjLjDpMoFNtO7Hl4m1gy2bra75BVb5nZsMyFN+xLhE1OJybXmKyjz+ZGkWKlM9XbV2ydoo54KA0QF55dP7gjZNDj0a+FzVc7zLxq8Pf/4EULxRKtzS4ZBevgP6FYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tC6EF3TK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tC6EF3TK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F50C2BD10;
	Tue, 14 May 2024 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685468;
	bh=DsRtHs0D5LF44jBz8GxTS7BIaO3CdGwNPrMmLtBgFvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC6EF3TKE09VLncBtdFaswpmCLGUhYoSpBcCSv1iROhmhUyAoy1VHI+hWoem7NdWj
	 5POmP3J+xG7TCXIjoZXKlr0ZgqyMqhE8o1mWEaxRGrLP9QDbo4yxXzjzSqopl33qF/
	 bIKq7DQh+pafHcQEEgIuph08IOPTzAWWsD2zP5Rc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/301] selftests: test_bridge_neigh_suppress.sh: Fix failures due to duplicate MAC
Date: Tue, 14 May 2024 12:17:44 +0200
Message-ID: <20240514101039.541349712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

[ Upstream commit 9a169c267e946b0f47f67e8ccc70134708ccf3d4 ]

When creating the topology for the test, three veth pairs are created in
the initial network namespace before being moved to one of the network
namespaces created by the test.

On systems where systemd-udev uses MACAddressPolicy=persistent (default
since systemd version 242), this will result in some net devices having
the same MAC address since they were created with the same name in the
initial network namespace. In turn, this leads to arping / ndisc6
failing since packets are dropped by the bridge's loopback filter.

Fix by creating each net device in the correct network namespace instead
of moving it there from the initial network namespace.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240426074015.251854d4@kernel.org/
Fixes: 7648ac72dcd7 ("selftests: net: Add bridge neighbor suppression test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20240507113033.1732534-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/test_bridge_neigh_suppress.sh    | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/test_bridge_neigh_suppress.sh b/tools/testing/selftests/net/test_bridge_neigh_suppress.sh
index 8533393a4f186..02b986c9c247d 100755
--- a/tools/testing/selftests/net/test_bridge_neigh_suppress.sh
+++ b/tools/testing/selftests/net/test_bridge_neigh_suppress.sh
@@ -154,17 +154,9 @@ setup_topo()
 		setup_topo_ns $ns
 	done
 
-	ip link add name veth0 type veth peer name veth1
-	ip link set dev veth0 netns $h1 name eth0
-	ip link set dev veth1 netns $sw1 name swp1
-
-	ip link add name veth0 type veth peer name veth1
-	ip link set dev veth0 netns $sw1 name veth0
-	ip link set dev veth1 netns $sw2 name veth0
-
-	ip link add name veth0 type veth peer name veth1
-	ip link set dev veth0 netns $h2 name eth0
-	ip link set dev veth1 netns $sw2 name swp1
+	ip -n $h1 link add name eth0 type veth peer name swp1 netns $sw1
+	ip -n $sw1 link add name veth0 type veth peer name veth0 netns $sw2
+	ip -n $h2 link add name eth0 type veth peer name swp1 netns $sw2
 }
 
 setup_host_common()
-- 
2.43.0



