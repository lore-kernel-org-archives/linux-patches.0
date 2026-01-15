Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201973C008C;
	Thu, 15 Jan 2026 17:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497158; cv=none; b=UL3PKWzARTMEJNdlwMxiiGnK7cWavOS7S4fFcQTGVIL/M3VZPv+nYxtnJ8kS6VdSGkTdIH81WE3X8W708fXJq3lLoEySRG76bXrKodJkNRfSwrN6yFHwW6ObIbrK9sqfN7g76VHUPcs8D1Gf7SsVOudWMKUKcUXsUytZbIh28oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497158; c=relaxed/simple;
	bh=FZrKhozBTkBdHvFqGAfl5T/v3YdY7N3M5T3g7D+MV1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGaLvIBGiGXdhP8apQ6gO4STPOpUDERC/sABIQNNyXOrUKH6v9t1nzRi9R/fHWvjuONaNdM982RZ7FRQ42vh3ZudQ6bN8p31nL8YrcBDg7K9/fOOXfr+1bXdE1/bGHCAdORgZjRZXjGSsl8p01wGtVId/EEmJoDomFbfzmrPZn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhuHLHj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhuHLHj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84095C2BC86;
	Thu, 15 Jan 2026 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497157;
	bh=FZrKhozBTkBdHvFqGAfl5T/v3YdY7N3M5T3g7D+MV1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhuHLHj5aqW0QukHb50LcUhmM9EoqK9FI8T2BKX8+IcRqigToZquB3gKT5SFug3Do
	 G7+HlTG+LduSJ5XoKSIyJjVqvpcSFP1nNpf2MQFbVQdIVfLS/Ff6Eyld+3GLOk3zHo
	 D5BhQfnZukOZiNBFYc8E/NS1qzcX+cNphZNBwV4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 23/72] NFS: Fix up the automount fs_context to use the correct cred
Date: Thu, 15 Jan 2026 17:48:33 +0100
Message-ID: <20260115164144.337141398@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index 663f1a3f7cc3e..5cbbe59e56234 100644
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



