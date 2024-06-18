Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A219CD1E;
	Tue, 18 Jun 2024 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715906; cv=none; b=fY0Tz0m0UwPxYQPcd3L4mifsY4PhIEyGGy5Cy2sMUHcyZzx07gU/s9XVEPu7WGPutiy/iNwLiICoAG6wYR/Urzxl4hYB+0zAwc+1EINYlYqvr1J9fQXvKSmBaPdaOivZiy4Q2ZcRF74a7GfXcXx4Tg75Xb68PSiQA1CNgT6UjOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715906; c=relaxed/simple;
	bh=ZkUwAWmOESjeKESDZmgCYWYwcz3g0ExPQdOsQZtYYLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyUGqbf3rVDZAIundrLVinBFWTAH8VlUwyz6yZU3BS0YMr9HPqwABZPjrX7bHv0wphCc7dCAbIM9nrtjnZ+2uYPKFPUodC1r0vZrzM7J1g3NvSf65YBR6pfoBNe2lSKuaH1TqAposkJggKBRlHLlvDZ2FzhcVmRPXpCq1YMiBYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UejreQwf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UejreQwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA90C3277B;
	Tue, 18 Jun 2024 13:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715906;
	bh=ZkUwAWmOESjeKESDZmgCYWYwcz3g0ExPQdOsQZtYYLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UejreQwfButM5OIRwTQoXLvFWIAPfkjoAQ1Z7Tw3oP1wLhbmi0+V3k70vwau6qE+3
	 8pWhDFtG4R0iSgMCFjoXwd9Uzz6xNrLkZt1SB+H0bLjcU2si4hOdUvUHlMmyIZxo3k
	 3EYuZh7W+7azPzkDZQMHy6nwfkVbLS8Xh6D4nenU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/770] NFSD: Fix ia_size underflow
Date: Tue, 18 Jun 2024 14:35:19 +0200
Message-ID: <20240618123425.301213684@linuxfoundation.org>
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

[ Upstream commit e6faac3f58c7c4176b66f63def17a34232a17b0e ]

iattr::ia_size is a loff_t, which is a signed 64-bit type. NFSv3 and
NFSv4 both define file size as an unsigned 64-bit type. Thus there
is a range of valid file size values an NFS client can send that is
already larger than Linux can handle.

Currently decode_fattr4() dumps a full u64 value into ia_size. If
that value happens to be larger than S64_MAX, then ia_size
underflows. I'm about to fix up the NFSv3 behavior as well, so let's
catch the underflow in the common code path: nfsd_setattr().

Cc: stable@vger.kernel.org
[ cel: context adjusted, 2f221d6f7b88 has not been applied ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d4b6bc3b4d735..09e4a0af6fb43 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -449,6 +449,10 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 			.ia_size	= iap->ia_size,
 		};
 
+		host_err = -EFBIG;
+		if (iap->ia_size < 0)
+			goto out_unlock;
+
 		host_err = notify_change(dentry, &size_attr, NULL);
 		if (host_err)
 			goto out_unlock;
-- 
2.43.0



