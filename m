Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5203413B2BA;
	Tue, 27 Feb 2024 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042707; cv=none; b=YEtmbAO78yhyBv584yu/MevUIQ5ra4Y17N3sXMr1WhjB96sEmtEHCcnB8zXsW4pMZuLVddI2q5acDsM4kqJ9GaKamPsXBPMPiepOSrYQaLEK/h87towIJE/EWlBmZATg1eTACyPEJkJ5cF37HhOpVGeeQuY5P8GQyWfvDZdQgOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042707; c=relaxed/simple;
	bh=Vc7dh6pgWXjQG8K402GfPdIrNM744DGa9MVVQiR9tSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hK+bL+NtiSb7bkJTkByuqOySPd/7/arwLvMZLvRrZJaOvayPbzvx/4ZPrhjeq1+eqV6rqzlbWLSRixVxdmTsiqYMp/lrTCf75omsfuoOWzG+39zOmSSdYWC4v5Z9s2U66JrWl7ZMvmhXmmHbHgs3VCeeAqdxSAn9E9yB0z8TxBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8RXIr5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8RXIr5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C57C433C7;
	Tue, 27 Feb 2024 14:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042707;
	bh=Vc7dh6pgWXjQG8K402GfPdIrNM744DGa9MVVQiR9tSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8RXIr5KEwM9Y2NmxyGmix12yOmdItC5Kg4Gkh1u5CMBBdTXiZCRDW4pbaAxCgFQt
	 Zz0J7lmphaUxSqZ+OgiZh/adUxivgiDomTw9kHK8P9Hmi6AgfFHaZv1TSh0MMDTVKX
	 UuvWYZwXH1+NimURfbQgyUV9s2Mrimtrilxj0iks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Subject: [PATCH 5.15 063/245] fs/ntfs3: Fix oob in ntfs_listxattr
Date: Tue, 27 Feb 2024 14:24:11 +0100
Message-ID: <20240227131617.291198689@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 731ab1f9828800df871c5a7ab9ffe965317d3f15 ]

The length of name cannot exceed the space occupied by ea.

Reported-and-tested-by: syzbot+65e940cfb8f99a97aca7@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 8e739023e3057..d0b75d7f58a7b 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -217,6 +217,9 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
+		if (ea->name_len > ea_size)
+			break;
+
 		if (buffer) {
 			/* Check if we can use field ea->name */
 			if (off + ea_size > size)
-- 
2.43.0



