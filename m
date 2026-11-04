Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829001;
	b=uDLZW3PtPd1n/u8v3Rth1OG3/QqLZSzj09YHAzFxzAvSj5exw7rnP1xnMJzBmWvGhrHP
	 AAleTMkNslBIzOew4ayN4KgHwRxevBvx/+M4r8FuEOUHITZfs6VdIeY0mLnQZFJLrOgIm
	 /j4GM3IxpiOay2c/MzjYrju6JffrR5eDyiqHWEJKCYbO9UgWr0xWluzfdTF2uIbske2Pc
	 gKn3A7Ngtl3na+JVgXWT4A6viiU7KjaJnAfmoZEfUgTxlJKNyNulSKmZYFgwMuDTwO58D
	 cDgEPVGmLiqueXbZ6kyHndYojNwIlFAAb4P0iU3yQ/6UJBLni1e0kLKXCPxu8+11m8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJM6IMRFxf9mom6grCa82SIWxGu8TWNNiqvC2Py86Zs=;
	b=K/7vIUmUbZYUCfG3YCl5DzmW5PiZjWfB+b5fVJFMAipok0UeSGkU4pPcfbu7ZtprxjKZ
	 CXhztZScYoE463WWD7/rUNyNi3G9JKlXR+JXaIkmD0zVY9aKbW8Cn7GZgXrYVWx5XXZyr
	 TcdRynL0sa5fxQZIDlFCZxz1MH8huugEZ2hacshIY+dqU+sdrNp1NgVEAXuHm9ihQH4jM
	 Im5iR9gBuj6yaHkZqu/V09330y/Vb0hQ7XAAjRU1nJMeUMQVEMq2bfLf4Ctov2kTTpZzP
	 AFUQAZV2RgmtnPvdCCaPdT0rehUD7WPLxR8iOoIpyXdyyUpP1BIDTWfetjnk3pOkBSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5jGIGEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA7607F2AB;
	Wed,  4 Nov 2026 21:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5jGIGEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFF81F000C1;
	Wed,  4 Nov 2026 21:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829001;
	bh=RJM6IMRFxf9mom6grCa82SIWxGu8TWNNiqvC2Py86Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5jGIGEkdfwfyn9QQihk06mWPPsOnDX3UhvOQlpQhCZLW0lxbGA2NLGMTLMCQN3wn
	 2wwpXKQYQ7t7jV1IN5KEiI/3svkUZdZUzJxK472BAfYxPRKHsAEEl20SZYdBplXn07
	 9ljUI9kHihyZtSxor/Pu3qOnZhAEfKw0yl0FgiSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 380/547] smb: client: fix fiemap wild read on empty truncated response
Date: Wed,  4 Nov 2026 16:09:24 -0500
Message-ID: <20261104211049.094794462@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

commit f5baa17a0f316c235d61623ac8e8fb32c2b3c0cc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4360,6 +4360,15 @@ static int smb3_fiemap(struct cifs_tcon
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
@@ -4380,10 +4389,25 @@ static int smb3_fiemap(struct cifs_tcon
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
 


