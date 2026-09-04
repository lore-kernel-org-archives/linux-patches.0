Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE193B14B4;
	Fri,  4 Sep 2026 05:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499030; cv=none; b=teg3IBY/0bEKr1PHBuPbYHvBBIh8T2E3LHpBv1dvNL1cMypsHPn4KI8gwqNKr4a3cmy7pj3562hz7xuWI6P4Ij8uOPFSHCbbuUlGqw/OCV2jYLpIMjhdYT7qhvngj2qgOq4LVV5a8Ra1QHI1KrBdsSzYHK1A2pRwpy+FJk8nQb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499030; c=relaxed/simple;
	bh=PAqMBBGtG1sKzt2o8bsg2mQaSVHiwoHkyoDga1kEKQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u87zCkoV1VW43AgpGPWntmxt031KfqKmMDGUdM2IiUbeiKajpN2yMKCKKbGdKSE027/hFWTE+dghRLew3aOMcfxzX7cKaOFgQoPrt53BzX1D7pRFmBBOgFABHWPwZCgh72HYYoYizm4XYbiMqM3thtnDcOzOrp7maIM5M99Vgqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZCjFySF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZCjFySF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329A21F00A3D;
	Fri,  4 Sep 2026 05:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499029;
	bh=7wrSNSdRjbU33fBSypsWWtIC5B+uQlR+Cnq9YPMlSXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZCjFySFu8rExR8BPTCVLJlWyGalHKYxMfgyYaA1+ni0lcL8HSmJuKSWsAa/sCc2C
	 Fe59dc7iVoVEDyDW/SGr+2x5gQH62srr3uc4KqABGjdSOxbyE/iZBEIufLTzED6o2X
	 XGGdxyReXc2DyMmdZNqCeKBNdNjAY63+TTnflPxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 7.2 274/713] ecryptfs: reject too-small tag 70 packets
Date: Fri,  4 Sep 2026 06:54:02 +0200
Message-ID: <20260904045809.982484859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -894,6 +894,12 @@ ecryptfs_parse_tag_70_packet(char **file
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


