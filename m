Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB74F184136;
	Wed,  3 Jul 2024 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005623; cv=none; b=bg/X0OtTVjOR5AME0H13e12OHJ7CMJkmRf3rLnHRdAtA/17pINPwut/bfcXwGlf+84gXltkj+uPFGsp4i4rSIGrZJkl8OWVULc9nGvxfYLOqVhOwWsJrrkxd9CQSG8hHMMKjBEkYiLK7txYIB2RoyqhyPbjAOzv2trZzwSrtRsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005623; c=relaxed/simple;
	bh=gj+chmS6bPmRFe0Ed/SkWBKj2EptoMPhTv5J16+Yz1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLVpmEsS3WITiBWatpspgYzHv6Y+nemeiHt0qgsEAwPj5wEtdBTvtdrcADPPaoirGEuD9NMN30FV6j3NCUsUXT8Tsw8oBUYU1mARSl7K1Y0eye/zlQ0VRJng3GHsWExrLuQMzVjx6pfghzcOcNvYCrjXNuk97SLyDKcrDMTYn5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSehNlIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSehNlIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E66C4AF0C;
	Wed,  3 Jul 2024 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005623;
	bh=gj+chmS6bPmRFe0Ed/SkWBKj2EptoMPhTv5J16+Yz1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSehNlIc/zhaqnDLGnMZOPZdJqk3sehLULT19u7ePNXJ35bzdH2WQPwa/Hj6gMkO/
	 /JylBqiX4iUo0wZGlYI7uC7EIgUGcrkTOeEjYqqKuv9+/e0d35RnnrwuSJ3j98zxpy
	 xFzXTfrJN73avYhfdU+G6d+di1UP6astXh+RuO5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	YonglongLi <liyonglong@chinatelecom.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 140/356] mptcp: pm: inc RmAddr MIB counter once per RM_ADDR ID
Date: Wed,  3 Jul 2024 12:37:56 +0200
Message-ID: <20240703102918.396157348@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in pm_netlink.c because the context has changed later in
  multiple commits linked to new features, e.g. commit 86e39e04482b
  ("mptcp: keep track of local endpoint still available for each msk"),
  commit a88c9e496937 ("mptcp: do not block subflows creation on errors")
  and commit 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking"),
  but the independent lines that needed to be modified were still there.
  Conflicts in the selftests, because many features modifying the whole
  file have been added later, e.g. commit ae7bd9ccecc3 ("selftests:
  mptcp: join: option to execute specific tests"). The same
  modifications have been reported to the old code: simply changing the
  IP address and add a new comment. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c                          |    5 ++++-
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -757,8 +757,11 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 
 			removed = true;
 			msk->pm.subflows--;
-			__MPTCP_INC_STATS(sock_net(sk), rm_type);
+			if (rm_type == MPTCP_MIB_RMSUBFLOW)
+				__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
+		if (rm_type == MPTCP_MIB_RMADDR)
+			__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		if (!removed)
 			continue;
 
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1307,7 +1307,8 @@ remove_tests()
 	ip netns exec $ns1 ./pm_nl_ctl limits 3 3
 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.12.1 flags signal
 	ip netns exec $ns1 ./pm_nl_ctl add 10.0.3.1 flags signal
-	ip netns exec $ns1 ./pm_nl_ctl add 10.0.14.1 flags signal
+	# broadcast IP: no packet for this address will be received on ns1
+	ip netns exec $ns1 ./pm_nl_ctl add 224.0.0.1 flags signal
 	ip netns exec $ns2 ./pm_nl_ctl limits 3 3
 	run_tests $ns1 $ns2 10.0.1.1 0 -3 0 slow
 	chk_join_nr "remove invalid addresses" 1 1 1


