Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F613AA40;
	Wed, 19 Jun 2024 13:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802488; cv=none; b=NloaLXoFIu2kquzZkJiksIwRDREN9ur/CJL9j2sRYVpmQbk7QpOk7VzeNAaeSPdHOOtsOMiZeabSkj7YRh71Q5Sy5IXCzBUKRUoHF+0CCH8JqRYWtVH0X8A/EkQ5AKyjxAd3jXag1k7Kqo212lev4814ghKpbBnDELO7ayB7y3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802488; c=relaxed/simple;
	bh=mK+oQKAtCF4IXQl8VPVkwLOQEjWjF0X5esJXb3BtJ0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f1ntFZs0ruiD/6gv7UIMOhAhAKuzSjGXOrsfWgsQ1v2uZAt1CWwzskolSlHpvhLQ1PtIGUMI5W1VJZc83+XcMbttXmgr9ujQ2bQCCUZuMv/F14YerjpkVOhhIyvroYKClJAAx1VPYWhG7o64HZDrfY6VukrOaicKOE2XwO49V8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOF4Xab/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOF4Xab/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5E8C2BBFC;
	Wed, 19 Jun 2024 13:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802488;
	bh=mK+oQKAtCF4IXQl8VPVkwLOQEjWjF0X5esJXb3BtJ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOF4Xab/eY3Wc1Q+aN0vhmxBPLy6UozS7ZN5kpgxpSrD/lBwceNpOFPBpXb3tyUr/
	 IaprHHWQMOuxdR28qbIqSExhjBVwaHSdu4BiTq7/bYu+Gya+bPDpLKEySS76fGLx3J
	 xntrQY+MDYCk+RNLwMualhQt+kb1Uy7eVFHzytVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	YonglongLi <liyonglong@chinatelecom.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 186/267] mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID
Date: Wed, 19 Jun 2024 14:55:37 +0200
Message-ID: <20240619125613.481885901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
@@ -822,10 +822,13 @@ static void mptcp_pm_nl_rm_addr_or_subfl
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
@@ -2394,7 +2394,8 @@ remove_tests()
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 flags signal
 		pm_nl_set_limits $ns2 3 3
 		addr_nr_ns1=-3 speed=10 \
 			run_tests $ns1 $ns2 10.0.1.1


