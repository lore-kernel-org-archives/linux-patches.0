Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CB3415F23;
	Tue, 21 Jul 2026 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657357; cv=none; b=PxJ08kYDyYLMfonV7su0X/T8KvKhQNB9I0lhhYLvbdAr958fdT9+0S3idM3BatnOxYGa82mUb5CoU6bNMA6QZOHdlR3tC8SlJL2x/+OnF7rods+PlCle4yR+dahNuBnGr1WARjZ/EGyJO+Xr7i/QFtk6m6YuqVTlAzSjELZX74k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657357; c=relaxed/simple;
	bh=BXuTtZWhP+vPjGkVM9EIZ7tu8+PyNrsv/eifMnpR8is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=As9WadB48fLLMuVLF7Z1N+cFMxXISblL90YMWUiVLKNOcYXIBYESl/T94z4DlDOfp0XKJIUDEHzo3VG7vXyAecMDctrFEwNf8evHvuIpZxDVsTL21NMrMO2JXpT44JPv+aNnZmFLIzgsL91QMW8a3B1dD28zxTUj+sAIJgqpCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RM/Y5UwT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RM/Y5UwT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174E31F00A3A;
	Tue, 21 Jul 2026 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657356;
	bh=uF1hZ/tZYZwYly4vbeHgneGycrJyA1LnX4627YbPLnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RM/Y5UwT+4FHF0AJpS7dYyW7aMk5vfvtT2knEyGdKhemRS9WpUpoXFyv50/sGRjKP
	 Ffan2e2nDnO8XVxI0rPreeQeZrStnwawrqVCzUYNjUktT4I9NR4S0EvOYLfjjRcKpC
	 4K8rTdOKgatOTTgjFl1A+EsJNxD03KpGJcu5y1ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0733/1611] apparmor: fix shadowing of plabel that prevents cache from being updated
Date: Tue, 21 Jul 2026 17:14:09 +0200
Message-ID: <20260721152531.867700998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac0f4be791ecea..7757829188d603 100644
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



