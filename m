Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59E5374CC;
	Wed,  7 Aug 2024 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043734; cv=none; b=HWMMvYQS4rvm13G904x7jJ7S7MaKF9AC/KtSXfV3zbK5CoMQ4UA6bD+o33bctnnuXSiJEOCbt7wgWGfyM2mxdYbrC2ukZaBmaNmvIRcBzdn8ZVgIOGKsVy5GiUte7VSz+b2RkfsNQRCOTjbNYoGYQEnWVlEzN4w9n2lh/+2x4H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043734; c=relaxed/simple;
	bh=lwc9rINrzZtDjjCjcoSf3+G3pW1N3zvHOrmWZ/wMX/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjdoFV5Bfuex+yce9UiWlKz6jzB/07QJLu2iwvYjxmmonNuILOioJgSV1dsvZ8X1sh3DCmadGaZkhCpjpxAwooGt0f6R1yCsTZ9WI+LnXEYs5sx46s/v5quK0KFVtLccJiUwTdTFO2SpupRcjcugA4f14b8md/M+uw3LnnNukH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjdeLpyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjdeLpyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65296C32781;
	Wed,  7 Aug 2024 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043734;
	bh=lwc9rINrzZtDjjCjcoSf3+G3pW1N3zvHOrmWZ/wMX/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjdeLpyZEZHTBU/OmtejL2FRi67C1wrKlcGKnAO2xf6eufkhTWb2a3F+7HrgPBMy+
	 tSAs0UD8ztoxEcFUNZw3qiLF3ohL+zNLc3hMvp8qHPUTNtet9xx+2COEoanhdj0Pav
	 xFMTfsVrw6YWmAm3qiEnBpoP/dPgH/KErvFYX960=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 80/86] mptcp: fix user-space PM announced address accounting
Date: Wed,  7 Aug 2024 17:00:59 +0200
Message-ID: <20240807150041.938437216@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1578,16 +1578,25 @@ void mptcp_pm_remove_addrs(struct mptcp_
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


