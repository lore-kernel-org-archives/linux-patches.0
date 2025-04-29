Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF6582C60;
	Tue, 29 Apr 2025 17:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947608; cv=none; b=tCws6VlDURvE1cJnjUcqZaC8IoK2SciNdYw1o0BNDiEzyd+5iTCu9bmkil4iKszNEzzFN7wcKSFboELafFwaQza/FQCTA881HEwybau5M5iBww14dUCfJeKK/pBTS7MQy+EldL0NmTq4AwS1Yw9e+ZVGi984sV+XrVh9OxrmNgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947608; c=relaxed/simple;
	bh=LL6WZJsdqsIdzId0CheqGX1GIGIK5Lo4y9ykwDRxG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lz9vxqqMoTX1LbD/Zygqr8tgWJg5ec177DgzEYT/VS5m4ttAwt/+YZmzD184fzlsIUnM7+ng6L8slIAtuMyXy4spQXNwdmjsRw23oFZgc28VIMdFTG8c+fSsvKHb+molpNOQsmgPkAtgMiuhzXCs6AkdPNlcMtwVCPvRzCKldGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAJMzL7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAJMzL7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552CEC4CEE3;
	Tue, 29 Apr 2025 17:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947608;
	bh=LL6WZJsdqsIdzId0CheqGX1GIGIK5Lo4y9ykwDRxG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XAJMzL7o9PIKaQC8NpjpwDomZ74tX1TnVLj3lFnkZ2nXeFiKpZrYHo4wjWKVTdDUz
	 lLsnwVUC+PD63QAIQ7O6DYn6MEpCBDT3E29DJhensZEC0BK5tq6SRdsY6s/gH/kQke
	 FacHsTCUOMziBXtza+FmcHJ5lJHRugWAxcs63lsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/280] ceph: Fix incorrect flush end position calculation
Date: Tue, 29 Apr 2025 18:39:51 +0200
Message-ID: <20250429161117.173369442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit f452a2204614fc10e2c3b85904c4bd300c2789dc ]

In ceph, in fill_fscrypt_truncate(), the end flush position is calculated
by:

                loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;

but that's using the block shift not the block size.

Fix this to use the block size instead.

Fixes: 5c64737d2536 ("ceph: add truncate size handling support for fscrypt")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 315ef02f9a3fa..f7875e6f30290 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2362,7 +2362,7 @@ static int fill_fscrypt_truncate(struct inode *inode,
 
 	/* Try to writeback the dirty pagecaches */
 	if (issued & (CEPH_CAP_FILE_BUFFER)) {
-		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SHIFT - 1;
+		loff_t lend = orig_pos + CEPH_FSCRYPT_BLOCK_SIZE - 1;
 
 		ret = filemap_write_and_wait_range(inode->i_mapping,
 						   orig_pos, lend);
-- 
2.39.5



