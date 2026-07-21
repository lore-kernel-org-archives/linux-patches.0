Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6A947125D;
	Tue, 21 Jul 2026 18:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657429; cv=none; b=JAfM5vhoPLLVDbsYy+MxB745F7azjBwzs0EWpfFJpPXRA72FLoIPVio0ANzZuoOJbLSis1KaoYMb6yAp3yNczXKXvqOaWHqylWqgAMbbH4HJDCGeCXP/THYUtmMV9aQiY3TbJNzr/Vzavv0iuv865eI5x7spvB0j+CQo+okna1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657429; c=relaxed/simple;
	bh=0bRN41R/h6wyjDVJwkJYn9Nm59Dbb/ywmiDxvueMvCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZUHAu6me1KGMufUg7Kh5QrNY+d9+tJZZUVf9X4lwOf+olco0kvRPR9EybEH4e4r43ZWacMxQ97Tdu+MyoYf6F38QsoZ/n1W6e2NFPgLgy+hagRVlPO6optci34Ju6dpJELiaOGTMoDKAPQg33muSYONgsa4Qg+EpGmPVhoENUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv+FwijN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv+FwijN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65F61F000E9;
	Tue, 21 Jul 2026 18:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657428;
	bh=f1Xq1PCu9oleKNs60AtSRoQzczbSJztjNzepqow8V9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sv+FwijNtmhIaEbl0h1M2RKX30l3Nyjhqxc7ij6zS16IDqRHX7ydEfbMw8NysB5YE
	 feld+RL2ZdvHlLMMI8OLZB0VsykOH8k2LspXsi5zzUcYjs944/QrSN4fsuRbcMFThj
	 +b29Bk5JyQQ17mtaVLy796F7iKKf2hduecJqceBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Lee <ryan.lee@canonical.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0744/1611] apparmor: Fix return in ns_mkdir_op
Date: Tue, 21 Jul 2026 17:14:20 +0200
Message-ID: <20260721152532.110251768@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit b7a2b49bba4e5994a476c49d662b796818079e5e ]

Return NULL instead of passing to ERR_PTR while error is zero.
  Fixes smatch warning:
    - security/apparmor/apparmorfs.c:1846 ns_mkdir_op() warn:
      passing zero to 'ERR_PTR'

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Reviewed-by: Ryan Lee <ryan.lee@canonical.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 11a92680dcc1a5..515cc80064c600 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1977,7 +1977,7 @@ static struct dentry *ns_mkdir_op(struct mnt_idmap *idmap, struct inode *dir,
 	mutex_unlock(&parent->lock);
 	aa_put_ns(parent);
 
-	return ERR_PTR(error);
+	return error ? ERR_PTR(error) : NULL;
 }
 
 static int ns_rmdir_op(struct inode *dir, struct dentry *dentry)
-- 
2.53.0



