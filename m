Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459DD37C106;
	Fri,  4 Sep 2026 05:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500837; cv=none; b=NR2s1oLLfnfUlVoZXa+rAXjAIjLTIAm6ZjgE3nuRpFHD4YQINn9AyyqpmksZXUlirOkin0ut+rQKYfWwck8r8XlERn7EUEeq5UzhqVkuZ9VO446eE0LIW9ohoNByEaVQFvP06i1Kf+kgPBg0UGPdM6aX6zqQDUzUNVE6ncOyrSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500837; c=relaxed/simple;
	bh=ZaLFAZhGxti6PCLGCIojxFYZM7FDne/hzahC3xae6NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IY1k9KqUpATbWL8iD/CukNqvj6Vd88Xkj3mQLQSfudcvHpuVr9Jmyw4zbo5RJV6SVlvq0K5dz4pVLOFx9Ib2BFf16x1qMqCCgKoP6teO8hmlyHZhJFury8HnQflEGKyqHuvAb9pT0qU50amuugnuhcfnwFTDoAAx6JvWbLoaFug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jNI+Oafj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jNI+Oafj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3251F00A3D;
	Fri,  4 Sep 2026 05:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500836;
	bh=0s6Ab1ndRS+cY6GDYPeQFo4jRotEw3Y5Eecc5l0FXVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jNI+OafjCk5nWd1iwFYu/g6tyHNsu2q0rBVHfY+S20OJoxlxJPq1Al4a9Hh0YPJ1y
	 WX85J4Up8Wkn2Q5UBYf5WpH3pmKZY72RexWQuY+zH4ozjdNra8Qd4PsvV0+FwZ5mTg
	 ymDPFINadW4yV8puBuin/ipg2IOrx2K/M4tycSDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 6.18 196/552] ecryptfs: reject too-small tag 70 packets
Date: Fri,  4 Sep 2026 06:55:53 +0200
Message-ID: <20260904045753.523966883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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


