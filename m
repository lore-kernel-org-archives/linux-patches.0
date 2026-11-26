Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705464;
	b=G2pZqCbE0rh38U6oRm7OnlLALPdYngaYmTrafqlS6zQipYDqtlL9DEWkdEjzicskhfKW
	 fGCtfg3ynd7/bUa81s6EwkiFd1kAUQc53vpNjBvJAFM6iPFJdvBtyoka2jMpmLyamendi
	 sPsgBrCzQjQbZlm7CAUgpyVJS1TnFb6lfixQ0sRhXZzG0DuJ4rCGRfx7qu9mRQzBvuWaW
	 kG7+Sd621hPyJIa2+rXgx7ACXT25+PIZPQX2jR+Vxhvk/b+9QXzSMXEw3KI80wefeqr83
	 48CNBiXvE3xJLoALgNgBHNIds0jfEdtpDHXaaR+jTPNZrJ1I4Fz/tLBeT6sEaBx943A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=La5t3AhHNSIrvuDegtWy/e8eQT93km1JbWt7hckDgOM=;
	b=qOTrM403oFrpC+KpjuoMwWIVkqtTNhjZOu//QZkB5NNArsBd5faVVMLz+exdmy5fD5gb
	 JC3b+478XS1TJz9uRHSwhhE8gmS3B5KJwlnGMzyi1sZyhRNs+U/2WYb0kMb13MYwudAJG
	 fcaMYZArPn8fp0xd/bOlOzG2pFhBDq/ZWwUdTtnYc0G8Mw6DZPUwREVrs3JHzZ3FUVpbA
	 LlZlXMNX21zgjl16q8RnMCVTll3/ZoRLOVQDz4GXIcjQlRkjd8s7bni5AoGrMSVGQHToT
	 f49k8mEnFPcafbtfsb3EoF32/Ac9tNVOg6N1p5JiWbmTL6L0FRJ02fwXLwvjcfG1dXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oty21cSQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1568606A331;
	Thu, 26 Nov 2026 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oty21cSQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BF51F000D0;
	Thu, 26 Nov 2026 15:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705464;
	bh=La5t3AhHNSIrvuDegtWy/e8eQT93km1JbWt7hckDgOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oty21cSQMFuj9pnJ0Go5KzjgOBF6BYUGEIvHH0UHZgTHGZycsasHazJPSTe5QPvjT
	 4m6trBczFG9QL9YVWy4GwxNe1X1c4OiaNMwAb7r+xvagnecegTyjtw2EnXyqi+ZBTm
	 9U6WSHSac22Wae70KCGCnG+wQwG/a/moXiucRatQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyungjung Joo <jhj140711@gmail.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 206/319] fs/adfs: bound directory entry name length in adfs_fplus_getnext()
Date: Thu, 26 Nov 2026 15:39:34 +0100
Message-ID: <20261126144011.394237245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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


