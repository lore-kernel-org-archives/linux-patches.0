Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DE819CD1B;
	Tue, 18 Jun 2024 13:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715909; cv=none; b=INAcRi4gEMPqpMBBtbvAI/+k4vkrq/NJ3f0UOySkF1fyQm/aKUn7mZew3uBfhzWnyObNNKXzV6aoZxSxe+JQuZves5JoLYm81jP7NQwheQqX+sVM9D21Gxg32TTwdOYc8QeRnalISP/rAIA4CTsM40suEWq0Xg9kMqo280UKy94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715909; c=relaxed/simple;
	bh=ws7R/eY0i79lNm8UTQKkJqe5z/+OrDoj85ZPq+GWVME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Scwona0Tt0JhFF3END/7OUFu2iS19VOMUL5QoeoJKMTgHT7ojWwnO1cnU/U8dkAb0Qgo1skD0O+Tv3kzVdNjkNp62GA2iBCWC8jooLzDQ99xTBoFNDmh7Gm5I32NI2bCuLcdjYYFuR+D05sp+NEwEyodAulrHss9Zs9kTYV2S2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odf7FuHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odf7FuHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916E1C3277B;
	Tue, 18 Jun 2024 13:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715909;
	bh=ws7R/eY0i79lNm8UTQKkJqe5z/+OrDoj85ZPq+GWVME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Odf7FuHnodCFg57wEp+igocE5awib23ZrcNv4qf6WyPqBaM8ygf61dxmJoq52f2/m
	 /y8wTZ3yitrEQrcg0P9pufBr6ReZjmEMi8fqb0Z1GD/lqhuRgboQQTREr0OEv9ki0q
	 V1w4UjN7aoUc3k8iPGVf+o8VunCIQtfpCyv5pjjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 467/770] NFSD: Fix NFSv3 SETATTR/CREATEs handling of large file sizes
Date: Tue, 18 Jun 2024 14:35:20 +0200
Message-ID: <20240618123425.341437065@linuxfoundation.org>
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

[ Upstream commit a648fdeb7c0e17177a2280344d015dba3fbe3314 ]

iattr::ia_size is a loff_t, so these NFSv3 procedures must be
careful to deal with incoming client size values that are larger
than s64_max without corrupting the value.

Silently capping the value results in storing a different value
than the client passed in which is unexpected behavior, so remove
the min_t() check in decode_sattr3().

Note that RFC 1813 permits only the WRITE procedure to return
NFS3ERR_FBIG. We believe that NFSv3 reference implementations
also return NFS3ERR_FBIG when ia_size is too large.

Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 7c45ba4db61be..2e47a07029f1d 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -254,7 +254,7 @@ svcxdr_decode_sattr3(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 		if (xdr_stream_decode_u64(xdr, &newsize) < 0)
 			return false;
 		iap->ia_valid |= ATTR_SIZE;
-		iap->ia_size = min_t(u64, newsize, NFS_OFFSET_MAX);
+		iap->ia_size = newsize;
 	}
 	if (xdr_stream_decode_u32(xdr, &set_it) < 0)
 		return false;
-- 
2.43.0



