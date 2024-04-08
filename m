Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B257BB1A;
	Mon,  8 Apr 2024 13:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584460; cv=none; b=Qg5IQ2ysqtVShKBmioDN8BiW1mIfkUj1IAzNMVoGB84QGMbejUrPu2Q8VsWhwEtD3Gz0p3qLI7PvdNS5lYfQrzYDMGqKseCCvrKr1D6b2mV//6/YESHWUT0U25bggSCVymhkgNZmYw2PxCH00WpBkIiHx93+0SE8EI2i+Bh2z1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584460; c=relaxed/simple;
	bh=Hq84RSrJYMln1VwAWP6IrDaM3ouH0Efv9tTqJNjGIgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tz2sENnz9ola014AfxxUeqqFlCvqFQbNu4FGugwq4Z7vWNzaXSwPLeBgBHgmn6yDUyK/0o+DI2sDsmrpsEu2FgHLzo0GS1KplsWxE8Ib7f2j5guusURracLzRNNGiCb9a/wp001ANDvhIlxqFQBYUi4v41IT+LaOmpc1O1z9nTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBJ4+z8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBJ4+z8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A502C433C7;
	Mon,  8 Apr 2024 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584459;
	bh=Hq84RSrJYMln1VwAWP6IrDaM3ouH0Efv9tTqJNjGIgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBJ4+z8CucuL/ar7pWcY52e+mRRZIyetPbIJIffIqKuEcue8pms1ex8FrqhzBMNLO
	 WG+TyT16qUyTZo6ul2vPxKSkmcsWLdsfdqTcMiw6hYf2zSN4yyifwgSfrkDsO6iim2
	 rjnnYj5vRG4B4NLSCwuxUshDnOq+90Ox5BUhG7k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 418/690] NFSD enforce filehandle check for source file in COPY
Date: Mon,  8 Apr 2024 14:54:44 +0200
Message-ID: <20240408125414.754986402@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 754035ff79a14886e68c0c9f6fa80adb21f12b53 ]

If the passed in filehandle for the source file in the COPY operation
is not a regular file, the server MUST return NFS4ERR_WRONG_TYPE.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b2e6fa962f7d9..b2bfe540c1cb0 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1760,7 +1760,13 @@ static int nfsd4_do_async_copy(void *data)
 		filp = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
 				      &copy->stateid);
 		if (IS_ERR(filp)) {
-			nfserr = nfserr_offload_denied;
+			switch (PTR_ERR(filp)) {
+			case -EBADF:
+				nfserr = nfserr_wrong_type;
+				break;
+			default:
+				nfserr = nfserr_offload_denied;
+			}
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
-- 
2.43.0



