Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E467156F21;
	Tue, 18 Jun 2024 13:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715719; cv=none; b=bdyqS1/Yflg+9r67JpMJhQdT7HWXs4wllH+FZGlGrNWOJmmLZUsaidnNC6R4ipMXOo9AbnYqssVuRTFKBrgD4zbSx+EbDHFgOEymii3uWsD7wWymYyrEavtcju6/i5hUuE9Fi9z1wIem7X9c/Kl/tm4eDnXz1c/qgw5LNCmQP6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715719; c=relaxed/simple;
	bh=45xGpY0TjP4W6krw0+MFQF8h92czRAS6ULbP114VmM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJY0CpIRbMKq4VjJnWTQsPniycCTQuX5wpt74WkuMCnzaa+PRHpw3TqJcUvu/PfdkUQYd7ATmnoYOidbMXk29kH9Md1EfytVdEHC/Lan7Ocdz2wvMHgWWBEeQ/2/5biDpyuWgUR1YZWYdgePYdVuBKfCB4v6X8G/1oxKkPPZLuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVb4WxeZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVb4WxeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C378CC3277B;
	Tue, 18 Jun 2024 13:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715719;
	bh=45xGpY0TjP4W6krw0+MFQF8h92czRAS6ULbP114VmM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVb4WxeZ0wXM4vJYnryHxZ3cLkwY9Ec0F5fI79ZpMGvrlefry5JqrnnT7wjCqdV/m
	 AZwyBC4GRGDYy6VKYPrzNPESiU7BumL3MFMk1hbFDfl+ocDMe8myX474Rj08YkH9J2
	 r5G56Sne3dvr+YOYJku7vbw2d/AMbwnPId2XADFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 403/770] NFSD: Fix exposure in nfsd4_decode_bitmap()
Date: Tue, 18 Jun 2024 14:34:16 +0200
Message-ID: <20240618123422.839017821@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit c0019b7db1d7ac62c711cda6b357a659d46428fe ]

rtm@csail.mit.edu reports:
> nfsd4_decode_bitmap4() will write beyond bmval[bmlen-1] if the RPC
> directs it to do so. This can cause nfsd4_decode_state_protect4_a()
> to write client-supplied data beyond the end of
> nfsd4_exchange_id.spo_must_allow[] when called by
> nfsd4_decode_exchange_id().

Rewrite the loops so nfsd4_decode_bitmap() cannot iterate beyond
@bmlen.

Reported by: rtm@csail.mit.edu
Fixes: d1c263a031e8 ("NFSD: Replace READ* macros in nfsd4_decode_fattr()")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ba2ed12df2060..d9758232a398c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -288,11 +288,8 @@ nfsd4_decode_bitmap4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen)
 	p = xdr_inline_decode(argp->xdr, count << 2);
 	if (!p)
 		return nfserr_bad_xdr;
-	i = 0;
-	while (i < count)
-		bmval[i++] = be32_to_cpup(p++);
-	while (i < bmlen)
-		bmval[i++] = 0;
+	for (i = 0; i < bmlen; i++)
+		bmval[i] = (i < count) ? be32_to_cpup(p++) : 0;
 
 	return nfs_ok;
 }
-- 
2.43.0



