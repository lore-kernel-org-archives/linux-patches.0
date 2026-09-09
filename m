Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622F5592E8;
	Wed,  9 Sep 2026 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964573; cv=none; b=r398K7wnioK7A97CZ/Nrrko3df4LLx7H2Vr6LF3Wjx4/1e3N6OU4ROQJ1ybYyEa3y5fHDuI9ACI8gOLB0pSTRFw9vtIcFYkHTQfHd//jBK4RjnX/gLcP4fE79/81hllm0GyfpBgU//UltMGtVswNonEc25TJaryez+ocavxPQTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964573; c=relaxed/simple;
	bh=l+V/FkMc7JYOf7k9VxZU94F42vti7PxwpKKJcRtYUp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU5JNFdpmE2IxwvHc3wCWHDYN1XprW4w60ezbFLyrwzhxIktoL3kaO5FWgZLBM088b8pnjD2guz51lW/cJ1g25vave05ZUnNyrDPGAc5grXYUrKNBDHu+3gKHF1mWz4e1o+hDf01fIh/NuFLBpsUPOKr7dQuD7344AOScEDpsww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srcPmBU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srcPmBU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF8F1F00A3A;
	Wed,  9 Sep 2026 14:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964571;
	bh=LES5jPWntOSonFuqAdziEUC9XE6o7Aho5dVmoQZjj98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srcPmBU5P/Z3XIPQZa3YPDWcwMFvFbEadZSnQ3yvCzdeY5WyVHCPDedMeSvsAWdnm
	 xHtLwxmYQetWqd1B+epkgm4YJNEvTCDv1zUj9jNmAkCF6YKgDMhENKWU0AUHQNrJgJ
	 +e5Bn0mjU9tJRKY9iI3apKlPF4OMmTjNpWK7NHwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/583] smb/client: reduce fallocate zero buffer allocation
Date: Wed,  9 Sep 2026 15:42:33 +0200
Message-ID: <20260909134254.099578259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 9e4ec3be67af41ab859302d7109b34976efd9258 ]

The fallocate emulation allocates a 1 MiB zero-filled buffer even
though each SMB2_write request is limited to SMB2_MAX_BUFFER_SIZE,
which is 64 KiB. A high-order 1 MiB allocation is more likely to
fail on a fragmented system.

Allocate only the smaller of the requested range and SMB2_MAX_BUFFER_SIZE,
and reuse that zero-filled buffer for every write request. Also reject
a successful write that makes no progress to avoid looping indefinitely.

This reduces the contiguous allocation required by fallocate emulation
without changing the written data or range semantics.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 32a7af68df73 ("cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3508,7 +3508,7 @@ static int smb3_simple_fallocate_write_r
 					     char *buf)
 {
 	struct cifs_io_parms io_parms = {0};
-	int nbytes;
+	unsigned int nbytes;
 	int rc = 0;
 	struct kvec iov[2];
 
@@ -3529,9 +3529,10 @@ static int smb3_simple_fallocate_write_r
 		rc = SMB2_write(xid, &io_parms, &nbytes, iov, 1);
 		if (rc)
 			break;
+		if (!nbytes)
+			return -EIO;
 		if (nbytes > len)
 			return -EINVAL;
-		buf += nbytes;
 		off += nbytes;
 		len -= nbytes;
 	}
@@ -3551,7 +3552,7 @@ static int smb3_simple_fallocate_range(u
 	loff_t l;
 	int rc;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kvzalloc(min_t(loff_t, len, SMB2_MAX_BUFFER_SIZE), GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;


