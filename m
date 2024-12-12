Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECE920A5EE;
	Thu, 12 Dec 2024 17:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025295; cv=none; b=G+dBV5PIHexNfr6oxXTWfWnBHFG1KI5OOtJ2NJ3f8+IxaASCifOgq3L17/L6bjUujXSLLoY+xLqcSrULzfPhcBTWR44vRSnDrryFkyrwni/34tOMXaw6SvnIgLiQ+FPfUrIBkPYygFyVr1PdPPJtqPdGAl1/BMmBYqqWN/2tkOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025295; c=relaxed/simple;
	bh=xolOzt0IdWTZmyNNGA7WCis2Ko/MBA7/ewNn4KGv/8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBLntor5bsoam63jxiEp7fLuO7X0fWMUdZXWFiQVSX9+mkbUrcDP8wPQQ4mZ3+uECqLxt/+edRVRl1K1kmGCpHiMz9ROk380eOZvXvo26ckNwbqVtsOTO8JuCqajmBnLDlp4qFLQHICK7/qTAvTt/Zam1/2my9GaC/AK7wj8NiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDolz2w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDolz2w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8593BC4CECE;
	Thu, 12 Dec 2024 17:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025293;
	bh=xolOzt0IdWTZmyNNGA7WCis2Ko/MBA7/ewNn4KGv/8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDolz2w2H6T/lqa+Mc86a/8uLf6XIeyMsBzjIOHwuNSUfTJ8GDmzlMrXH30TlQ3aF
	 CUeNmGrgYJWCPNtNpqdYmtSMyz70T5GsHni7SleAuR0NU57Z4OnKbGFRVUBryPwJLo
	 6CBfkUImNeOLc3z/F/AihQmZGM3vSSoGNGnoWOug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/321] NFSD: Prevent NULL dereference in nfsd4_process_cb_update()
Date: Thu, 12 Dec 2024 16:00:40 +0100
Message-ID: <20241212144234.797653042@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 771733396eab2..51462f7958b3c 100644
--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1229,6 +1229,8 @@ static void nfsd4_process_cb_update(struct nfsd4_callback *cb)
 		ses = c->cn_session;
 	}
 	spin_unlock(&clp->cl_lock);
+	if (!c)
+		return;
 
 	err = setup_callback_client(clp, &conn, ses);
 	if (err) {
-- 
2.43.0



