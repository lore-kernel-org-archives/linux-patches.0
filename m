Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8240B1DFD89;
	Fri,  6 Dec 2024 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497771; cv=none; b=dsmIrYHfUChhCr6iQAiCNC62J45xqRgya7q7GhVAx0WsExZ1qa6YV8DDQbLphF3KkQuF/6TbtjbtFE+ldSKcRGU15PYBkRGDD99ZAtwF1MliVYSTMfOG624KBI9G4aNTu5fycbXU5h4UykcGUWeEfvoDQOXsR1yO76ny7TyKKKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497771; c=relaxed/simple;
	bh=0n/Xgn8uDhps3cR1k0xVNVgclFhBU0+DFu+lVRuQCJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKllhKGkxUk5LZ96N2ylQDRneF7w4o0QhVric6V/ce+Zaqx6xe3wGuwdHyRtcN0ZBiJYLKjGHkfHCZZ8ZYBMx0uYx1f01H7osD2mWM4LSbg9yQVw+V0XNhPiQXIXG8ai3dS5WAGaqL3wAkZgOk5TMnB6f4/YYx4Ti/xXCXzFDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z13p1Le7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z13p1Le7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D799EC4CED1;
	Fri,  6 Dec 2024 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497771;
	bh=0n/Xgn8uDhps3cR1k0xVNVgclFhBU0+DFu+lVRuQCJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z13p1Le7oYGC+ZZuo74fjY0OIPed6OHcH3ioA7gHaYrr9tToXD6VoR60wVbmfO378
	 pvD+bV8JG+knv9KOx10B6zTdLz7GXwGBYoukriCKhzN9oRaSo0x54xrov/CnoSg1iY
	 hRNRmOclZkEW6wppXWhS6LvsTRPM+5nkwq7iR52M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 381/676] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Fri,  6 Dec 2024 15:33:20 +0100
Message-ID: <20241206143708.228812953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 1e02c641c3a43c88cecc08402000418e15578d38 ]

@ses is initialized to NULL. If __nfsd4_find_backchannel() finds no
available backchannel session, setup_callback_client() will try to
dereference @ses and segfault.

Fixes: dcbeaa68dbbd ("nfsd4: allow backchannel recovery")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4callback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4callback.c b/fs/nfsd/nfs4callback.c
index 4039ffcf90ba5..bc2716c1bdeab 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1379,6 +1379,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



