Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F376F84A35;
	Wed,  7 Aug 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043157; cv=none; b=IcepbJDbpu2cy11TZl0ACX6z6/7shHycaCKFaYTp3mpavL4yHBXMnmXCBY58lpqn9tGCLTuu6z8VkZtlG7Bk5gpDFRHeexYF8TI9iK0DEwsIdp+w+1CX4Cf2B1ppMd7OI1zDt/b9hlMNT9FRK7+ICzbISHCTh+7j12J+eux29Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043157; c=relaxed/simple;
	bh=zhcvfSVizD3uRsx77CXFGxWR6BG2ukbyitvKpnWWHX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+xcMRO6Zj+VaALNdmyOBXMGdufizezUkUWt2NYHpMVMAdwMvezRafugIWIkO8AQva8xpSzK8VdMxnUs7rhf1PtjzADG6yyhkoJQRpU4AAVhHKrSIysSxhaudqc6eoDfAWSKC0tvSqGn/0evDBL3HBSE4U0OmEsrvEP/L4wxi0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm7kCSIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm7kCSIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FCBC32781;
	Wed,  7 Aug 2024 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043156;
	bh=zhcvfSVizD3uRsx77CXFGxWR6BG2ukbyitvKpnWWHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm7kCSIJu+mutGN9jS1kB4LR0C0LwGDsIQY5SIpGA8upWFpcra4atOnC1Fs8i2hzn
	 ZuYcQ+hm3WP2isUU8wmxA37z5IGXPQPam5r4kLnx4XXFriHllD9VHxBY6kbJnypXL0
	 qr6v4DL+raoGHJgNFYl9/5WDHDDOQV5LCXAAybQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 112/123] mptcp: fix user-space PM announced address accounting
Date: Wed,  7 Aug 2024 17:00:31 +0200
Message-ID: <20240807150024.495539592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 167b93258d1e2230ee3e8a97669b4db4cc9e90aa upstream.

Currently the per-connection announced address counter is never
decreased. When the user-space PM is in use, this just affect
the information exposed via diag/sockopt, but it could still foul
the PM to wrong decision.

Add the missing accounting for the user-space PM's sake.

Fixes: 8b1c94da1e48 ("mptcp: only send RM_ADDR in nl_cmd_remove")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1534,16 +1534,25 @@ void mptcp_pm_remove_addrs(struct mptcp_
 {
 	struct mptcp_rm_list alist = { .nr = 0 };
 	struct mptcp_pm_addr_entry *entry;
+	int anno_nr = 0;
 
 	list_for_each_entry(entry, rm_list, list) {
-		if ((remove_anno_list_by_saddr(msk, &entry->addr) ||
-		     lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) &&
-		    alist.nr < MPTCP_RM_IDS_MAX)
-			alist.ids[alist.nr++] = entry->addr.id;
+		if (alist.nr >= MPTCP_RM_IDS_MAX)
+			break;
+
+		/* only delete if either announced or matching a subflow */
+		if (remove_anno_list_by_saddr(msk, &entry->addr))
+			anno_nr++;
+		else if (!lookup_subflow_by_saddr(&msk->conn_list,
+						  &entry->addr))
+			continue;
+
+		alist.ids[alist.nr++] = entry->addr.id;
 	}
 
 	if (alist.nr) {
 		spin_lock_bh(&msk->pm.lock);
+		msk->pm.add_addr_signaled -= anno_nr;
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}


