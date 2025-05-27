Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1081FB3;
	Tue, 27 May 2025 17:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368003; cv=none; b=Rc2QI+C/Ok9FZLSpVPQrFBP1zVJTVrGGcW/PuWLK/kLOoJ+qK6eTV4MPTKXkwPjkTn/47OnDx8ffX22SqMiiRd+wxj+rtWFhvzKBrT+Ph5km7Yyr19dAaqbRCjehjRB+frL9XXPfqO1nEdwiBsV0fVnCJQkCAITuBD9+BAYb9l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368003; c=relaxed/simple;
	bh=9Mx+IcKdXqbLFHdPXAvLICXGA1Ug/tDhHU7AjjCkgTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R83ZlkRvdCtgK2lWRBCql+zTvtVKfz+FvqVYYC43bzFYi3Ujx6TNIG8inXh9KftpDwXvpjidRvKMcnZ+SJ0UshmlKWZg6LSJpG6HT++1/HdrvfgHH3uupX6nCQFlk1bsb84ZoyAFULtFSIAjKXEGGrALAFKXTZ8jzYg19ICUhLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXeU0H6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXeU0H6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8939C4CEE9;
	Tue, 27 May 2025 17:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368003;
	bh=9Mx+IcKdXqbLFHdPXAvLICXGA1Ug/tDhHU7AjjCkgTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXeU0H6zMH5AeEFG4n1EQLXMwnN8YyvgVOcXN/ML6ICTaD2EXmbk18trYVwBlUE1Z
	 H7IQfCjy46WtipPpVta3af63TmB9Z6oyT0iGz5xDDl8Ox+Pm7bpNzLuBWU9GyIxjHu
	 tkBuXguHU72NyHrjMn25z4wzhLX/KgdjlQTBtuH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 567/783] bridge: mdb: Allow replace of a host-joined group
Date: Tue, 27 May 2025 18:26:04 +0200
Message-ID: <20250527162536.232364347@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit d9e9f6d7b7d0c520bb87f19d2cbc57aeeb2091d5 ]

Attempts to replace an MDB group membership of the host itself are
currently bounced:

 # ip link add name br up type bridge vlan_filtering 1
 # bridge mdb replace dev br port br grp 239.0.0.1 vid 2
 # bridge mdb replace dev br port br grp 239.0.0.1 vid 2
 Error: bridge: Group is already joined by host.

A similar operation done on a member port would succeed. Ignore the check
for replacement of host group memberships as well.

The bit of code that this enables is br_multicast_host_join(), which, for
already-joined groups only refreshes the MC group expiration timer, which
is desirable; and a userspace notification, also desirable.

Change a selftest that exercises this code path from expecting a rejection
to expecting a pass. The rest of MDB selftests pass without modification.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/e5c5188b9787ae806609e7ca3aa2a0a501b9b5c4.1738685648.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mdb.c                                  | 2 +-
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 1a52a0bca086d..7e1ad229e1330 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1040,7 +1040,7 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 
 	/* host join */
 	if (!port) {
-		if (mp->host_joined) {
+		if (mp->host_joined && !(cfg->nlflags & NLM_F_REPLACE)) {
 			NL_SET_ERR_MSG_MOD(extack, "Group is already joined by host");
 			return -EEXIST;
 		}
diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index d9d587454d207..8c1597ebc2d38 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -149,7 +149,7 @@ cfg_test_host_common()
 	check_err $? "Failed to add $name host entry"
 
 	bridge mdb replace dev br0 port br0 grp $grp $state vid 10 &> /dev/null
-	check_fail $? "Managed to replace $name host entry"
+	check_err $? "Failed to replace $name host entry"
 
 	bridge mdb del dev br0 port br0 grp $grp $state vid 10
 	bridge mdb get dev br0 grp $grp vid 10 &> /dev/null
-- 
2.39.5



