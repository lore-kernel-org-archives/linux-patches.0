Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058937;
	b=ynsL9V60Tzp4kNvN+9NvxA/yd5JTO4VVMXK02sC2JWqg1LyhBLLrwyMI27eAY1NeD9Xb
	 OT7wLQJhHPYzpDqj7pC71SbaJO7xEdl34yCFJWrOeQ+n4WqXICJVe3zHL0J+A+4nzcFKu
	 Ns59PL6b/d0eA2cDjMjRW3oYfhymPHLcwhtDg+/JTUai0ISiVriprCy1BuNVgznl3J8mj
	 zd7fWpXoncIG4srxDwjtRVfdorFoUObL3WPE/NiacON4Dm1ZzNbD4OJ+3eM3e2XUk+ZPL
	 l1sdIXdy47pClo98ca7QaOjCDARMKYLcar7TBei6KdfA3hXhGXCJE023X4cxDuze13w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ifklS5ybcbukdsrQINsOjW0HcaDNB+RL/QMPZ+n3hls=;
	b=19UdL/gGI9PRGwazgbcPNeqfpNAU37DHVa4aM7FhPovtyh8NgjsBkKSVVPvmfD70WLkt
	 xZIUxdd32hlZw99GXAjCkq5m65VZE+YEgG4HkfqHEVe5rjeG8CG9Takpay3P8xI4EWkEk
	 6q7T503qnhsT3KFdCUPfjMOcQBpjgBukeeKD8wIeRv7ycRjeF0yugt6g+7f6A8CVNj0/x
	 u6AM4b75QuFVz12Yx9CaKrt/slszbMpqpKtYZ6Vc9LrFSBrewCkIYoLsiZhBUDvfekf+p
	 ARVGtgZNDKbJs2ZwepgsPK/76RWcQgLMHVnMmHuR5EjRTALb30suMtgSDtwxpxEtGDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPqTT+yF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695AF60A260C;
	Thu, 19 Nov 2026 03:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPqTT+yF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2581F000CE;
	Thu, 19 Nov 2026 03:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058937;
	bh=ifklS5ybcbukdsrQINsOjW0HcaDNB+RL/QMPZ+n3hls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPqTT+yFiFMoAB57H5sm9sx/xB6D7RgUr3iDJD4vyBrxOEW4SjKUjhUKYBIC+mkgf
	 NYNf7WmjpIeY11KsXYW9wKq66KOXyB/+BTB9w50+hk2xcOfx+cKLBjSSGRDrbTgMSc
	 W/cKIz8NDVZRfR3x7E0mw8G+wT6fWvHaYpYXwZ7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0622/1848] smb: client: fix fiemap wild read on empty truncated response
Date: Wed, 18 Nov 2026 15:44:20 +0100
Message-ID: <20261118145941.438146949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2fe90bcc44b84..cf7c70a14730e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3915,6 +3915,15 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
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
@@ -3935,10 +3944,25 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
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



