Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41B32D238A;
	Thu, 15 Jan 2026 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496841; cv=none; b=NT8vWT25EirFPxBULglr8vjbReI/17pw0Ot7MLgEwn9JxzYvEP8zHvKrCNGeFQbqB+uUCE6cdQ2kBEffp2b9+fiSEE0wmnmeX1V+AYPTaRiYI77E0AWxUPzDr6mLMs6Vz2Mwd46ULb/+erMXPpY7Np6lL+nBBYm6K3J5IfuX1yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496841; c=relaxed/simple;
	bh=gJ4vDONHW44ykY/zdv+vUyA3i2C68NQfvOghd7ubZHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+uiPo2RokTkcgPSr/kXBIWmiZtGq1GFSfgqJsivKY/MtFYzQWheQ0JDV2GF7fy5kxSAsvHGfpCqqt7lRGvPL41FQesJSyh4kvj/LvHMVgA96Wzh9JRK11eGgfPBdNzAWu6DY1WvIEZxQinswAXUj+VbxZSS8HQrwM/0lLtdnDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0GKrf71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0GKrf71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3738AC116D0;
	Thu, 15 Jan 2026 17:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496841;
	bh=gJ4vDONHW44ykY/zdv+vUyA3i2C68NQfvOghd7ubZHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0GKrf71EEObfRQEKDkaZCBYb6lpX/wzi6r9GIcdv0pwgRpJ5QwGXxa1exGengn3M
	 bvaW6fyEeQg7NFq337QPglBqoRnUwObGAgyNiztQ6nJp+rPcixx5iCwhTgd1lkXaj4
	 FZHJYXIP6b0pQ1dcW9ZOhQCbeLSl/O/Rm3hVQpFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/88] NFS: Fix up the automount fs_context to use the correct cred
Date: Thu, 15 Jan 2026 17:48:16 +0100
Message-ID: <20260115164147.510908758@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



