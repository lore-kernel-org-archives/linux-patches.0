Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053032;
	b=fJX9kO+EQWWekZO0Od8XBnaCD9w3tfZHt2gZqI4DayXwDcDXNRUyt2l9Cm7PGcsxB2cD
	 M96o5jT+9GjRtUgKJeF2l9FTjf5rbZbuF3dUUfQ0qA24nl207nnnhEAikOL8gdWMEu39v
	 xGX+4pARaNewDRHMdo3mvrutSGGVBFihD1KriN8kZY0DuIHNvoJHm4iipfUlHKjUAJYEB
	 qZM4wenK2CMrFI7BjpdM2RzHnIsvnVbGOblFPBQnIeRixJLUW9y+1ezq9IjYZnD+udFMj
	 +o4C/jUXsDGyQ4IGH8tTojU9YkDF5FcA40RS2DSZDzz1kYR5RMuA8jktmMFd02YmHtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5iv1Nq15iEjKsHl8I8usPW+EN+ZKZRR0f7CJK//N7XM=;
	b=5H6VXxRC/nsolEdbyexkOPWgcIW2CSH8lbreklMwyEJ4rBeJLr1pRoNTy3zhVyS/t1tw
	 tzyd9xBmkxm6vRTRO6WxCqHi6w/VrPqXa95T56IuFGw7vGEYO1wrwnxbcFqPBfLBLTZp8
	 4xaJc+ditCUWpCDIiP0+ttognU9iTNXylWpUNrCgoKSSxExclG+WuBYaoYhYZNblqRGgA
	 DLlgpwcUzzWlJt5xrWgbMc8bczlA+T6ry9UXwG1Swr6jqWOrNYTQZgIgxbwcQBl0P5ysK
	 TCHJnm0iFCs2BoLWt0CxoE91OYCF09zcr6T6SbmgdY7TUCqCATYbuzdVxSOnRlnwS2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmE5TLL5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D52606A320;
	Thu, 19 Nov 2026 01:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vmE5TLL5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8BA1F000C4;
	Thu, 19 Nov 2026 01:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053032;
	bh=5iv1Nq15iEjKsHl8I8usPW+EN+ZKZRR0f7CJK//N7XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vmE5TLL5guVyiZJXrX22/b6mmsVn5GcPXXwG6utqeEr/pRc8ELQijahF6iO+6+HUS
	 oVVzwxZXQVnHA3X1OHICaAiqbjLfg8R0H6Wosao148lSMgssyzRpFtSCgJ63pGknaR
	 aC66hAQgJQbIptYgIF4d3auHsBxheKzB5GmVyKKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0773/2214] smb: client: fix fiemap wild read on empty truncated response
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150042.589971811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit f5baa17a0f316c235d61623ac8e8fb32c2b3c0cc ]

smb3_fiemap() treats -E2BIG from SMB2_ioctl() as a truncated range blob
and loops for the next chunk. If the server reports
STATUS_BUFFER_OVERFLOW with OutputCount == 0, SMB2_ioctl() returns
-E2BIG with out_data == NULL and out_data_len == 0, and the existing
length checks accept the empty result. The loop then evaluates

	next = out_data[num - 1].file_offset + ...

with num == 0, reading 16 bytes before NULL.

Reject a truncated range blob that contains no range, so the resume
offset is never computed from an empty response. Also require the last
range in a truncated blob to advance the resume offset without
overflowing, and to stay within the requested range; a malicious or
broken server could otherwise make no progress or underflow len and loop
forever. Free the previous response buffer before retrying.

Reproduced on 6.6.87.2 with a malicious SMB2 server that answers
FSCTL_QUERY_ALLOCATED_RANGES with STATUS_BUFFER_OVERFLOW and
OutputCount == 0; an FS_IOC_FIEMAP ioctl on the mount oopses in
cifs_fiemap() with CR2 = fffffffffffffff8. The code path is unchanged
on mainline.

Fixes: 2f3ebaba13ce ("cifs: add fiemap support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 348168c9b7617..2f2789243729d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4167,6 +4167,15 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	/*
+	 * A truncated range blob must contain at least one range, otherwise
+	 * there is no offset to resume from and out_data is NULL.
+	 */
+	if (!last_blob && out_data_len == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	num = out_data_len / sizeof(struct file_allocated_range_buffer);
 	for (i = 0; i < num; i++) {
 		flags = 0;
@@ -4187,10 +4196,25 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 	}
 
 	if (!last_blob) {
-		next = le64_to_cpu(out_data[num - 1].file_offset) +
-		  le64_to_cpu(out_data[num - 1].length);
-		len = len - (next - start);
+		u64 last_start, last_len;
+
+		last_start = le64_to_cpu(out_data[num - 1].file_offset);
+		last_len = le64_to_cpu(out_data[num - 1].length);
+
+		if (check_add_overflow(last_start, last_len, &next) ||
+		    next <= start) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (next - start >= len) {
+			rc = 0;
+			goto out;
+		}
+
+		len -= next - start;
 		start = next;
+		kfree(out_data);
+		out_data = NULL;
 		goto again;
 	}
 
-- 
2.53.0



