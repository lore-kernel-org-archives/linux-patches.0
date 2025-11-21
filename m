Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17957346A0E;
	Fri, 21 Nov 2025 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730994; cv=none; b=AzPACk26Yg1axheMg4rLIT0vbyMgedus7c5Znrmivroep3uUTWS6Poo1S8vuy0Y/YZt3ICyEHcSmGgAdN/KSWplh6/2Zih//87PaX7a91hdXFd6KoOphIgk7W/eXY19wJZ4gNCIUUdG6DqNXVjIfn3gd9rND7pOUQ4tS5bc+nPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730994; c=relaxed/simple;
	bh=9noAOYfhf9vCiN0DrZVtNm8Hcd3FKMUWazeZtYHde0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpJqYtNBI0mIkcGAo4fSHJPvi5SnBeYsAoqorXrU3ft+b/9Y82Q27mY/N12fqwZPwbnmShUsbdZTItqAq6Dz9S+WTgD9A/y9090IAYzUPSTrr7XXiIk37Qk/f4gTPTPuu6Q3i/ScW4ZdQZSKJvYREu9hXJNGT+By59KK3bdwAs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peGhV59k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peGhV59k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D60EC4CEF1;
	Fri, 21 Nov 2025 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730994;
	bh=9noAOYfhf9vCiN0DrZVtNm8Hcd3FKMUWazeZtYHde0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peGhV59kpluKZF+VpTQ6/QO+V6FsEAIW6jYJajIFGH+Kl5v04pppwk1v25OiO07pu
	 i+6CuBBepO749kFhli9YhxOWr7hc9UUrsYr1y7S1JBrC3s22afwgr5uuAsl36eo/mh
	 j0XDBUWfiLyeka90+eGf5jHvCVqySbHxm9HQB054=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rtm@csail.mit.edu,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 054/247] NFSD: Skip close replay processing if XDR encoding fails
Date: Fri, 21 Nov 2025 14:10:01 +0100
Message-ID: <20251121130156.545041972@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ff8141e49cf70d2d093a5228f5299ce188de6142 ]

The replay logic added by commit 9411b1d4c7df ("nfsd4: cleanup
handling of nfsv4.0 closed stateid's") cannot be done if encoding
failed due to a short send buffer; there's no guarantee that the
operation encoder has actually encoded the data that is being copied
to the replay cache.

Reported-by: rtm@csail.mit.edu
Closes: https://lore.kernel.org/linux-nfs/c3628d57-94ae-48cf-8c9e-49087a28cec9@oracle.com/T/#t
Fixes: 9411b1d4c7df ("nfsd4: cleanup handling of nfsv4.0 closed stateid's")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1f6c3db3bc6e5..37541ea408fc0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5928,8 +5928,7 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 		 */
 		warn_on_nonidempotent_op(op);
 		xdr_truncate_encode(xdr, op_status_offset + XDR_UNIT);
-	}
-	if (so) {
+	} else if (so) {
 		int len = xdr->buf->len - (op_status_offset + XDR_UNIT);
 
 		so->so_replay.rp_status = op->status;
-- 
2.51.0



