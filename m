Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463572FF641;
	Mon, 13 Oct 2025 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368443; cv=none; b=eJjA87dkiKG9BzMdr7UcnflnpgLYKAGJ7twQUxWnGyPlYkwCRBHRcK4idYI/glBzyNdk73DiZ2rGSyJbE02mH0ocCXGdeAVO5e36kgQ8mbWxV99f2wY3DcAAlVeZiBXbXNNu5miYF/M2YHSMPLBozF0AmpP4QT8OztUeTjDl8Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368443; c=relaxed/simple;
	bh=Jf1BS8nHnjoo5U+q15tNDlW7uFXJ7ZDf/lzRQrTg/QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJNmSp2DQTzL6iN3cbV45DekU9a20fbmFy/6BuTccQ1KH9Ieezne9owYlQnSopLKou3Aoq+2YJH9DepOAW3Lsy7JVtRbU0OPSg3EfaUJxB8bTil+Z2Zst+VdGLRXzF94HWSBSfKpI8f5BGxFcC9hgs8gQF71GazsVqAsaaKVVqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfxNgQVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfxNgQVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8949EC4CEE7;
	Mon, 13 Oct 2025 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368442;
	bh=Jf1BS8nHnjoo5U+q15tNDlW7uFXJ7ZDf/lzRQrTg/QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfxNgQVr6vjiqD4/LgPMFzFtOkR0Bks//IZ1VA+oLAi+UP0JkrTyFcxRmLARAnWgP
	 mbuGpnX8SO+7YX53mQwXz73yn/cY9KMmmxsHXtbWalRekitJwe12jpK9Him/h4n6vV
	 nYW8p8jmraIGYGqu4bim+Vu4mhYQv0odm8AGHjYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/262] IB/sa: Fix sa_local_svc_timeout_ms read race
Date: Mon, 13 Oct 2025 16:45:05 +0200
Message-ID: <20251013144331.993680012@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Vlad Dumitrescu <vdumitrescu@nvidia.com>

[ Upstream commit 1428cd764cd708d53a072a2f208d87014bfe05bc ]

When computing the delta, the sa_local_svc_timeout_ms is read without
ib_nl_request_lock held. Though unlikely in practice, this can cause
a race condition if multiple local service threads are managing the
timeout.

Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20250916163112.98414-1-edwards@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sa_query.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 53571e6b3162c..66df5bed6a562 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1013,6 +1013,8 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
 		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MAX;
 
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+
 	delta = timeout - sa_local_svc_timeout_ms;
 	if (delta < 0)
 		abs_delta = -delta;
@@ -1020,7 +1022,6 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		abs_delta = delta;
 
 	if (delta != 0) {
-		spin_lock_irqsave(&ib_nl_request_lock, flags);
 		sa_local_svc_timeout_ms = timeout;
 		list_for_each_entry(query, &ib_nl_request_list, list) {
 			if (delta < 0 && abs_delta > query->timeout)
@@ -1038,9 +1039,10 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 		if (delay)
 			mod_delayed_work(ib_nl_wq, &ib_nl_timed_work,
 					 (unsigned long)delay);
-		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 	}
 
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
 settimeout_out:
 	return 0;
 }
-- 
2.51.0



