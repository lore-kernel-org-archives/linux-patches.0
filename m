Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8FD1A3178;
	Thu, 17 Apr 2025 18:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913542; cv=none; b=R/fclfmGArcsByR9aCJC65wZNm8IM5zHBC/BqZX4UXQG1Wo2rFoIP3CL6mjQOiuCU0eNxI8MGzAt61iwqkijELFHTW3MHGWKcL6WhRp+gQWVaJuPX9C7E2JqV0X+vNVPz2FLBwY8U03ZoMMqsyUpSdUNUJWrPSQ8UlFmMPdyWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913542; c=relaxed/simple;
	bh=oaESsoLqbDooQK8g0NEn8KQ3x2X+2qgrsA2vcI2ObbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acUajWUHwP50+TCQ7yffSBvQhCxOtXCwhXwiooBcBtSJN7VVL0s+fdvGbPXoNtWhMan5ksi5DIDCYE52VlkuYSdOLbsn3Tlh68k/V7jIYs28Z8RibSKA6ItrW84N+o9EFxDm4Vmb5Un5wwNNnX4HcaXFT046lw6vpyyv8lXN0jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hg1xXGJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hg1xXGJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5FEC4CEE7;
	Thu, 17 Apr 2025 18:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913542;
	bh=oaESsoLqbDooQK8g0NEn8KQ3x2X+2qgrsA2vcI2ObbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hg1xXGJlsc5W2e2hVYOkBD0eMdVkKIy9D8mgHad73oUtf2vl8U9raYn5vZ9SKrTbL
	 a4Y5OtNUZVBQvsgvXvZfTJe62WK98EHA1H3URoRXIAkdqNSOeLKTdvIDKVQA88QRRl
	 DqjtzMEheXBiUr4R4stD5m1IODtOBRqsybPdy154=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aman <aman1@microsoft.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.14 374/449] CIFS: Propagate min offload along with other parameters from primary to secondary channels.
Date: Thu, 17 Apr 2025 19:51:02 +0200
Message-ID: <20250417175133.310532608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1677,6 +1677,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
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


