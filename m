Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD763054D2;
	Mon, 27 Oct 2025 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592782; cv=none; b=T3D/3vmW+i+A4IhQEQvdE4cY3ky7Kq89R7jyUIMht1UOqjJ7I/NG9PBoiIH3IQ1kBtThK+tIiFmBKtBKN+k3wR0+E0CFZwtbzdCXnLyz1b+57n27MJiHZD/xlXDzCb3pPZdYKb/VO8dcZAqPShuPkEVxAtyv87YStnEMXuJye/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592782; c=relaxed/simple;
	bh=3s8jNs+QP+WGMrkvY10Z+/8hGcXKAIVp2oryxBouquE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/liJSphhabhMKrGj32+9qvmcZFqT/HNN8cHDWLS2vm1Z76I+nJ7lg8PjteUfUxJF2ukQy11BemtdpBp65M7DDkCbMJxIpQvL1kEEdpmPQLnD70F/4ZXe6jguEnt8C7Anbf49fJSurJADvm/KzGVecgMXOrJgLtSABc3/bTENos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFB+fkGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFB+fkGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28C6C4CEF1;
	Mon, 27 Oct 2025 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592782;
	bh=3s8jNs+QP+WGMrkvY10Z+/8hGcXKAIVp2oryxBouquE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFB+fkGnsm2pQS41Dgy8U0fChNiZ5K6qLxmCPppqbuGUEV/dh0/E3zt0KOyzAcMGv
	 4iJUrOr6754IvBjYqZJpNc5SowRPd/e8q5YUTzeIVx9yxq8F4UySw+3foQEW6qWtJ3
	 kkyMcR9ZudptjnuQOf/X82SVY2vk1tKK5bnxVE3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/117] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:36 +0100
Message-ID: <20251027183454.218113824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 51364aacd4626..0831cd7aa5deb 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -544,7 +544,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
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



