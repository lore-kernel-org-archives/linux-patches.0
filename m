Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043757;
	b=JFVnd3Oq97wx65x+w3u6yDugUunDHwtg1LmLB9XMXl4JcIRUehNRQc+RY0OqxyEiZxl9
	 EpZ3L2HyV8xv+JP3Ak3wlQVZrb5odR8Teah1/etSCZCucEBQTSqgPr6Ya0Ubp1D9ANMct
	 04l2bJtgU/Y4gh/udGsMyjpG0nyb7Y/3xoqbC5ONQ/HGttN//4w+XeXjtBHvrycTlfVJP
	 Me3a2rCcWOmIBZIUQQdVnCVkmn6JPP7sjeLrYbs4FWCFDPSTpiHHTRwifXpljIsnkyBeY
	 FQNjg2UO2DD597zEPchBZWBTkDa72vWehcmQEUWhmTHA0cSdSs9X+IhwzOP2Fxm82pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=21MlNro8tnhlsUsvfnpU0sMlwop6hYx8deLTqLkxh3M=;
	b=y7SjZLrwM932q+rtG1/V3q/1Eo5CZMiWTujvErmcxAFpw3BGJ53qXXT5XOtYaUfD4sXA
	 0fbWXm49hTdVFMWX7LnCLh4uUroiIU268AVXenITd6XJUmtxKPpnids5nBc/xBv4EkdQp
	 BCwoSCZMmMYKGZgRCNQINXXrrN6cTXBqx5qgVnIK9//ZGE7Ed86D5Bu6hCcVxmHChxkNC
	 E/jkqCLBa7p/lc5pV7AA9at+NmViryIU93Zo1zGFc7ZB5B26trCNI2fXMFKblCqU8zgXW
	 Z6qHVAdlQuzc+XZIWYktPx8HR/ehlJed55Iawlca/5+/zrP2xF4CqAGXOD4QJ8ak3Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p65h0tsS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64242606A32F;
	Wed, 18 Nov 2026 23:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p65h0tsS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93101F000C4;
	Wed, 18 Nov 2026 23:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043757;
	bh=21MlNro8tnhlsUsvfnpU0sMlwop6hYx8deLTqLkxh3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p65h0tsSONS6fem/91Qh6MXb/i/+/sy9D49sR4Ha69efeqeUmiwj79D3sV45UJA0L
	 x/og0vHHZ4m9JVozFCyzM7Yti+MMVCLpQ7Nz9yOpJ7+1jXesNmxewL1bPOW+X+AnSN
	 4quSjPpL991CVnG91Tu6zJ2jGbcohe93k70gqYbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0283/2857] ksmbd: handle allocated range queries on dense files
Date: Wed, 18 Nov 2026 15:21:57 +0100
Message-ID: <20261118150211.617401186@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 350684e0498512d06963858b810101f58563810b ]

FSCTL_QUERY_ALLOCATED_RANGES currently relies on SEEK_DATA and SEEK_HOLE
for every file. That works for files with holes, but it is not a good
match for dense files.

A zeroed range in a dense file may be represented as an unwritten extent
and skipped by SEEK_DATA. The server can then return no allocated ranges
even though the file should still be treated as allocated from the
protocol point of view.

For dense files, report the requested range clipped to EOF as allocated
instead of probing holes. Keep using SEEK_DATA and SEEK_HOLE for files
marked with FILE_ATTRIBUTE_SPARSE_FILE, and wait for writeback before
probing so punch-hole updates are visible to the filesystem seek
implementation.

This fixes the case where a query after zeroing data could return no
ranges for a dense file.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 5b335743c43b9..39af3051c8dfc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1031,7 +1031,8 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 {
 	struct file *f = fp->filp;
 	struct inode *inode = file_inode(fp->filp);
-	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end;
+	loff_t maxbytes = (u64)inode->i_sb->s_maxbytes, end, query_start;
+	loff_t query_length, size;
 	loff_t extent_start, extent_end;
 	int ret = 0;
 
@@ -1047,11 +1048,33 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 	if (length > maxbytes || (maxbytes - length) < start)
 		length = maxbytes - start;
 
-	if (start + length > inode->i_size)
-		length = inode->i_size - start;
+	size = i_size_read(inode);
+	if (start >= size)
+		return 0;
+
+	if (!length)
+		return 0;
+
+	if (start + length > size)
+		length = size - start;
 
 	*out_count = 0;
+	query_start = start;
+	query_length = length;
 	end = start + length;
+	if (!(fp->f_ci->m_fattr & FILE_ATTRIBUTE_SPARSE_FILE_LE)) {
+		ranges[0].file_offset = cpu_to_le64(query_start);
+		ranges[0].length = cpu_to_le64(query_length);
+		*out_count = 1;
+		return 0;
+	}
+
+	if (start < end) {
+		ret = file_write_and_wait_range(f, start, end - 1);
+		if (ret)
+			return ret;
+	}
+
 	while (start < end && *out_count < in_count) {
 		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
-- 
2.53.0



