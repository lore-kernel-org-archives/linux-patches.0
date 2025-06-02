Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DA022A1FA;
	Mon,  2 Jun 2025 15:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876789; cv=none; b=GR2a+lPzSshIGMtczIhB7sol8e5/Ykkg9DilML04GcW7/v2naLwhlaPmmHbflXJZnXwRCag0fWmfoaq0Gm7ASdpDrICig9pDBuRGeVnRbqc3royPQ5PoArT6++1PUsN8qczmzjSWmmyjv7Qc1vtVNQ6sL+6DK+HULNueiVpnL8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876789; c=relaxed/simple;
	bh=8syM/bJdD15IE4pbJT82dwdQ/vaPeSf2EHKrGIvJZFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQCzsup6Um6M5YZFR6zRojD7oNV3SpS8Bv7IGKIAG6tZ1GmZW5KxvUN/fTd8HEpTB7uxBXRhZgugN52zdFMPd6jK+GktNEHn7blmlqngquBU6N7i7tDvzmPF6MOQSv9sZ/vmJ44DZcoIDOi6tE9u3W7d+uRFBWr4a7e3FnoDSJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu3d3ZKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu3d3ZKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A14AC4CEEB;
	Mon,  2 Jun 2025 15:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876789;
	bh=8syM/bJdD15IE4pbJT82dwdQ/vaPeSf2EHKrGIvJZFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iu3d3ZKFw7aK3l4NSRv8BADEJaznn5B8p+AZYSPuYev+On0CR6Z57Vre1ajULzAjQ
	 5B27MskzmNJ8rl+MtCRQpaduI6tUEB2APieE2POye1hHySstj5qQeXuhA3Iyah3Ip0
	 3BXKVpzfLI3qkTHQ/QtKO2g8AWTjdAc6wNvxjozg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/325] pNFS/flexfiles: Report ENETDOWN as a connection error
Date: Mon,  2 Jun 2025 15:45:20 +0200
Message-ID: <20250602134321.542071740@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit aa42add73ce9b9e3714723d385c254b75814e335 ]

If the client should see an ENETDOWN when trying to connect to the data
server, it might still be able to talk to the metadata server through
another NIC. If so, report the error.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 8056b05bd8dca..07e5ea64dcd68 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1255,6 +1255,7 @@ static void ff_layout_io_track_ds_error(struct pnfs_layout_segment *lseg,
 		case -ECONNRESET:
 		case -EHOSTDOWN:
 		case -EHOSTUNREACH:
+		case -ENETDOWN:
 		case -ENETUNREACH:
 		case -EADDRINUSE:
 		case -ENOBUFS:
-- 
2.39.5



