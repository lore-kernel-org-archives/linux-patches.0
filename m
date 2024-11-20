Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD51B1B3727;
	Wed, 20 Nov 2024 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107533; cv=none; b=MO5ITHxZp/yI2ZZrbZhESkMWlM0aXKOkeyh2HtaibKjl0AF6Mkq04CiL/xI0JBBOCfWoFuyOckA41i6AahDvjdw0zR6UIVFBqbqku7tzdWig24FshnGgZq4y9mB5THY7DakBrL4y3cxIgkK17kvsSCVZQlovdfl/KtJ+bdOB168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107533; c=relaxed/simple;
	bh=p1swoldLTwGQh3eyx3dn52C5lfRPahhfHVmhpNNBmyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/dOBcBjx3Gq5t8hYzvzEGf/NV4g9dgF1y8ATDRyk8QePVksBFRcRVg4Ksg3l99e5xI6krMceBZkJUZ/z1qYa+5x/YSx5l6VpJW9/obsfcmtz8jddg4DtFR/2ayXG0u+S/WazUFMx2+N2Esy/PzheI1HvHznBtYUMs2Zl+eUqAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+AVzBUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+AVzBUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894A9C4CED1;
	Wed, 20 Nov 2024 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107533;
	bh=p1swoldLTwGQh3eyx3dn52C5lfRPahhfHVmhpNNBmyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+AVzBUndeJN2r5tljlA2lagL9Gec1GmbWeq4gpawCt33MHUFABk9COmuvF6Ruwg7
	 N3OEkM/5uXNqRjHZSosbpYFs4WIe1+PuJwxgRtAA19iq2RSPthnfA3Oul53IMqffIq
	 IV7IxSeZHCeOI/sEKsU3T07oOcPLZJNfO9ouMc9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 066/107] mptcp: hold pm lock when deleting entry
Date: Wed, 20 Nov 2024 13:56:41 +0100
Message-ID: <20241120125631.164389504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit f642c5c4d528d11bd78b6c6f84f541cd3c0bea86 upstream.

When traversing userspace_pm_local_addr_list and deleting an entry from
it in mptcp_pm_nl_remove_doit(), msk->pm.lock should be held.

This patch holds this lock before mptcp_userspace_pm_lookup_addr_by_id()
and releases it after list_move() in mptcp_pm_nl_remove_doit().

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241112-net-mptcp-misc-6-12-pm-v1-2-b835580cefa8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -325,14 +325,17 @@ int mptcp_pm_nl_remove_doit(struct sk_bu
 
 	lock_sock(sk);
 
+	spin_lock_bh(&msk->pm.lock);
 	match = mptcp_userspace_pm_lookup_addr_by_id(msk, id_val);
 	if (!match) {
 		GENL_SET_ERR_MSG(info, "address with specified id not found");
+		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 		goto out;
 	}
 
 	list_move(&match->list, &free_list);
+	spin_unlock_bh(&msk->pm.lock);
 
 	mptcp_pm_remove_addrs(msk, &free_list);
 


