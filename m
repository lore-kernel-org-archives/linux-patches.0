Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569FF2D787;
	Fri, 24 Nov 2023 18:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J8IhzFwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD96C433C8;
	Fri, 24 Nov 2023 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851424;
	bh=cBxWFi9W6DRgDrWHgWxC3F7eQCvSfGcv5H3e9SoZ9U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8IhzFwi3/xcMja/ZcIHjJ9w0/z8zcGIesCdXP+FIgKwcGIhQWRiGvtlWzaxudg1z
	 ujT+r+5gwTvz9LGEfU08VvCc5P1iD4lMblPnlxmnp5yVnhtR0vD4Bk2Fcj88kJ+Yze
	 VyF6/7xpyjPAmISxNJO7v9KZXsuOqjIHlKuMEGk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Matthieu Baerts <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.5 443/491] mptcp: add validity check for sending RM_ADDR
Date: Fri, 24 Nov 2023 17:51:19 +0000
Message-ID: <20231124172037.920105725@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 8df220b29282e8b450ea57be62e1eccd4996837c upstream.

This patch adds the validity check for sending RM_ADDRs for userspace PM
in mptcp_pm_remove_addrs(), only send a RM_ADDR when the address is in the
anno_list or conn_list.

Fixes: 8b1c94da1e48 ("mptcp: only send RM_ADDR in nl_cmd_remove")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20231114-upstream-net-20231113-mptcp-misc-fixes-6-7-rc2-v1-3-7b9cd6a7b7f4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1537,8 +1537,9 @@ void mptcp_pm_remove_addrs(struct mptcp_
 	struct mptcp_pm_addr_entry *entry;
 
 	list_for_each_entry(entry, rm_list, list) {
-		remove_anno_list_by_saddr(msk, &entry->addr);
-		if (alist.nr < MPTCP_RM_IDS_MAX)
+		if ((remove_anno_list_by_saddr(msk, &entry->addr) ||
+		     lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) &&
+		    alist.nr < MPTCP_RM_IDS_MAX)
 			alist.ids[alist.nr++] = entry->addr.id;
 	}
 


