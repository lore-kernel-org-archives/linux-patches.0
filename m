Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DADA230BDB;
	Sat, 12 Sep 2026 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226954; cv=none; b=OFGqUDsDO23j/w/y6Xbql7Kcr+vS4H2UJgSi6qRF92qrZfrMTL8+Vj0B3VmlP3GxdLhzhGnh2t5dSC0x7WB2o0VQW8DMYiuYAovhDBHoSZ1zddOgAT3N9rZJsKefEitoOAYBY+45U1C5k/O9JNSJBccEWr2RYEfGbw+MS6rqGVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226954; c=relaxed/simple;
	bh=rOMzZFMmQBL7FyxDrbMEY8mr/eiS/ruL3c9WLZLXn9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DmvdZ6TVB9YOIgcP6QNLH09cN0qrjB9U3KhOnGNT8VpUneJsEqgSPcAh/RbPMNrbQnCnBfE0y9tirMice3gujia2tsl8oedqEJmrFkLNJmtlrOfPs8dOhuiRukIZLQWHmm0N8R85Hj2iLAphOCqe/f6OWwz7P6pSI7mi955X13s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtAvLVsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtAvLVsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380271F000FF;
	Sat, 12 Sep 2026 15:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226953;
	bh=KnPOiEURzR04pPTER5ygxrC97cOwch78nj7kfuA2Kx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtAvLVsx+vz0b0tvVt3npDVo16R5SLyijRQKU13l6OhZblaqoZSx9fQtSdQnLJSUZ
	 1Ncmb9UZIX6IJuCj+wmLkHCsfX67n0q6Z/zSzW0677lpNfz81wXbw0/OgatAnoFG0G
	 JOEW3dKjHCqjgv8R3HzQpOLKfOZgVohzjs/8t4uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.1 0082/1191] ecryptfs: reject too-small tag 70 packets
Date: Sat, 12 Sep 2026 08:46:50 +0200
Message-ID: <20260912065550.015652385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit e97bbe1b2bd82ec2ae37ad2e4965b4d3e78bbf7f upstream.

ecryptfs_parse_tag_70_packet() subtracts fixed metadata fields from the
parsed packet body size to derive the encrypted filename size.  A
malformed packet with a body smaller than those fixed fields can underflow
that size calculation.

Reject tag 70 packets before the subtraction unless the body contains the
signature, cipher code, and at least one byte of encrypted filename data.

Fixes: 9c79f34f7ee7 ("eCryptfs: Filename Encryption: Tag 70 packets")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -937,6 +937,12 @@ ecryptfs_parse_tag_70_packet(char **file
 		       "rc = [%d]\n", __func__, rc);
 		goto out;
 	}
+	if (s->parsed_tag_70_packet_size < (ECRYPTFS_SIG_SIZE + 2)) {
+		ecryptfs_printk(KERN_WARNING, "Invalid packet size [%zd]\n",
+				s->parsed_tag_70_packet_size);
+		rc = -EINVAL;
+		goto out;
+	}
 	s->block_aligned_filename_size = (s->parsed_tag_70_packet_size
 					  - ECRYPTFS_SIG_SIZE - 1);
 	if ((1 + s->packet_size_len + s->parsed_tag_70_packet_size)


