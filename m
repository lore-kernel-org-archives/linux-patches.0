Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9FF22579E;
	Wed, 25 Feb 2026 01:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983356; cv=none; b=tYgebuWrouZv4ctOGu2rV6O1Erbg/22Ix0kRmZLV9IZiD68CcY+wsoqP5HpcbEupZDbJewTUmFKiDJV/RDl7Z7UBDfEhYunXuqWc4Yv3p1O03V7eeH7yDsbazQJbdVNpn7RNpu8/sxWvh0XSwzUNMTEYRaG5dnXj+xNGn0qVeZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983356; c=relaxed/simple;
	bh=MZthmK2BG50nzExvishTXwQIkPU9/JCp4lAOS591RUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/y6MIBzCYByYJsnLarEXRFApvNT1aXFdXt0M+aAoy+NlIKAJJWsMWdCFyrLCr23J1zr41po6Hg6XL8hHi7oFoDe5lx8fnsPB+Wj9uL3TzYRAaBTXcH2UFvBznAMN3iepjDI4HjRx0wUmN0jJbZmDyqGG/4c39uWfjBUxNVMdF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xwrFEpjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xwrFEpjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E99DC116D0;
	Wed, 25 Feb 2026 01:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983355;
	bh=MZthmK2BG50nzExvishTXwQIkPU9/JCp4lAOS591RUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xwrFEpjnEKQyAWt7C++VsHQcTOS3HWLpJ6XSGHckkE7ZdF4Ox13gccbAhgYygddUs
	 SGEeP8ggflYZzrbwpTbS8pWygcq+Bo61F9DS8aHwCnjoe6aBwL7J9y/2tF7bt+6Lx3
	 hLuAzJSTvEHjiD95483mIAIctwrlv1dP1AFah9Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 480/781] NFS/localio: remove -EAGAIN handling in nfs_local_doio()
Date: Tue, 24 Feb 2026 17:19:49 -0800
Message-ID: <20260225012411.588210160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit e72a73957613653f50375db1f3a3fbb907a9c40b ]

Handling -EAGAIN in nfs_local_doio() was introduced with commit
0978e5b85fc08 (nfs_do_local_{read,write} were made to have negative
checks for correspoding iter method) but commit e43e9a3a3d66
since eliminated the possibility for this -EAGAIN early return.

So remove nfs_local_doio()'s -EAGAIN handling that calls
nfs_localio_disable_client() -- while it should never happen from
nfs_do_local_{read,write} this particular -EAGAIN handling is now
"dead" and so it has become a liability.

Fixes: e43e9a3a3d66 ("nfs/localio: refactor iocb initialization")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index f553ac0e1d86e..3bd4f28c8afc2 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -989,8 +989,6 @@ int nfs_local_doio(struct nfs_client *clp, struct nfsd_file *localio,
 	}
 
 	if (status != 0) {
-		if (status == -EAGAIN)
-			nfs_localio_disable_client(clp);
 		nfs_local_iocb_release(iocb);
 		hdr->task.tk_status = status;
 		nfs_local_hdr_release(hdr, call_ops);
-- 
2.51.0



