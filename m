Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BCD1487F1;
	Wed, 19 Jun 2024 13:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803323; cv=none; b=r7XbeHijlwWwfNc321lk5R4GcKciIxJT8kg0jtxPBS7CyEyr0Ia1nwAqP03gacoUYr1MkjDnSJAwTl7M6gHgLbjZN0nzujZIWajBZe2NDBolXAzdYOkVEN2oIlVOIIktNwnT9zlOI4ANkrVEW3OvmwOUdp94BXXb7ZoaO3iDbPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803323; c=relaxed/simple;
	bh=WZrLD7JY0c2pA2fxkeiXcfrKBJQzCT3RCzA6g1Q7w/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKqzET9f1EpaMuB2oR7kRC9X5XHNokZL9KWzut8Rb2uemJcuQbWNb1BpluCRHSaRuHCXcXWBgLc+5c44yDr5nQXFaFhUlbmFqAywxZM2kBmLh3UhAsPLKPdojjlaZ1wmZa1kr4ne3MNhfpZU2uV2pnBLL0y4ShA3iZn+tN9VdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRTyR+tO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRTyR+tO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF84C2BBFC;
	Wed, 19 Jun 2024 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803323;
	bh=WZrLD7JY0c2pA2fxkeiXcfrKBJQzCT3RCzA6g1Q7w/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRTyR+tOcwmEIZCWk9scoX2iMFOEDEM1pLHfIbFqo5gH0lgO0wxMuja5vlPPjfwLq
	 dmvEmB4RPoj0Neh3ZIaHXOQ6iX7wqHY0g9yNkcpwjfQcC5kqhk62i5OuIGKj7OtTR3
	 rs8WAfrgHsvJMEk+tkcDkI2zXhFDIuOhj6/dPQJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	YonglongLi <liyonglong@chinatelecom.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.9 211/281] mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID
Date: Wed, 19 Jun 2024 14:56:10 +0200
Message-ID: <20240619125618.078484055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YonglongLi <liyonglong@chinatelecom.cn>

commit 6a09788c1a66e3d8b04b3b3e7618cc817bb60ae9 upstream.

The RmAddr MIB counter is supposed to be incremented once when a valid
RM_ADDR has been received. Before this patch, it could have been
incremented as many times as the number of subflows connected to the
linked address ID, so it could have been 0, 1 or more than 1.

The "RmSubflow" is incremented after a local operation. In this case,
it is normal to tied it with the number of subflows that have been
actually removed.

The "remove invalid addresses" MP Join subtest has been modified to
validate this case. A broadcast IP address is now used instead: the
client will not be able to create a subflow to this address. The
consequence is that when receiving the RM_ADDR with the ID attached to
this broadcast IP address, no subflow linked to this ID will be found.

Fixes: 7a7e52e38a40 ("mptcp: add RM_ADDR related mibs")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: YonglongLi <liyonglong@chinatelecom.cn>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-20240607-misc-fixes-v1-2-1ab9ddfa3d00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c                          |    5 ++++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -813,10 +813,13 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			spin_lock_bh(&msk->pm.lock);
 
 			removed = true;
-			__MPTCP_INC_STATS(sock_net(sk), rm_type);
+			if (rm_type == MPTCP_MIB_RMSUBFLOW)
+				__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
 		if (rm_type == MPTCP_MIB_RMSUBFLOW)
 			__set_bit(rm_id ? rm_id : msk->mpc_endpoint_id, msk->pm.id_avail_bitmap);
+		else if (rm_type == MPTCP_MIB_RMADDR)
+			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		if (!removed)
 			continue;
 
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2359,7 +2359,8 @@ remove_tests()
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		addr_nr_ns1=-3 speed=10 \
 			run_tests $ns1 $ns2 10.0.1.1


