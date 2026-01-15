Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE923E959C;
	Thu, 15 Jan 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500012; cv=none; b=ZMEXECzlScioeLk+mu+dkurLgbtaE2F1YD6rGWpmgsR5GgcwSMG5z0epExvI/WlI0RISArIm6YaNPyaGkEvOip3xy79o/cifuGCFe+uxrqALoTQ498mkv9KZoBRmCrNUFjuVlLXPDcLlb4YK/UYS+i39cPy+Ws6yM40yaMR/DoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500012; c=relaxed/simple;
	bh=hFXFXwrwxN3E6ob0SAKZ+ZXq/AS9gDlW+p5YyTK8Wks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOtWReyEOLi+iy7doTymN1uwzWKIOkfVbpNI++9xUOsGuziR/fctJ6tstaVbXJurEiIHEsJKmsJb76LuIU3hytPFsDNvuLDUUeAUYYwXIKbvgJz9cQzV56gMO1F9VOweDWzu9wLnsu6W3Ija8NDYQykUZ4K7TQVRbCdf8NnWpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BM5JeuHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BM5JeuHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6C4C116D0;
	Thu, 15 Jan 2026 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500012;
	bh=hFXFXwrwxN3E6ob0SAKZ+ZXq/AS9gDlW+p5YyTK8Wks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BM5JeuHZ2qMOsbG8J6aGRgWoONH18oahKSpsR28bbhVk5MVBNexPUC8rDV3ekdu0Q
	 1f5+H1LX3wFOPKCrJxr8G4W1pNAL1vhBMHe16M57fOxch64w1kv3CAl0ptDwl6pkam
	 sAItjPKhChLyiRJ+MGIHVedyKKBWDyrRv2PbPcoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/451] NFS: Fix up the automount fs_context to use the correct cred
Date: Thu, 15 Jan 2026 17:50:29 +0100
Message-ID: <20260115164246.423636546@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d205598cdc457..fc9f7b9cbf53b 100644
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



