Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046891;
	b=eUql7I7w2ZnTBBAqgvsTC1L1v9sHdcuF3PktglUXQspQrkwIZKE+nA74kmC19J7HVdMZ
	 fwVvKaWoKLSurikXfe0W+ZE659gWbYM2zkj8o07IPbPA7aK8qQZxmiec9rjmdcYHgjNGq
	 gDxW1jr1ijEe9F88KOVMC85r/AmXjNLF0ljacW3Fyo3l51PPQEdoY4+/BeLPn/nHAw1Om
	 4Fg9o+OQvWEtMABniKLnfSyF7jxq94qPL6CVDm/33Qyy57Vxi1HfdveqoMElRFGxw65ts
	 s7b6Q/bR9jPJrsIFTY2I8MYeKQEZ9mnAD7EaMPHMWT6hp/u7PxBcqMEvg7f2BDZApDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OIPydUgUG5cLFQgSslz2Md4ST8pvpEeubnfDRDZ+P8I=;
	b=j9HcBaRwhPOQfV/AzuwbEWqC/95d+oPpkUGmWSVsgQ94WAApbqOcwDO4eLg2e6Oj3unD
	 nCbnlRB5g9KxVOagGVDgIWDD59xJ7l7NfvK0rd7QfNaICmoKQ67Huz70KAEWDyPGBseF7
	 OqcNwbiwmnCEgKLAwYtgLJZ2xraox2ukOtqRj4L49rVDK8oqylHZGqhxSpeM1igrde1tC
	 Rg15BXlEYD/2A+Ha1tVEwwCUFWjQtrzZfBaZ94yw/slGT/RcjChyO7kIA3e8k3K7Di0yp
	 YyfE1E4WL4S1fkpmmeyLeiPVSIPQt8szzthd9dcTvRCRTIufAssC2ktCoeUqXZMDgBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k9Fzse9A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048C8606A32C;
	Thu, 19 Nov 2026 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k9Fzse9A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6B71F000C6;
	Thu, 19 Nov 2026 00:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046890;
	bh=OIPydUgUG5cLFQgSslz2Md4ST8pvpEeubnfDRDZ+P8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9Fzse9A5Mr7rPqYH6Wmxci3EDv0IlQ5FR2iY1QbxtZRUk7FxP9nCAiYL3zWwFhVs
	 VfM2fO5pmSAWv+egOBDDeGSpvwoRFrsCmHkGXrCE0Le/DggNuQvycJd6HHfAU8FjzO
	 P/EGXIOZ6U4skezYKF9HjzRDcx8uAl7/dR9Gfqx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1443/2857] f2fs: return -EIO for a lost inode block after cp_error
Date: Wed, 18 Nov 2026 15:41:17 +0100
Message-ID: <20261118150253.270503895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 53b12b63304b34a3850a901c4de3cc6ad08e0aee ]

After cp_error, dirty node caches are dropped without being written.
If such an inode was never written, its NAT entry is still NEW_ADDR,
and reading its inode block returns -ENOENT.

f2fs_get_dnode_of_data() passes that -ENOENT up, and callers take it
as a hole. Since the inode block is missing, the next offset can only
advance one block, so fiemap walks block by block up to maxbytes,
about 2^30 blocks, while holding the inode lock. It took hours in a
power-off recovery test after shutdown and blocked unlink and umount
on the file.

Return -EIO instead of -ENOENT when the inode block itself is missing
after cp_error or shutdown. A missing direct or indirect node is still
reported as -ENOENT.

Cc: stable@kernel.org
Fixes: 28607bf3aa6f ("f2fs: drop dirty node pages when cp is in error status")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 233448ba3a299..c85ec028baef7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -783,8 +783,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!npage[0]) {
 		npage[0] = f2fs_get_node_page(sbi, nids[0]);
-		if (IS_ERR(npage[0]))
-			return PTR_ERR(npage[0]);
+		if (IS_ERR(npage[0])) {
+			err = PTR_ERR(npage[0]);
+			/*
+			 * cp_error drops dirty node caches, so the inode block
+			 * of an inode that was never written reads as NEW_ADDR
+			 * and returns -ENOENT. It is not a hole; the inode is
+			 * gone. Callers treat -ENOENT as a hole and keep
+			 * looking block by block (e.g. fiemap up to maxbytes).
+			 */
+			if (err == -ENOENT && (f2fs_cp_error(sbi) ||
+					is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)))
+				err = -EIO;
+			return err;
+		}
 	}
 
 	/* if inline_data is set, should not report any block indices */
-- 
2.53.0



