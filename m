Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDC43624A6;
	Tue, 16 Dec 2025 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888565; cv=none; b=sKZYFThO7GpKRO0RwUuXodVOg7ANI31Nea/PBUFW3witbmj9ONbLNBLXT8auKqdxYscEt2RrFCXIHiNOGe49EHq1KXcFwydD978nxKvLpmhm3NNPLQj0wW1/OXe2qyZHugdzyVhN1QxEJkp5rZ/JwqulUNgCMY5I9JKAunzAEbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888565; c=relaxed/simple;
	bh=4SbF9E32jpDRh8Duu9GZ5foQtITz8oX8m4xvgDTT6m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eURnXpcOZrvjYoM9Sw6pz8Lv8N5GlgceHRXlM3CrmbTZOOmFhFUAAKJ7C/6JAzvyr73W1dvaeNsmFdCWVrft54B69bKXhMqrVaMKiS1Ku+iOXFQVU9MMlgel4B7PSm6BJ5/s0OakyBk1D/XBXfo99qYJwx9GW45comKBz8OHAUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Plb8cDTB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Plb8cDTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39674C4CEF1;
	Tue, 16 Dec 2025 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888565;
	bh=4SbF9E32jpDRh8Duu9GZ5foQtITz8oX8m4xvgDTT6m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Plb8cDTBjm9IH0U3AY1+MFtuPulyR331qE28+WEu/ulILknhfOeDxSqrISfyFDnYx
	 wfs/e2tWUafXZE8ykt/H7+wOytSJc4rDWq0hDCDOh3+HZWjQwTDfcrOdMS0F+5xIJD
	 wdefidnK8bH3D+aeThVw0pmlhoJJlZ7zk3ImAFIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 573/614] nfs/localio: remove 61 byte hole from needless ____cacheline_aligned
Date: Tue, 16 Dec 2025 12:15:40 +0100
Message-ID: <20251216111422.145451834@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 0b873de2c02f9cc655bef6bee0eb9e404126ed6c ]

struct nfs_local_kiocb used ____cacheline_aligned on its iters[] array
and as the structure evolved it caused a 61 byte hole to form.  Fix
this by removing ____cacheline_aligned and reordering iters[] before
iter_is_dio_aligned[].

Fixes: 6a218b9c3183 ("nfs/localio: do not issue misaligned DIO out-of-order")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index 512d9c5ff608a..b98bb292fef0c 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -43,8 +43,8 @@ struct nfs_local_kiocb {
 	size_t                  end_len;
 	short int		end_iter_index;
 	atomic_t		n_iters;
+	struct iov_iter		iters[NFSLOCAL_MAX_IOS];
 	bool			iter_is_dio_aligned[NFSLOCAL_MAX_IOS];
-	struct iov_iter		iters[NFSLOCAL_MAX_IOS] ____cacheline_aligned;
 	/* End mostly DIO-specific members */
 };
 
-- 
2.51.0



