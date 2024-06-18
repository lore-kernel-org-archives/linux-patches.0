Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA7F14A08D;
	Tue, 18 Jun 2024 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715340; cv=none; b=Hb2kNK5vurY0eVBJSoyfm/VvcJWrdVATZWB7JpktgVcO01bkW9EDLfTFWke5s+w3XryIxBC6cTdfZrA9+D0t/i44gsm7FD8I3RBb4lfJi8ccKxbtljVlxVoJlfGhFz2jTw0uw1ZI6KtVS5cunLXCak1T16f4uYs8WXLoSf6IGA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715340; c=relaxed/simple;
	bh=n5tOyVmF9MUvuou32dO0VVe+UQSZh8d+wri/Gmr1aBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+9t6/Qzmf4SaUWaEf8THemp5IjvofjvwqG8aHUIzygqa9qT9YV/zisaq9G9VUIF0u1qYa0C6fJ27oaltiwWsScERdFCVkJAuOYiynZeXiySamHpd+KQiYBTRz6uhGGTDeOqFBo1L3/m/iXQ2Siy2VI2DaLlz4VcT6IVwNzqFeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG0pwT1Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG0pwT1Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC2AC3277B;
	Tue, 18 Jun 2024 12:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715339;
	bh=n5tOyVmF9MUvuou32dO0VVe+UQSZh8d+wri/Gmr1aBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG0pwT1YOwqywq5/jVbyDUvxcYsXUO8Jsc0B/YpXXMgV4UFVj7jK4ZkTvCDnWzIuH
	 bbPDyFQ+O7i+YUBe28J+oC31OJ706HUhOGI857xK6DR64F7Ahpn3B9bxnIDGZHoW74
	 5iUgmBeMdZi3vP++BjKqyPIRCWjhSTPWl09zP/9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	radchenkoy@gmail.com,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/770] nfsd: dont ignore high bits of copy count
Date: Tue, 18 Jun 2024 14:31:37 +0200
Message-ID: <20240618123416.696663188@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit e7a833e9cc6c3b58fe94f049d2b40943cba07086 ]

Note size_t is 32-bit on a 32-bit architecture, but cp_count is defined
by the protocol to be 64 bit, so we could be turning a large copy into a
0-length copy here.

Reported-by: <radchenkoy@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 949d9cedef5d1..f85958f81a266 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1376,7 +1376,7 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	struct file *dst = copy->nf_dst->nf_file;
 	struct file *src = copy->nf_src->nf_file;
 	ssize_t bytes_copied = 0;
-	size_t bytes_total = copy->cp_count;
+	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
 
-- 
2.43.0



