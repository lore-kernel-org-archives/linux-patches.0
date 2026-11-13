Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591590;
	b=BUyI7SglufIDD/5ciQL5NQ2Rx36YQmvT+AglbDgCL8f2KletGSB0O1x/Xl9sIzj6eCRg
	 nw7S/JrLlC/NqBDNIJDGwAM18qXG+Aw9Lg3IpsMxMOuwOPvUjYvN2v3glkYVDNda6pemr
	 gSo7B33XPIgpG34QHyhB0zWhLuzM+7KEPlDrQMsuR4dukRaQVDqytPeXPob/WRGg4ZKbG
	 JPhuC8G6E478vjkdpnpQIjg2xKZqRXYcssbil1EcHROgp538mN4Oh1X8oqmTsXbGipbMR
	 Ljs2MBFIGQTi98MK0845nZPTtJFoQgIRBHk+iUGlzZw9YORYWhd6qiZ1aff+vNVI69g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w/WapQ0BL0caK7Fyvzz7wokWqBFuL+9W9EeE6niwEbs=;
	b=QVomDhkNqdpMegjtTl4kfJLFXVC6sTrW9Z6JD8y40e2AQOyKoiV8+Z9D+gB30ydKrDp9
	 1O/Auv9uzdIrRYV3g3fqNWXy1qc+JeLvkAYvG4/82HMoXqSOhpmzT0KC89z9vAHquYRnP
	 GW/zetHA8zDxcUZt2CKlajwW3lZAOURP8RSRv1P/kZCF8GFjPuppdFx5qbBRF7wmo1HOm
	 KGwTSR/y1Qw6253rW8JrbWurB6xf/IuMo7WL/pQiz3zjFA9YU68PcZ/YssxPc/r3j6TCk
	 cq+6aZLjmNuUujudmSWOL7uySda6oUGtbscoypwtwzz7ROF3IkYkDAMxyISIuSFq8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSZjxITf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFEE606E651;
	Fri, 13 Nov 2026 17:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mSZjxITf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775261F000C4;
	Fri, 13 Nov 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591590;
	bh=w/WapQ0BL0caK7Fyvzz7wokWqBFuL+9W9EeE6niwEbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSZjxITfGCnFzyi2zzK9AO3nEFvAQ7W5nKvvLemxmIJlb0WTOzxkd1wPhbO85rF8O
	 vlAFvzOyp/PwxzO7tkJXIjIR+afeWie68N9E1ZycwcuUMIScGccLZNsd+csilKh1nG
	 LJE9+SLkHE7sPMbrSHB1d3+E+MvXfovzz0N228kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 635/670] dax: fix wrong error code returned from dax_dedupe_file_range_compare()
Date: Fri, 13 Nov 2026 10:53:19 -0500
Message-ID: <20261113153833.323629588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 9b036546a02c6c9a5133f9c1e93503896595c6ba ]

When dax_range_compare_iter() returns a negative error code (e.g. -EIO),
dax_dedupe_file_range_compare() incorrectly returns 'ret' which holds the
positive return value from iomap_iter() indicating more iterations remain.
This positive value leaks to the caller, where vfs_dedupe_file_range()
interprets it as success (bytes_deduped = len), causing userspace to
incorrectly believe deduplication completed.

Return 'status' instead to propagate the actual error code.

Fixes: 0e79e3736d54 ("fsdax: dedupe: iter two files at the same time")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20261015143426.17620-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
[ sashal: Adapted return status to return compared to match the existing comparison result variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index ae1e9497b4168..e9f12b7de17ae 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -2067,7 +2067,7 @@ int dax_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 		compared = dax_range_compare_iter(&src_iter, &dst_iter,
 				min(src_iter.len, dst_iter.len), same);
 		if (compared < 0)
-			return ret;
+			return compared;
 		src_iter.processed = dst_iter.processed = compared;
 	}
 	return ret;
-- 
2.53.0



