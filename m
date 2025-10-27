Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A5331E0E4;
	Mon, 27 Oct 2025 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591925; cv=none; b=A2ZXMF6aEIMNelml1cYvftDRYVIcF+V7R6CGLkjaIUSg3E9e9vbCvkPsrza3O/I2vdcJVozroQmeWPiPusnL4AUu/L9KCkTXw25I6SNBcFXfc1zqtHoC8Cnhz2EhEJW3a5mrdyOtH+d0acTC/6Cr1BZwG6Tp8LS3LAFeUaIxYog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591925; c=relaxed/simple;
	bh=/xkbRKydNp41DxbUB4gljWk8za+XN1vUpS8W3Z+QmBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJ1IU0G5b/xrfYKuwnygrOsPC/jbyYhebPukVg4txNzPIP8ovST8XAVj4h7+Svm0xvyCe6VlIyh3r2npm4Mk5Z/+x0BNb5m8SvAUz/XgJ9BhRXzgZ5emfPd0ezhkn0Fc9jMpZ7iuaHwnMsQ86nLIOcYGcqF0/6Ci1rdSnTh1HrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4imuZUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4imuZUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB515C4CEF1;
	Mon, 27 Oct 2025 19:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591925;
	bh=/xkbRKydNp41DxbUB4gljWk8za+XN1vUpS8W3Z+QmBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4imuZUFx93sQa1wdwqU7b3dki9INFMiqGVRATvY/PblS6tZifPBHYkEYDAc/Qlsz
	 zAlraBlLmVP9ALtvhxDdHhlYF1U9WxB/8rVurUMGO/bKPTmKo1rtz+HTUktd4B9NQz
	 +FPAwhIDFidA1Cw/FDajaCG2n6g15baqO0gO160A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/123] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:30 +0100
Message-ID: <20251027183447.737321045@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 9282bc905f0949fab8cf86c0f620ca988761254c ]

If Catalog File contains corrupted record for the case of
hidden directory's type, regard it as I/O error instead of
Invalid argument.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20250805165905.3390154-1-frank.li@vivo.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 16cf5e1c685bf..cb703b3e99fc2 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -538,7 +538,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 	if (!hfs_brec_read(&fd, &entry, sizeof(entry))) {
 		hfs_find_exit(&fd);
 		if (entry.type != cpu_to_be16(HFSPLUS_FOLDER)) {
-			err = -EINVAL;
+			err = -EIO;
 			goto out_put_root;
 		}
 		inode = hfsplus_iget(sb, be32_to_cpu(entry.folder.id));
-- 
2.51.0



