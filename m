Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7C5285CA2;
	Tue, 11 Nov 2025 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825026; cv=none; b=hPma8potcL1ORXCwRcMXbsD/0Ku/8SQQHu3FUd/dATybzIBsOKHJ8aihxQsGndu9S66nG7isLIkKdIJ1q1VIf5ggc5dPAVzuf2LFgy+IfcIihHkQK43TyRGH3n52pMd3KrkyN1CUrHaH++XGYIAORz7I3/CMWaOsWrHob6cwDWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825026; c=relaxed/simple;
	bh=UdgKYlgX+t2kQ9Swe5trOQReR2z5GBhcTieT2pIUeko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVquWkyEowBmU9AwV9SdSx2NUM8ndMYKzfhuMPQId/E2tdLU5yisFTTea6Dmn2V8WUyGgwcfIpLwR+GGkCj7emubq61UdELt8Vu4wKllUX+Po2BV+xePwXgc79Ln+ubbW5wOuFY8E17LCWO/9A+aFE1hua21R8cnHT9Oz0W8lLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GU8f4CBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GU8f4CBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2564DC4CEFB;
	Tue, 11 Nov 2025 01:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825026;
	bh=UdgKYlgX+t2kQ9Swe5trOQReR2z5GBhcTieT2pIUeko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GU8f4CBmmewjAlg7yvAYMLYnbF4hA1dd1AvuwG2poE6jssJNk8/QaAbAyd0qHFtSj
	 vLgScj4YLZai50mVS92IiWpsspExFDJiA+iAoHweoAA6GmC87JJYPT+Ad2m16tukLr
	 Ge8mCdgpGzct+FoR3JNCmg29HsYvU4u3rkyINh5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 630/849] nfs4_setup_readdir(): insufficient locking for ->d_parent->d_inode dereferencing
Date: Tue, 11 Nov 2025 09:43:20 +0900
Message-ID: <20251111004551.663965083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit a890a2e339b929dbd843328f9a92a1625404fe63 ]

Theoretically it's an oopsable race, but I don't believe one can manage
to hit it on real hardware; might become doable on a KVM, but it still
won't be easy to attack.

Anyway, it's easy to deal with - since xdr_encode_hyper() is just a call of
put_unaligned_be64(), we can put that under ->d_lock and be done with that.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 4de3e4bd724b7..b76da06864e53 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -391,7 +391,9 @@ static void nfs4_setup_readdir(u64 cookie, __be32 *verifier, struct dentry *dent
 	*p++ = htonl(attrs);                           /* bitmap */
 	*p++ = htonl(12);             /* attribute buffer length */
 	*p++ = htonl(NF4DIR);
+	spin_lock(&dentry->d_lock);
 	p = xdr_encode_hyper(p, NFS_FILEID(d_inode(dentry->d_parent)));
+	spin_unlock(&dentry->d_lock);
 
 	readdir->pgbase = (char *)p - (char *)start;
 	readdir->count -= readdir->pgbase;
-- 
2.51.0



