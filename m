Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA632C3749;
	Mon, 27 Oct 2025 19:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592560; cv=none; b=lsJaEuf38bXEsvU/hzGQ2e1e3y3ZjetPdnyVSVEuraze2xOxtQiWiWknr7aUTQ5wzW2nEL/1Lhj3i1+6YflEhPf8i7vWFMprmPHwkUXuKnmCR8fkgXR4Li6QfkB0W8Bu/q89AA7q2gbJrHJ2LPZMR/mX29E6WFlb4P8Apd+GYik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592560; c=relaxed/simple;
	bh=E/tLVRIpSayESXD/vj1tMyRpcapfFqy9RlegdXJ5u0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6qDGiVgTMZ5+hN9SqreBpq1yd0v+STrVTK/x3c4YpBnANu95k7fgDZY5IiS/+N5OZB905FhPMdRSh9zCngmbOZjDVJ5FSt5Rc5SqkPu+rUpA9aXe+QS0wpsayv/wAX56Vk7rpyWZZDkXbYoULwknZn6ndFGuH8F5RwWZAq+hlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8YHMhug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8YHMhug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5CCC4CEF1;
	Mon, 27 Oct 2025 19:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592560;
	bh=E/tLVRIpSayESXD/vj1tMyRpcapfFqy9RlegdXJ5u0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8YHMhug+Bnj6c1NHpVi5lqa6TODibLWKADw+4o4SJ8/Fcbv6UsS+ljIoPmVioUy5
	 5LyIypJKvseRWqI3sA0s0He2Trt784D23pvMQO0932rlPlKNWywaRL2YDOMa5s4uf7
	 E7/uFBAgIlXKnMS1K9/95FSfsZRvMcK+6xo8uoj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/84] hfsplus: return EIO when type of hidden directory mismatch in hfsplus_fill_super()
Date: Mon, 27 Oct 2025 19:35:59 +0100
Message-ID: <20251027183439.090504362@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8c086f16dd589..7e889820a63d0 100644
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



