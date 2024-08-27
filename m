Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F741C7B67;
	Tue, 27 Aug 2024 15:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771660; cv=none; b=mUAhXixOcBvPHNBe9v8Bqle3UFdcLNc4BR+3+d5XpL9EEnZAPhFaWfve2v67OYJDVF3s5O3+6bzfj7Kp09DQ3ULDcfnZbfe9HKfqnyCiudf83Akd0zX32Db8p3ue1DH097fB3Cbl2U5rrLXoB94SSnB71Tou+QYR1S0tbybE9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771660; c=relaxed/simple;
	bh=SG0p9F0Qs0z39m5S/pcOQ6wg3ok5eYs+5mCzJTIkQhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBqpSt585KSth4srjFIsRtQHM5MHwMOsG6pGTz8Db1kgs9aCVqRhodXY8BiyDsdBwSlR9M6Y/CNfPQOfOF5aoKiHiQT0DVKf7jbXUcAs0GdG5GbI90WYBgnNfJ2Ayl0LBkYUu2ATWFYVB2y+9anUKy4S1nGI4upUPB0HImx5eXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTETuWK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTETuWK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F148C4AF09;
	Tue, 27 Aug 2024 15:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771660;
	bh=SG0p9F0Qs0z39m5S/pcOQ6wg3ok5eYs+5mCzJTIkQhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTETuWK5ZADG8RxQSi1vNnIovPUbWDxoQCmqrnopBiVxDrif7A6IagECgAJSwA4NF
	 Z7aZ/oQcM9/FwbltpYqeYRcsf/RcdsHZJbGH56CRBl+IOowrmZ7CrQ7e4Q7H7NXPWt
	 /AJJLidxlka40gW7QnDyXYddBx9h3dTLRs2Dj71Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 255/273] mptcp: pm: re-using ID of unused removed ADD_ADDR
Date: Tue, 27 Aug 2024 16:39:39 +0200
Message-ID: <20240827143843.104709435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
@@ -1431,7 +1431,10 @@ static bool mptcp_pm_remove_anno_addr(st
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


