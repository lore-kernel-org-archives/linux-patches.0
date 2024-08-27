Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045001C8FB0;
	Tue, 27 Aug 2024 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772749; cv=none; b=rfB94xXjPmw7SK4WgfaD5ekAJ6jc6CBMJ9485Gvb4nsF0TDE4mya+P2f8ymyAIN7TK/yG/8rK+k5mBz4KnWuhKK9OllG+5UsRuUrMWpsAVlUR+SEljy/n24dxrqcI3oWrQIuoxBvCpbqInFFKVKFnCNgEXdhmD2B9lU/+EWrJpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772749; c=relaxed/simple;
	bh=j+ESb0S8Fvgu22ucOHlOeEm6ZNjFi5pfXkxDLajVA5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2AAYCK/BoBgajBf0C5bX0PfRXyuDF8rw7zXAM8/I8gxG+WewEGjay5wM3Vl44DaDh+eLN3kQeqtoylwNath4/Wqw24nNBdGp8rwfW6yS0kUrnbvSdvbmxUyDqUKhV3zh3jC2G9W1B4R/MYdNsLlK6riaqncbynzkabv6pByi+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih0UIvzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih0UIvzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5A8C61041;
	Tue, 27 Aug 2024 15:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772748;
	bh=j+ESb0S8Fvgu22ucOHlOeEm6ZNjFi5pfXkxDLajVA5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih0UIvzuzrrmFTh1rMFRzH9xxVdkP+atHdLrgB1V/xX36t0tEFFDc2pO6IkzNvxLR
	 uBd6v2XGaS6Vp8vSrFUDyXT+Nm3b52jfirFwGCMaCPDRMN1a5e8a4ZvvNIYUQ9oPj2
	 4okLcLXlZG9B832DCJ3btgw6H+Wyrb1JE5VOQr/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 276/321] mptcp: pm: re-using ID of unused removed ADD_ADDR
Date: Tue, 27 Aug 2024 16:39:44 +0200
Message-ID: <20240827143848.757846072@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e255683c06df572ead96db5efb5d21be30c0efaa upstream.

If no subflow is attached to the 'signal' endpoint that is being
removed, the addr ID will not be marked as available again.

Mark the linked ID as available when removing the address entry from the
list to cover this case.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-1-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1474,7 +1474,10 @@ static bool mptcp_pm_remove_anno_addr(st
 	ret = remove_anno_list_by_saddr(msk, addr);
 	if (ret || force) {
 		spin_lock_bh(&msk->pm.lock);
-		msk->pm.add_addr_signaled -= ret;
+		if (ret) {
+			__set_bit(addr->id, msk->pm.id_avail_bitmap);
+			msk->pm.add_addr_signaled--;
+		}
 		mptcp_pm_remove_addr(msk, &list);
 		spin_unlock_bh(&msk->pm.lock);
 	}


