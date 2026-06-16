Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4F331EAB;
	Tue, 16 Jun 2026 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627956; cv=none; b=nftrkS9D7ZXGHZORqG17wwu9JwCEvr/q4p7HFZ6bOgbls/CmMgrpBVTdSWHNrSapyEd95GckSAra/JuxToFk/LqDqWglS4cQUv+SPmiWrZJjJem1cr6GiERX21vPcy6N5YpkgeJBCRTrqqPda7Xz3KrX9AKn3i2ejSGR325TVSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627956; c=relaxed/simple;
	bh=lPWxdJq5sOnoeQtFB8ELMFqnGaCmmlTeJXelN4WNjzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE4NOepbzNPhjgc1uCB5ySfCDSWOmFFFuNHywkKYfffqj3XnmY6+SB50UfTwjWXYJV2ooxd0fTAz22OvAU/7wRSk4EWG1doYmVmInzWrPvGVouH5+uHTByKsN/KyX9A6w1jow4ilVsn/V7csNgvwaRMlQ9OrQcJ2u64SP625J1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/aPOgFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/aPOgFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194BC1F000E9;
	Tue, 16 Jun 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627955;
	bh=itphzukPATok8/UWOhL2pqaHXapcefBq1M7xaNbEUWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/aPOgFhcy1IskroC0BOyuiXMJP5/Qrt5+fF0jaJ9YR06NHR+64xD4wNvLFcQt/CJ
	 E3V9eXQ99++rP2sLa+1bWh0jk8LSWJTCCabi14IVxou1v4xyNPs1Y/HpMQg4aL79aA
	 rkcuvdZr9vNxcZjc8gW8U8+zDTyyg+BUEVmZZzhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/261] mptcp: pm: fix extra_subflows underflow on userspace PM subflow creation
Date: Tue, 16 Jun 2026 20:31:38 +0530
Message-ID: <20260616145057.111743938@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit 14e9fea30b68fc75b2b3d97396a7e6adb544bd2a upstream.

The userspace PM increments extra_subflows after __mptcp_subflow_connect()
succeeds, but __mptcp_subflow_connect() calls mptcp_pm_close_subflow()
on failure to roll back the pre-increment done by the kernel PM's fill_*()
helpers. Because the userspace PM hasn't incremented yet at that point,
this decrement is spurious and causes extra_subflows to underflow.

Fix it by aligning the userspace PM with the kernel PM: increment
extra_subflows before calling __mptcp_subflow_connect(), so the existing
error path in subflow.c correctly rolls it back on failure. Also simplify
the error handling by taking pm.lock only when needed for cleanup.

Fixes: 77e4b94a3de6 ("mptcp: update userspace pm infos")
Cc: stable@vger.kernel.org
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-5-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -402,16 +402,19 @@ int mptcp_pm_nl_subflow_create_doit(stru
 	local.flags = entry.flags;
 	local.ifindex = entry.ifindex;
 
+	spin_lock_bh(&msk->pm.lock);
+	msk->pm.subflows++;
+	spin_unlock_bh(&msk->pm.lock);
+
 	lock_sock(sk);
 	err = __mptcp_subflow_connect(sk, &local, &addr_r);
 	release_sock(sk);
 
-	spin_lock_bh(&msk->pm.lock);
-	if (err)
+	if (err) {
+		spin_lock_bh(&msk->pm.lock);
 		mptcp_userspace_pm_delete_local_addr(msk, &entry);
-	else
-		msk->pm.subflows++;
-	spin_unlock_bh(&msk->pm.lock);
+		spin_unlock_bh(&msk->pm.lock);
+	}
 
  create_err:
 	sock_put(sk);


