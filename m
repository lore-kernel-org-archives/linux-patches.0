Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623080;
	b=psk0SXMapjesLubTYz1vpDtsYrLn5VvWl3K+xiZpkhA5s637XfbL1V59mQZATiTKUIKw
	 WzEHJ0BhyQhXFcXWoY2WqJthdwS3EVJavG/NYnillO9t2eMlqZx1bgrZgVfGVx4Ji8IxT
	 KdVv+J2eRL6TyO7mVnZUlsaz2aj3QMGnuOSUaV4raQu3a7g8MzgZXpFx4qGkmSXMIantq
	 Cv0D6fwjEoWBPsVL8Wv/NbvP1ZjDtxdn9SNoJiuDaojeIF1hPNXggOVW9xYrkIxLHTITP
	 deh2NxKFUtN7eOphktDn5Ix6JEMAv72xkyQPKuKVdDb6aiJc3ZBgzg62Se8xS3Mw6hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ol3EZYhlhlp4wqi+Vody4sI0OON087yy/Tb5DvS0eEw=;
	b=QjznzgIPouod2pfCA43oZuQ5vH2vqKjguPKvH30kxRcTOUGnp7cE3NVzPNIwf1ckgPCy
	 BCXtvII68NWFrGwx9QswumzEChBQZUdU9IZelvSbPmm0V8yLmyWlztlY+6G2niPFxbuf/
	 4cZxfQ755eqYx13LrOphT6QNS7d3UBxgv8HnZkriJoAfbw0LQPYtFX3Fw9HbR/yjDVKtB
	 a6SIoQ831fcquoPIaa4jV0funx8+1rTnf0QIFxUnZ1cq96ik5hwLhRuc1l79pZQ2V77AQ
	 N1MwBM2M1jPRxZp/muGIIPHVzCwc50KmPCADVTa8IigorkuTA7qcFOE+0w+fuP2QQLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuWoKBt9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB9606A31E;
	Wed, 25 Nov 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zuWoKBt9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720A91F000CA;
	Wed, 25 Nov 2026 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623080;
	bh=ol3EZYhlhlp4wqi+Vody4sI0OON087yy/Tb5DvS0eEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuWoKBt9hfdZzjZaTu6uGnyGKH8CBZxJo+LJmcP4kIZ+5ICtXycJ3U7QPicdGoXaD
	 IDyy29i0WocTdDFhH8bLnPZS+KCxPegJx2+AtQiRlv36L06YMyFqWgRNRwojcUCLU4
	 xuXf4rdJWFh2alvnZ3fTrCEmkpxEvb26yaVfxMM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 745/990] fs/adfs: bound directory entry name length in adfs_fplus_getnext()
Date: Wed, 25 Nov 2026 15:35:12 +0100
Message-ID: <20261125143839.513707294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit ebf5025b0d989f95542fc9da899b7de2fec499f2 upstream.

adfs_fplus_getnext() reads the per-entry name length bigdirobnamelen
straight from the on-disk big directory and passes it to
adfs_dir_copyfrom() as the copy length into obj->name[], a fixed
ADFS_MAX_NAME_LEN (260) byte buffer.  adfs_dir_copyfrom() only bounds
the copy against the number of directory buffers, not the size of the
destination, so a crafted image with bigdirobnamelen larger than the
buffer overflows the stack-allocated object_info::name that
adfs_fplus_iterate() passes in.

adfs_object_fixup() may additionally append a four byte ",xyz" filetype
suffix, so the accepted length must also leave room for that.

The old-style directory parser (dir_f.c) already clamps names to
ADFS_F_NAME_LEN, and adfs_fplus_validate_header() validates the header
name fields, but the per-entry name length in the big directory format
was never checked.  Reject over-long entries, using -EIO as elsewhere
in this file for a corrupt big directory.

Reported-by: Hyungjung Joo <jhj140711@gmail.com>
Closes: https://lore.kernel.org/all/CAP_j_b9BqyQrk3D5nj6RSa=eGcs2HkRYsWc3WdXeXp9O3=z4nQ@mail.gmail.com/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260715115231.1585166-1-sammiee5311@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/adfs/dir_fplus.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/adfs/dir_fplus.c
+++ b/fs/adfs/dir_fplus.c
@@ -192,6 +192,8 @@ adfs_fplus_getnext(struct adfs_dir *dir,
 	obj->indaddr  = le32_to_cpu(bde.bigdirindaddr);
 	obj->attr     = le32_to_cpu(bde.bigdirattr);
 	obj->name_len = le32_to_cpu(bde.bigdirobnamelen);
+	if (obj->name_len > ADFS_MAX_NAME_LEN - 4)	/* leave room for ,xyz suffix */
+		return -EIO;
 
 	offset = adfs_fplus_offset(h, le32_to_cpu(h->bigdirentries));
 	offset += le32_to_cpu(bde.bigdirobnameptr);


