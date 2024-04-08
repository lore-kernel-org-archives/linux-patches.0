Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910706D1A9;
	Mon,  8 Apr 2024 13:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583561; cv=none; b=FX4hQdK64IEURAl0St7PYsWEvAWjWU8EAKMQwQVt3MmcfW92yqajA+1IAjomE4tUpGnTmewCdAIKS4sKYd1jxXZslpGKXSVffbVBJMfsXYgTbbQkwUnZU5sC0y31rJ1lxORvJpLB5WNRk/YL3c+aNgkcHqMQCtmjzMlAqMxTjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583561; c=relaxed/simple;
	bh=zgQLarHlEhRQRhMx6sXbqNu+gaowTM3NPnRVobE4lE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KW/Qoi++3U971cvJQYmwy6Jbl3e86XhRxJ1mKWZdJwOyHjKfHAujDB9TvFMGFkTCz6+Y+tQX9MDmwrdnu5g+Rpxb1VtCKMzdVe7UwF2YKSgyKCFMFhJGIf38y194AJzdyMMULVXBXut579DydxfIlh7MSHL5cljMct/VCLrFdhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlEwYtEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlEwYtEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170E4C433F1;
	Mon,  8 Apr 2024 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583561;
	bh=zgQLarHlEhRQRhMx6sXbqNu+gaowTM3NPnRVobE4lE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlEwYtEqtmj6o0qclW+KhMwkQ9j1vKsHICFHLrRp4CZmtNCLYof2+tdqvupcGMvfw
	 jnuotuU9IP/mcSMNPsMgdmzjPIRxkGmJteb+RQQ0DokV3QEd2aOrE0b3ZlmNh5wSBG
	 kwUaOKBx4H+mw8G4CIBLO6wOvovQQc3XiDHyA4MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 260/690] NFSD: Write verifier might go backwards
Date: Mon,  8 Apr 2024 14:52:06 +0200
Message-ID: <20240408125409.040703898@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cdc556600c0133575487cc69fb3128440b3c3e92 ]

When vfs_iter_write() starts to fail because a file system is full,
a bunch of writes can fail at once with ENOSPC. These writes
repeatedly invoke nfsd_reset_boot_verifier() in quick succession.

Ensure that the time it grabs doesn't go backwards due to an ntp
adjustment going on at the same time.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8554bc7ff4322..4d1d8aa6d7f9d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -363,7 +363,7 @@ void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn)
 
 static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
 {
-	ktime_get_real_ts64(&nn->nfssvc_boot);
+	ktime_get_raw_ts64(&nn->nfssvc_boot);
 }
 
 void nfsd_reset_boot_verifier(struct nfsd_net *nn)
-- 
2.43.0



