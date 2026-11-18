Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035368;
	b=Mg1UmHWHZ458k9ouQ3z77jJuhYEGG1vDIl4C/SqZuoG+J+/Zjotlc+MhhdofOTpdkrc6
	 wccRImYog0ptsRGW0l+n/XHRoZifqBk/hGsazmVTdnk6cJExL5ZMfaxKJvEMSP/wsjo6D
	 fGZmo9k8Bvils2fVQ7M/GQizYaj/TFbvrVDJtqM+yU73he6RzKjZrvQdPX6dPCD9Ye50J
	 DZsy38HR/yB0NxxUnBmtH6RsPO6p+QYMnp2NPz5AKa1Z41kUEhuqXNnjkftGURW+3jpQM
	 vFmvfoi1uMupFqxs7CFIItzCrP6stzy29cYZcoVmXmx30ybuRQEiBr70zGYO3oCe+BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XD5TrkvA14svHxLdCL53SFsbK91IzIbB9TBKl/ckCaI=;
	b=OwqNK3DehicOGrDTXIYMcBWSTubNoCQ6szGg8H8OjsLaAo4hWB6ZX4qrDOU4HGb0RwNA
	 RXWNJtvYiFKb3H2DFUtaxx4Zo7SXiBKjn9vJ6jG+9hkSYhWK2u1UDF2tUM5VW27mFOjHZ
	 DYdWqJ8draOfT1HqdcbD4VUKIq4Zxuw3JVVQ73FP7bdriM1YH7S6S9Nuupa56jQ4VYpYV
	 BTnKTZ59tIBVhGYDMx9VQYRP9Oi4VjjhcTVAT+w+3x4ctTHY1IBbECU2ukFHRAOyH7DPO
	 JSqqibYSXPlqia3RhlcZGeFTu8Un1fGYH8lwAY952B0LsCC3jaPThTuvIWbU1FENzrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr0tpJp6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535B606A31C;
	Wed, 18 Nov 2026 20:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr0tpJp6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879961F000C4;
	Wed, 18 Nov 2026 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035368;
	bh=XD5TrkvA14svHxLdCL53SFsbK91IzIbB9TBKl/ckCaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr0tpJp62PIzjMFNgPo45bO8vTgCtncYVu45Q/Iuy/64nOt1tlELfyQvxTWvrpPxF
	 BrZ0UFrO/sghnTiJyvlCirOrAory9HeWDosEPMRwQwO/VwmSFXvAuZ/1thGIInT/T6
	 5tilaxGdXxoTK/1/p8k8KJEI+HJQLOb5M2UCCu6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0678/3318] smb: client: fix fiemap wild read on empty truncated response
Date: Wed, 18 Nov 2026 15:21:40 +0100
Message-ID: <20261118150338.517041616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3988,6 +3988,15 @@ static int smb3_fiemap(struct cifs_tcon
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
@@ -4008,10 +4017,25 @@ static int smb3_fiemap(struct cifs_tcon
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
 


