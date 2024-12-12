Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244472139B2;
	Thu, 12 Dec 2024 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016042; cv=none; b=Qq/knEUib2Ujlroz/B6pK5OXsU//3u/piP1g+GoQJs96VSeQ6K/t5XQ0er/WsshXkCbXFNmQACVSKWkXlUj1KyUDrylac2T3a8S69fvwGT4SxzY9M5NS65+1TqstCCC+hQjLJ6ovXo126oF+k05ZQgy4b3fMiyNN00Wr4iZ54P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016042; c=relaxed/simple;
	bh=GPpK+l7ReW5flqKh9Iyyw9BexN5lENvpS2mA7yMycZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gjv4V5ryKJhHSpiv8kz5YA9N2FDZmdvah4UoyvhlWO2OZXf8Dbh2tCj41by+IkN0w2SnMoC7xGWBHz4Tvdfp7divlQyndGC00PCFmOukcdwnm580L1Jf+YibvracEgFocpaFriBfnlrAGQi7/QdNVNwZmDdE2UvN7f9WtVr/jgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ec6mpF9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ec6mpF9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF30C4CECE;
	Thu, 12 Dec 2024 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016042;
	bh=GPpK+l7ReW5flqKh9Iyyw9BexN5lENvpS2mA7yMycZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ec6mpF9TcivDv5hLHQxvLXhh9niTT97C9sJFkQq6NRQI0ZDjmzavt9FcnhwOS4s2+
	 z82DWGvu6iKoF36ITUJmV2pRGLsKDQFRf85FksYylOOCxx+NTqO0wPs/ZpSQo3v1LX
	 quc5/EfnpmlB5zEPWhafrJx+291ijwboK+ZC0rmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/466] smb: client: fix potential race in cifs_put_tcon()
Date: Thu, 12 Dec 2024 15:54:44 +0100
Message-ID: <20241212144311.359671156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit c32b624fa4f7ca5a2ff217a0b1b2f1352bb4ec11 ]

dfs_cache_refresh() delayed worker could race with cifs_put_tcon(), so
make sure to call list_replace_init() on @tcon->dfs_ses_list after
kworker is cancelled or finished.

Fixes: 4f42a8b54b5c ("smb: client: fix DFS interlink failover")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index a94c538ff8636..feff3324d39c6 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2512,9 +2512,6 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 
 	list_del_init(&tcon->tcon_list);
 	tcon->status = TID_EXITING;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	list_replace_init(&tcon->dfs_ses_list, &ses_list);
-#endif
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -2522,6 +2519,7 @@ cifs_put_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
 	cancel_delayed_work_sync(&tcon->query_interfaces);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cancel_delayed_work_sync(&tcon->dfs_cache_work);
+	list_replace_init(&tcon->dfs_ses_list, &ses_list);
 #endif
 
 	if (tcon->use_witness) {
-- 
2.43.0



