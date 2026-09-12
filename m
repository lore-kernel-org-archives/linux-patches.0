Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03302F260C;
	Sat, 12 Sep 2026 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241288; cv=none; b=egIyNWxc/CCn+RvT+h/eCAWhcrxU4mT1ozZ7crT5mvlG0VjW0BcmWcdQJqyTJgsE9SnOmQQX0DrJiSsNwB44yFBfXg9+uqeaQZI9GQemVEB3U8HNMxHPO8i5GWbQpTWFsQzLush/8AFOeI5nzELCTAbg9qaPagy6o1A0Yx+JpwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241288; c=relaxed/simple;
	bh=El8n3I+RDFMxFNeXGR2Fzrhsmy0ZGGaxxT7FzRo70F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcyW3cb/u6M7QEhOCK9hkkvuA05zHkjSQ5XN277kc60UZMEM3jHbbU4Q1/4dGVgX5D+6GoGNOAGX4R2olL6/hnHEdl9g5dttxnQVVONxOQJrVS41fgLB0DjSL9GoCxdHHeFtJLn+a29+n4TSPa5Bh7dT2vqW0+ribdMGHasOXt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6LbOAi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6LbOAi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0341F000FF;
	Sat, 12 Sep 2026 19:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241287;
	bh=6aFK9kxHMS9v1GE8ibygZcWjXof8CMRZelaI/ZlSMqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6LbOAi8POYOjYbUi1uq7lix4ivbbW/JeSoHlNRJnkgIjpmn6dZfB7H8BBUPJZjnV
	 mpYG/Eo+T/MPuogzhPQdWuUBE2se4Y1mSuh0cY82+Do0439+WhpsexYieGHMkq94Yz
	 bLXDyqSgqWkeBsbxZKdMp49J7YAwYxmDvMVFLEeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.10 062/798] ecryptfs: reject too-small tag 70 packets
Date: Sat, 12 Sep 2026 08:54:50 +0200
Message-ID: <20260912065518.383706177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -936,6 +936,12 @@ ecryptfs_parse_tag_70_packet(char **file
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


