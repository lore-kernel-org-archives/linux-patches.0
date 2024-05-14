Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D280D6D1AF;
	Tue, 14 May 2024 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683627; cv=none; b=fylsk0Z8OROIE93b2iWHodUtspUqkPRJDJuvVECKy6fpRF4y4AvJmZydAH9GA6TFoEc+KfimTt5jtxJW9vG89rPzchMjlUpxkDYR22tb/jl+FgXvRAzMqobLaWTHXQNUpN6UvlKXrXCuKm7gyF24+GuaSPMYtZeDCVlkmpBq7ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683627; c=relaxed/simple;
	bh=RR1F6YoXbkKmZkgavLydd7d8P86qyNpuzYRh3U6vbpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnaHHqB2VmeyjamGmt5cXgcir8KKysDu8KgNjJ2NVF/88JMZOT0s8d80wBuyJCBTbftI93YV66DQjE5IpdpP0pittN3YXllwcKeaS72UHoOsq3Yrnklr+9jpAHvXrodCgDMlr/40Qr1usv/UuiM7aXF56dtddin9XLeVrXtVhDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kWX1We/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kWX1We/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FC7C2BD10;
	Tue, 14 May 2024 10:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683627;
	bh=RR1F6YoXbkKmZkgavLydd7d8P86qyNpuzYRh3U6vbpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWX1We/vYxc+4Zz97xLKSH4yoFH7ZiwWDzkdPQyiqjRMOiuL1jm9JDUX6YpZBu/nS
	 +KqFiIxO9Kk/IQx5ZvbxRUoAS0qMUytlIQlcbYqeBW770z7If9ulhuuni0T7kbTxXG
	 3DZOwePTp1bhBjlXjvhm+eh3c92QwgSfuo7nNou8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 215/336] selftests: test_bridge_neigh_suppress.sh: Fix failures due to duplicate MAC
Date: Tue, 14 May 2024 12:16:59 +0200
Message-ID: <20240514101046.729128698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



