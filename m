Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A94033F5B3;
	Thu,  2 Jul 2026 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009522; cv=none; b=GW+LUFUmP+zOtPwEfkYwO3QajpWDoQ76g+Yk/bnKV7gzH5wftTWwAux3RIDL4axQPxV5QopfFmLEcjiMHmS5H0/ILUURR875gRYO65psCgZ10PPlsWU1gFIcunNo08MnPe5nBOYkKjorRQ0EspDHMOIWhFj1HyYkvQPCSB6nRns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009522; c=relaxed/simple;
	bh=YS3NqftLsJnGQ1DA/hhfOi9sQ7gdu+mNVr1zNfucUSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e82Ri3rnqYAa+oo77rogM8nscszEowWRHdaWzu04siBZQ9MOGzEmZfjZzozhcTZHKX4xWgheGJy0lnSsq0mz/P8CxLsD6AyFUZ5TfKhGNJ6Cjp14GH/sidomTv6heCixXcriGsxZV0s9RxWDmJ4H0ITKmTq06Xu1G4cnfSoLDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUo2HPtQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUo2HPtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987D91F00A3E;
	Thu,  2 Jul 2026 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009513;
	bh=9v58OWHiFab2U0rQbewrVWrJE0CwEAiJkOaN/tS4K6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUo2HPtQBT2ux5otVhe1ZDcGWoHHnWnlzpzCIfmIQzD75iSLwNJAZRv6SQtiPAmSD
	 Q99yxKSbSAn/41yp4HFy6FYMl03MQkTIbBdNTCoOkO2CJjT5C8p+L8wT39q2cFh/MU
	 xR7iR/E1dMPGUamFxpJ7dgMLb3hTRM8JU/88UK54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guannan Wang <wgnbuaa@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 79/96] NFSD: Fix SECINFO_NO_NAME decode error cleanup
Date: Thu,  2 Jul 2026 18:20:11 +0200
Message-ID: <20260702155110.642116359@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guannan Wang <wgnbuaa@gmail.com>

commit 9e18e83b8846a5c3fe13fc8a464b4865d33996c6 upstream.

nfsd4_decode_secinfo_no_name() currently initializes sin_exp after
decoding sin_style. If the XDR stream is truncated, the decoder returns
nfserr_bad_xdr before sin_exp is initialized.

Since commit 3fdc54646234 ("NFSD: Reduce amount of struct
nfsd4_compoundargs that needs clearing"), the inline iops array is not
cleared between RPC calls. A failed SECINFO_NO_NAME decode can therefore
leave sin_exp holding stale union contents from a previous operation.

The error response path still invokes nfsd4_secinfo_no_name_release(),
which calls exp_put() on a non-NULL sin_exp.

Initialize sin_exp before the first failable decode step, matching
nfsd4_decode_secinfo().

Fixes: 3fdc54646234 ("NFSD: Reduce amount of struct nfsd4_compoundargs that needs clearing")
Cc: stable@vger.kernel.org
Signed-off-by: Guannan Wang <wgnbuaa@gmail.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1821,10 +1821,11 @@ static __be32 nfsd4_decode_secinfo_no_na
 					   union nfsd4_op_u *u)
 {
 	struct nfsd4_secinfo_no_name *sin = &u->secinfo_no_name;
+
+	sin->sin_exp = NULL;
 	if (xdr_stream_decode_u32(argp->xdr, &sin->sin_style) < 0)
 		return nfserr_bad_xdr;
 
-	sin->sin_exp = NULL;
 	return nfs_ok;
 }
 


