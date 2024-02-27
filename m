Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADAA13B797;
	Tue, 27 Feb 2024 13:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041926; cv=none; b=Woa9mOelGCGZaTCMYJphRvNF1wgix2wrRJcS2HTGbnqbNYuOrqoc6DgmaGEScOCif48lzu4ya5co6kc9iBoLDH/4Y3q/uSwgVK2HksDCkd5ka1pKzumMlTN8cj5oIRQHtmwX+pOCqH2WYQDi6BBxWT0fXBurfg8Mu2cKm3zPjvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041926; c=relaxed/simple;
	bh=d5DAqzYxdc2sD+cwmRkqXq2lsFLihmZGBnKPwTbEkE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFy82n1wAOizwfVUvKnI12cWL6d1WDqsd2+zrD00HAjWyla8irfWHanc8GOQ4Uz+/4y1M+axBK32Zhj2kt5E4vKYFu062BwZg273aNNxQ5tTWRAqqAyrTfAj2qGivpbsTyaz2XnaHHPUNFfUeUnfgcYLce3QC/WE+V5Rh5eoZ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM7ysjwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM7ysjwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CD0C43394;
	Tue, 27 Feb 2024 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041926;
	bh=d5DAqzYxdc2sD+cwmRkqXq2lsFLihmZGBnKPwTbEkE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gM7ysjwY9IrAbIY2AU1LLH2AVAYVCyIWjDCNUTknF33045Tq9tKdo73ki0hDX0w1x
	 z0ctuBRRnAansc+g07cK0PEybIBI4Mi3z8/nT/JOT/vlFHW4KzgkG9eVWTWK61TT3V
	 lFkMI04Tb1IejYdXkIM5cyxrCYjrHKjYH5BXi8hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/299] cifs: change tcon status when need_reconnect is set on it
Date: Tue, 27 Feb 2024 14:23:48 +0100
Message-ID: <20240227131629.629456915@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit c6e02eefd6ace3da3369c764f15429f5647056af ]

When a tcon is marked for need_reconnect, the intention
is to have it reconnected.

This change adjusts tcon->status in cifs_tree_connect
when need_reconnect is set. Also, this change has a minor
correction in resetting need_reconnect on success. It makes
sure that it is done with tc_lock held.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 5 +++++
 fs/smb/client/dfs.c     | 7 ++++++-
 fs/smb/client/file.c    | 3 +++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 19440255944b0..c19eae07fa69a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4226,6 +4226,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index a8a1d386da656..449c59830039b 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -565,6 +565,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+
+	/* if tcon is marked for needing reconnect, update state */
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_TCON;
+
 	if (tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
@@ -625,8 +630,8 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
 			tcon->status = TID_GOOD;
-		spin_unlock(&tcon->tc_lock);
 		tcon->need_reconnect = false;
+		spin_unlock(&tcon->tc_lock);
 	}
 
 	return rc;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 32a8525415d96..4cbb5487bd8d0 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -175,6 +175,9 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+	if (tcon->need_reconnect)
+		tcon->status = TID_NEED_RECON;
+
 	if (tcon->status != TID_NEED_RECON) {
 		spin_unlock(&tcon->tc_lock);
 		return;
-- 
2.43.0



