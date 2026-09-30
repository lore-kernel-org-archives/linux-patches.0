Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB915383C5;
	Wed, 30 Sep 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790726; cv=none; b=sdEZwZ5SiK1TJjahHRhHQ2DU2r6ozMe+Ey5TdCbAjgy2iL3LZhblYswnm3+boSkH98pNzj0OJevit30IRp1jXiMqCbxqobLH72PN6ZA2JuALRoawSlZJUrOSvd2RI+gTKCxkm15UBsyyfJK8q6oFUFi+CV3dV6n2UpYiCI35SPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790726; c=relaxed/simple;
	bh=fxl8SqlJsOBT4et20fcmZhb98vYAEfIWKFrx1uLYVWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrSEoWouHafAn1Crl+W4C/wCqpd0s9lpuHuhoaatE0yPTUWeL2VbmiRjrTWmZQCNLUgqPT34NVJN6xf2x+vQZ6SD1Ma8oQ3vy+S5UdpYczQoAlVexnTozCiwwJTUIneQH+0fRa7TjzRG0e1R8NjN82yANMDXR7tGUscAagw9KtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASrC53Q1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASrC53Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676E71F000FF;
	Wed, 30 Sep 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790724;
	bh=msW21pe4hIAkQhge0fVaAXA4qUvCjYVCF/s4lGUrrYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASrC53Q1CDKyu/yAAzjJUNMSl6jtv3MTImNmuWuHxA92I1q27uxJL9I1RrwscpqDj
	 PpaMq4FtkB0pt3Yy1C1S+9ZF4WDm33+CfP75Amxd087sQKZXVFqvPVNRxb8vkwiYw9
	 u/XaJ0ZOsWWS0tv7cepiQo1anjkzHJtjDP/1dYK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Anders Larsen <al@alarsen.net>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/752] qnx4: handle set_blocksize failures
Date: Wed, 30 Sep 2026 17:18:42 +0200
Message-ID: <20260930152359.282050655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit c7d911ea1cc9a63b07e52f5e75b263be0615b289 ]

qnx4 uses buffer_heads, which don't handle block size > PAGE_SIZE well.
Without this, mounting will hit the

        BUG_ON(offset >= folio_size(folio));

in folio_set_bh on the first __bread_gfp call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511071701.2456211-4-hch@lst.de
Acked-by: Anders Larsen <al@alarsen.net>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/qnx4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
index 3fb7fc819b4fc..73eeb22d0f505 100644
--- a/fs/qnx4/inode.c
+++ b/fs/qnx4/inode.c
@@ -195,7 +195,8 @@ static int qnx4_fill_super(struct super_block *s, void *data, int silent)
 		return -ENOMEM;
 	s->s_fs_info = qs;
 
-	sb_set_blocksize(s, QNX4_BLOCK_SIZE);
+	if (!sb_set_blocksize(s, QNX4_BLOCK_SIZE))
+		return -EINVAL;
 
 	s->s_op = &qnx4_sops;
 	s->s_magic = QNX4_SUPER_MAGIC;
-- 
2.53.0



