Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CC5393DDA;
	Wed,  3 Dec 2025 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779533; cv=none; b=DCJD19yc9IwbzA14UvuNWm/XusDNQc9FxPlQO5bZKXG76deb7Stuq7qXEJ81SmoBv9ux0C1851DrDEXSfMiMnotClzyANAbIIU37rTN1l/Fr0uEKjL0ZEb1hldZOw8hfSewadYJOe78hYuRgxUdBkoHPSUWc9SOFtC4H5/4fJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779533; c=relaxed/simple;
	bh=pCdxjjYtqARsLHVH0J3O889tcbQh/egNw9tg3wdJ1jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW93j1N//9LacirRkdUAFfwiqupI5k/W7V5u79GJSniEre0fri1TO6d6lvdSJcsakXIrW6dqV8cCXq6fCVDPN09bhyvvpq2fAVfmNtjZ2fZmm/z9qgR+DRITPiWj7+V11yqP6AZH2QIro2VW7ZiFQyNH8StaJK8BP2mLkh3ozn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxMVzSQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxMVzSQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A97C4CEF5;
	Wed,  3 Dec 2025 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779533;
	bh=pCdxjjYtqARsLHVH0J3O889tcbQh/egNw9tg3wdJ1jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxMVzSQ09RdzLjOnBcY9gdH2nMr3Uom3zwAdaEgBkUBak6ZreEm/eZDOFNz4v5JXC
	 0skZxLnCdrs84A7pBesM+4qeAh42q0/hgjSl1eRM+khMscs7xR4LlT6X1M3itG4oxe
	 cK5H+cXjpdHorcJ+Vm3F7EkBIITb4Rp5IH5EzhqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/568] NFSv4: handle ERR_GRACE on delegation recalls
Date: Wed,  3 Dec 2025 16:24:15 +0100
Message-ID: <20251203152449.987834338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit be390f95242785adbf37d7b8a5101dd2f2ba891b ]

RFC7530 states that clients should be prepared for the return of
NFS4ERR_GRACE errors for non-reclaim lock and I/O requests.

Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index cbcff4603232b..935ca3845ce53 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7663,10 +7663,10 @@ int nfs4_lock_delegation_recall(struct file_lock *fl, struct nfs4_state *state,
 		return err;
 	do {
 		err = _nfs4_do_setlk(state, F_SETLK, fl, NFS_LOCK_NEW);
-		if (err != -NFS4ERR_DELAY)
+		if (err != -NFS4ERR_DELAY && err != -NFS4ERR_GRACE)
 			break;
 		ssleep(1);
-	} while (err == -NFS4ERR_DELAY);
+	} while (err == -NFS4ERR_DELAY || err == -NFSERR_GRACE);
 	return nfs4_handle_delegation_recall_error(server, state, stateid, fl, err);
 }
 
-- 
2.51.0



