Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2D8158D9A;
	Tue, 18 Jun 2024 13:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716382; cv=none; b=G84RMZX7csleNlE8ChrdFJkW297QGxOC8+vsEzCiQSigPhIgokAeHIL8t/Zbg/rLu2N41+XLxesIxOhaVDEBI7t1YbH5qSjqfVmKjaZ+Ijy6bp09bBylKYldNxJ8zHyUNhDqs9lPdHnRRBJEwHBPyiy5QRHHkt6vz4nlcp83je8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716382; c=relaxed/simple;
	bh=glc/fn9KP5H6FPfFjhfkpJCc0r5RbJNoV91viO15BVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7Tmze/eYQeszN48bzw2vRqkpZSa1ujfrUy+xte9+mYeFJRD59BMZzOK+fhK2u46skoNkaesxuXO0XFOQhMBmtS7Mp5+imNtQoH82CbraaoO1eoMQu3/LoiDzHWQ0KVU4dkr6bP9wiCWyaeevTESnswhTHtajSRXiX5di5M3gDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wVbgX4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wVbgX4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85610C3277B;
	Tue, 18 Jun 2024 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716381;
	bh=glc/fn9KP5H6FPfFjhfkpJCc0r5RbJNoV91viO15BVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0wVbgX4A1X8ZMg3T2g0kbu+IAtsqWwNyPZFT0EFz1LifbIrry8SzuJyjLGElYcL3L
	 kLE9pcFGeQ/+CRfEw3Pv91h5klMdOoFE2Wdv5PkYN0JxMl+7hdTEcb/Mu9P2EpeWCM
	 iPH3vH2HkVSy/ySuUpx4wGlOiRdRmcfQVdidkRHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 628/770] NFSD enforce filehandle check for source file in COPY
Date: Tue, 18 Jun 2024 14:38:01 +0200
Message-ID: <20240618123431.526777063@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 754035ff79a14886e68c0c9f6fa80adb21f12b53 ]

If the passed in filehandle for the source file in the COPY operation
is not a regular file, the server MUST return NFS4ERR_WRONG_TYPE.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 0431b979748b8..ebfe39d313119 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1758,7 +1758,13 @@ static int nfsd4_do_async_copy(void *data)
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



