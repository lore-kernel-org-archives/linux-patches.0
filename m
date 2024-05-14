Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96DF9D4;
	Tue, 14 May 2024 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687781; cv=none; b=qJzXxdXz/LCj5LhKGH4hJVohz0b1a9jqauA6ZONIZQ6scHRTFkmKCeHUuEG4f2Kj4Aa2nmkNUMW2Gyf+5HKpxogOadHQzcFGtuoyeJJ+pM1fAQen4dT8b8sruF8IChiHy6qkzKCNj7azoSMP33PfhAHreOQOFLmelV6uZafsEeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687781; c=relaxed/simple;
	bh=Oq5SdN1fV9Hp9dUaLtY4d+vTqN3j7cHRJNGKFxq432w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMqec8YgzD+omZSvdJXQ1QM8ViAR4Dnwa5RbD8Ux43eLXT0pegR6Xyl1Ma7Jk0Cfa5psXx+jJnQ8gO7bYuqINDA6Au1gIm3sGaqIrgnyHj2LDTRQMnVOp0bY2Gzm7ayl7XXVwLCjLllywSMZdKLwrFZKfpwtLZm6aVrRFiRwFSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGHOw8WK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGHOw8WK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB360C2BD10;
	Tue, 14 May 2024 11:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687781;
	bh=Oq5SdN1fV9Hp9dUaLtY4d+vTqN3j7cHRJNGKFxq432w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGHOw8WKE3g99nGrjmOGSjBjQouKoFoMnhdPyKipdOir0LwKht28HwTrPPCaP3EJs
	 rUhqIn7FIy2l0bTKM1R01Mt/RDO6TvPPTWfgvgyZ6QhAqMIQxIMnONxgS84i0F5iyl
	 TsyrKbvWZBWRagfFlw2/vOIUhkMizWxDbUMMHgCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/168] qibfs: fix dentry leak
Date: Tue, 14 May 2024 12:20:00 +0200
Message-ID: <20240514101010.538224789@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit aa23317d0268b309bb3f0801ddd0d61813ff5afb ]

simple_recursive_removal() drops the pinning references to all positives
in subtree.  For the cases when its argument has been kept alive by
the pinning alone that's exactly the right thing to do, but here
the argument comes from dcache lookup, that needs to be balanced by
explicit dput().

Fixes: e41d237818598 "qib_fs: switch to simple_recursive_removal()"
Fucked-up-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qib/qib_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index a0c5f3bdc3246..8665e506404f9 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -441,6 +441,7 @@ static int remove_device_files(struct super_block *sb,
 		return PTR_ERR(dir);
 	}
 	simple_recursive_removal(dir, NULL);
+	dput(dir);
 	return 0;
 }
 
-- 
2.43.0



