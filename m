Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3381826463B;
	Thu, 17 Apr 2025 18:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914870; cv=none; b=k/xzP5nfpEbw/SB82PAavvsk++z0UEvgq8n3kHarUhXEqaIASzPqJxsU/tI07ZquX3fPS7PafuYwBRCgaoWG9rPSvDUYa6L5hqXl7grLreJQOTieO4bvphHGvcTSzh2olu9HjDZTW86fP/NMTrjN32tUNXVA0NBcrlxOg7BBHy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914870; c=relaxed/simple;
	bh=wY6BN8SRTKBl1OvNt2711Bs1Sh53/Jbz9n8Fz4CPPBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj7K1kABN/fiTTK1RsqbsOZVdg4yXyXPTVe8p7MdhCutji/8kbRyFNASysPVkpmGKqFVAifKDRS8mcv62mwtf8EoxJhrIyqiG02Fkuzr63+RkBdWJFUNWl2Yv7inEabem/ChAuYnuB5mPcGVe5iqsadlLpECFe6dVS7Nj+cVmXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pG4fHKAJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pG4fHKAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F4AC4CEE4;
	Thu, 17 Apr 2025 18:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914870;
	bh=wY6BN8SRTKBl1OvNt2711Bs1Sh53/Jbz9n8Fz4CPPBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pG4fHKAJSkrzdIH4TJO9/Ou5+x7oLMLaESxZJvmB/7k1IFI+ZjmR062sC3dGDbXJG
	 hGrHXHIJjBo+aPQj3S3tAznIZaBl5H88s2E79AGxzWSERAr396WGz3a+GV6AlbF3EK
	 XweAZJImMBsBA5wYqE2iUuLdD88lFKLYRbbOI0cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aman <aman1@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 340/414] CIFS: Propagate min offload along with other parameters from primary to secondary channels.
Date: Thu, 17 Apr 2025 19:51:38 +0200
Message-ID: <20250417175125.106286783@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aman <aman1@microsoft.com>

commit 1821e90be08e7d4a54cd167dd818d80d06e064e9 upstream.

In a multichannel setup, it was observed that a few fields were not being
copied over to the secondary channels, which impacted performance in cases
where these options were relevant but not properly synchronized. To address
this, this patch introduces copying the following parameters from the
primary channel to the secondary channels:

- min_offload
- compression.requested
- dfs_conn
- ignore_signature
- leaf_fullpath
- noblockcnt
- retrans
- sign

By copying these parameters, we ensure consistency across channels and
prevent performance degradation due to missing or outdated settings.

Cc: stable@vger.kernel.org
Signed-off-by: Aman <aman1@microsoft.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 fs/smb/client/sess.c    |    7 +++++++
 2 files changed, 8 insertions(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1722,6 +1722,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
 	/* Grab netns reference for this server. */
 	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
 
+	tcp_ses->sign = ctx->sign;
 	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
 	tcp_ses->noblockcnt = ctx->rootfs;
 	tcp_ses->noblocksnd = ctx->noblocksnd || ctx->rootfs;
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -522,6 +522,13 @@ cifs_ses_add_channel(struct cifs_ses *se
 	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
 	ctx->echo_interval = ses->server->echo_interval / HZ;
 	ctx->max_credits = ses->server->max_credits;
+	ctx->min_offload = ses->server->min_offload;
+	ctx->compress = ses->server->compression.requested;
+	ctx->dfs_conn = ses->server->dfs_conn;
+	ctx->ignore_signature = ses->server->ignore_signature;
+	ctx->leaf_fullpath = ses->server->leaf_fullpath;
+	ctx->rootfs = ses->server->noblockcnt;
+	ctx->retrans = ses->server->retrans;
 
 	/*
 	 * This will be used for encoding/decoding user/domain/pw


