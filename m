Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA69635A92E;
	Fri,  9 Jan 2026 12:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960044; cv=none; b=HGfgizDrrq6pb1sJGKfsmcOg3hP9QoM0l6x9CUmn8n7xFwzaq6PRTCZyxdvvUuhccXDvJYRrPVLSp/yO7+cs+c3u8ZiyodFM090TMGd9Q0tXzprqjuFYuS4M94yictvzzcCPHjgIVBtpsjaLw/AxmgQtfGUgLvInt+2TJjsdJo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960044; c=relaxed/simple;
	bh=nz/rg1jh2Qal1ffsEPjy1Rpuhk//FAyjBj3m1/bxykM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HejnbgBBH7YcrRCOpQvnH/CArzY5qxbGN09ybtxYt+POzZJqqlWXWn5fQwsL1lXrQNrL8zBOlQ44bgXmWAXq/0kMaM7jbjM32T+11ogiNj4tDxswdmKqfGUe/MnQDQAUt2u9Gh1XN9tTUL3fThdZDdTt5y/i9B3pLQw5NoAt1u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eslOGCjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eslOGCjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033F3C4CEF1;
	Fri,  9 Jan 2026 12:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960044;
	bh=nz/rg1jh2Qal1ffsEPjy1Rpuhk//FAyjBj3m1/bxykM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eslOGCjwxj9c3GkYQ69Rn8RY4qPiWS4gdV61VuvKXhzJZ/EtdiEmho/muVH8gEmz5
	 Xttc9q0DMBaBjXjMvJpkaoKA1Ps3GNCfrkZbrrYn5Q2QBjQHmx9+bTosJIqWOZBbTS
	 vreArJHJzXhXjieKohJadMFM5m544WWNtOH5aipQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/737] selftests: bonding: add delay before each xvlan_over_bond connectivity check
Date: Fri,  9 Jan 2026 12:36:27 +0100
Message-ID: <20260109112143.322698770@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2c28ee720ad14f58eb88a97ec3efe7c5c315ea5d ]

Jakub reported increased flakiness in bond_macvlan_ipvlan.sh on regular
kernel, while the tests consistently pass on a debug kernel. This suggests
a timing-sensitive issue.

To mitigate this, introduce a short sleep before each xvlan_over_bond
connectivity check. The delay helps ensure neighbor and route cache
have fully converged before verifying connectivity.

The sleep interval is kept minimal since check_connection() is invoked
nearly 100 times during the test.

Fixes: 246af950b940 ("selftests: bonding: add macvlan over bond testing")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251114082014.750edfad@kernel.org
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20251127143310.47740-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
index c4711272fe45d..559f300f965aa 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_macvlan_ipvlan.sh
@@ -30,6 +30,7 @@ check_connection()
 	local message=${3}
 	RET=0
 
+	sleep 0.25
 	ip netns exec ${ns} ping ${target} -c 4 -i 0.1 &>/dev/null
 	check_err $? "ping failed"
 	log_test "${bond_mode}/${xvlan_type}_${xvlan_mode}: ${message}"
-- 
2.51.0



