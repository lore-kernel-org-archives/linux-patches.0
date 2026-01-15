Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F942C028F;
	Thu, 15 Jan 2026 17:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496603; cv=none; b=Wmsr9WphamLJnJ1hm3036O3/OTj3L/M9nUhK67Taml71QES14oQA3ameVrJkqThKSvQ0y0vtmA6G+372yYBAraLkXwJWLaJov1Qt2cFC2XYfxkZ8CAX5GQDclffFfqhyv421H8876xruvZsF3jaKPwecg5o9LkR7mvak7Li8kKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496603; c=relaxed/simple;
	bh=x4ckkry0keS64/YkmvC4zJvpKUOIUPepB2DfI6l90UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amrJBHLJzd4V/j3Tf6PvVpHwT6zfsWOrPAqHQzhM45FyOhsI8bj5LMaLcU9ZIL3J/u7/QcEp/Y/Hl4aOhvF5g4h/BeZ0sbPN+effDygyH/OLYSLAhce3qXkHcztLjAeg/3rOQvFgmD4Cshr4GsIydmiKwwdKUSirKJcnA5OrMU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqLnUN1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqLnUN1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00072C116D0;
	Thu, 15 Jan 2026 17:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496603;
	bh=x4ckkry0keS64/YkmvC4zJvpKUOIUPepB2DfI6l90UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqLnUN1/9Y+YgdzHAe7LIW6sgTSKq/ADC10FJ2vmJ1EGoqQMFKUkGebt4hJlAnUfn
	 e7/0DQwz1dPJwDHlQ6babLQ1pUFBsoIi1xZZBtcpft5RVVeqmCbe4a/IXtT/O8fARF
	 /Go75fLRL+uxL46/VERV5mffdLxO8YqYUrsd1X88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/119] NFS: Fix up the automount fs_context to use the correct cred
Date: Thu, 15 Jan 2026 17:47:32 +0100
Message-ID: <20260115164153.299809361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a2a8fc27dd668e7562b5326b5ed2f1604cb1e2e9 ]

When automounting, the fs_context should be fixed up to use the cred
from the parent filesystem, since the operation is just extending the
namespace. Authorisation to enter that namespace will already have been
provided by the preceding lookup.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/namespace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 923b5c1eb47e9..99ef1146096fe 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -170,6 +170,11 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	if (!ctx->clone_data.fattr)
 		goto out_fc;
 
+	if (fc->cred != server->cred) {
+		put_cred(fc->cred);
+		fc->cred = get_cred(server->cred);
+	}
+
 	if (fc->net_ns != client->cl_net) {
 		put_net(fc->net_ns);
 		fc->net_ns = get_net(client->cl_net);
-- 
2.51.0



