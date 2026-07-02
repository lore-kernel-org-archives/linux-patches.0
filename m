Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA48A33F5B8;
	Thu,  2 Jul 2026 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010163; cv=none; b=u4yz8wpZ1hqChP7CVWfATre8RmmR3Gxo69QiBAF9/JDfq00DJQsK4QbdeosWFiTDObhDZAtYUKik5eo6gGXmbBUaaTWoFh4jB2h+aBZ7PNGiStbKHKvqJyf9Vt4qq/7pk12k6if5NzuEMvRPgniFmeI9q4D1ZO8zSfOh7efXAMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010163; c=relaxed/simple;
	bh=Q1+CXadbRm+eQd1HuS7imxNtfBRZ0ZjocNxkZgXSpqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1o/eVGFZYI7ImHxy3IXKcwCQQnR3yZBhrpYkl8T803r35F1sOvw4AgKLROxJavTQOD7odTaD3EII0A6kEKeHJfpsvD6INdmlylDxVVBbnYp8aCGwywPeYjPCgEZzdL4jNngVNsc1agLXZxFofMMlHiNtv8mLwQ86SJcIU6ezks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USbCk82c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USbCk82c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5AE1F000E9;
	Thu,  2 Jul 2026 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010161;
	bh=RxRKQyKC+LwS4W3rVnNZtYxyW9RTbG/BAOFjCAtbkl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USbCk82cihnnoywJvDkPC5XRL9sx5KZIzNKOfPVPWM+alGVTaufG7WHUmAde4bG3K
	 OWT/BnESMJZgLIWhlWI8HuNGoLUFOKznO2kOm/4e+bfo7RUvmAUbNcFRfUM6uz6Z6P
	 ofQY9v0wFiSkd4gR5ZeCLJD1bRyUJl5MG9s3RFtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/129] mptcp: pm: fix extra_subflows underflow on userspace PM subflow creation
Date: Thu,  2 Jul 2026 18:20:31 +0200
Message-ID: <20260702155114.460759364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 14e9fea30b68fc75b2b3d97396a7e6adb544bd2a ]

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
@@ -410,18 +410,21 @@ int mptcp_nl_cmd_sf_create(struct sk_buf
 		goto create_err;
 	}
 
+	spin_lock_bh(&msk->pm.lock);
+	msk->pm.subflows++;
+	spin_unlock_bh(&msk->pm.lock);
+
 	lock_sock(sk);
 
 	err = __mptcp_subflow_connect(sk, &addr_l, &addr_r);
 
 	release_sock(sk);
 
-	spin_lock_bh(&msk->pm.lock);
-	if (err)
+	if (err) {
+		spin_lock_bh(&msk->pm.lock);
 		mptcp_userspace_pm_delete_local_addr(msk, &local);
-	else
-		msk->pm.subflows++;
-	spin_unlock_bh(&msk->pm.lock);
+		spin_unlock_bh(&msk->pm.lock);
+	}
 
  create_err:
 	sock_put((struct sock *)msk);


