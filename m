Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E6470107;
	Tue, 21 Jul 2026 19:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660589; cv=none; b=ZZeMZ48uYdujwkmyO59E/lXel+FXjyFYH/bH+/2d0csD3pPFyAYbqPzN3ufdf3KYxqqXTH9KqYxXN5pK4uIwT/24yczwo3+qS3oh2+u9w/3WHZvBy13sYppUo1kCO38ygT3jOot3FvgOgNMpLyrI2TI8fDMz06cTwQySrXnFIHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660589; c=relaxed/simple;
	bh=HZYguS0Gx6PaBQlv+333dU/EEtVhBNUjJHw2BSy2SJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doai+dybYSKqEH6FbbzmTjlsPSe6nOjIQHl4Zpt7E6yMHH0bo9Y909Nd491LKSOdlkuOH8Lm30K0VfNHO1CLj7JWZ21YgNnv+p+UYchD2f1mzjG6b7oEFzmWqDHHNtpeGV6dXEgpSpnaYmY3KiV2ic5IWKhDkyT3HXY0qn6kJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiQl27W1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiQl27W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A181F00A3A;
	Tue, 21 Jul 2026 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660587;
	bh=KHTZGhEtmMi91rDthz1vN2Ha9D+G98AFb0DZdvTQxhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eiQl27W1jDnRLQoAkZjNbIo83QcFTIP3j+ufwN8H8A2q0VsQXsqZjPRf5PLKDa4Be
	 UGp+Rtv/HWVW6LsEnAOG8RCx1QMnZEJHki5f+fMJY74av8ibLUBDVm7Lxaby46ZPfm
	 bqnaouysoGmGqhpXmArUIPUI/ogjNr1Wz4qV/L74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1036/2077] apparmor: fix shadowing of plabel that prevents cache from being updated
Date: Tue, 21 Jul 2026 17:11:49 +0200
Message-ID: <20260721152617.250409993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 4483efe4f21510b30c24bc97d9fd0e8feab94125 ]

Unfortunately the plabel was being shadowed by an unused local var.
This didn't affect the mediation check but did cauase the cache to
not correctly be updated resulting in extra mediation checks.

Fixes: 88fec3526e841 ("apparmor: make sure unix socket labeling is correctly updated.")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_unix.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/security/apparmor/af_unix.c b/security/apparmor/af_unix.c
index fdb4a9f212c3bf..09ce3f6da20ce7 100644
--- a/security/apparmor/af_unix.c
+++ b/security/apparmor/af_unix.c
@@ -758,11 +758,10 @@ int aa_unix_file_perm(const struct cred *subj_cred, struct aa_label *label,
 			   unix_fs_perm(op, request, subj_cred, label,
 					is_unix_fs(peer_sk) ? &peer_path : NULL));
 	} else if (!is_sk_fs) {
-		struct aa_label *plabel;
 		struct aa_sk_ctx *pctx = aa_sock(peer_sk);
 
 		rcu_read_lock();
-		plabel = aa_get_label_rcu(&pctx->label);
+		plabel = aa_get_newest_label(pctx->label);
 		rcu_read_unlock();
 		/* no fs check of aa_unix_peer_perm because conditions above
 		 * ensure they will never be done
-- 
2.53.0



