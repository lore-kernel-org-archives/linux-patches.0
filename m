Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C962DF73;
	Mon,  8 Apr 2024 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584271; cv=none; b=cSjOiNzJRazwK3Lt6FxzxXqzIqt7LHNtgoIhFtMSKmzcfjic5fZSsXh90V08TvOKh23EeaNMbW2bS/0NQnHHv4TI9jG2fGR/08bQj7uxBUs8mZGto4EO6epBb1fx33OXNEWs2FSN2dereO7tou1zWK2Vwg79vrjdgTON2R6gPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584271; c=relaxed/simple;
	bh=h2uPRh8BdrIXdZe2wLc+kR0zicXwA/rfcQXqcPSPd58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzI2dMX+3yjH4b453R0YniltN/vhfhKiw4U+UuiiBKXc7qwpuckh2WRxeElqQE1MJcmkb4aS2kDR5qn7umfRaCyjXciM9OCZ8p81FcDH7jG/ANx3/DVAeX1m0czJhBn7kXOC1a2hMHZXJ1OHh5t+9So2pQBQ6gWHfUKJ8JEfZQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8Ozwa56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8Ozwa56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43C5C433C7;
	Mon,  8 Apr 2024 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584271;
	bh=h2uPRh8BdrIXdZe2wLc+kR0zicXwA/rfcQXqcPSPd58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8Ozwa56wuXglbK+leYT/SeQ5xGMiWFiqx8bmVW+2zbgYJksXPzCj4pA4iS1HMDVp
	 xG8ro67aBPZOKSIA534WwoQ2WriZ+pmDXpJOmZBeaqneBhlba7TzmH0m4nMSSF2PCQ
	 bUCOWTk7wckeN/kohoLsEJFem8aMed9boa6TL0x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 380/690] NFSD: Optimize nfsd4_encode_operation()
Date: Mon,  8 Apr 2024 14:54:06 +0200
Message-ID: <20240408125413.310259714@linuxfoundation.org>
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

[ Upstream commit 095a764b7afb06c9499b798c04eaa3cbf70ebe2d ]

write_bytes_to_xdr_buf() is a generic way to place a variable-length
data item in an already-reserved spot in the encoding buffer.
However, it is costly, and here, it is unnecessary because the
data item is fixed in size, the buffer destination address is
always word-aligned, and the destination location is already in
@p.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 07f891d7fa0ae..9eba9afe13794 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5378,8 +5378,7 @@ nfsd4_encode_operation(struct nfsd4_compoundres *resp, struct nfsd4_op *op)
 						so->so_replay.rp_buf, len);
 	}
 status:
-	/* Note that op->status is already in network byte order: */
-	write_bytes_to_xdr_buf(xdr->buf, post_err_offset - 4, &op->status, 4);
+	*p = op->status;
 }
 
 /* 
-- 
2.43.0



