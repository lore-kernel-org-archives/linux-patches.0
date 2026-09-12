Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D05344DBD;
	Sat, 12 Sep 2026 17:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232749; cv=none; b=udqdKy7a8vCxLIH6IPSvrSSBiAkgsquZXnRn9qp3NSKNqyZ9AlzHbOryOr60GXyHxaSCX82LFFgYk+enB+9BNMuZENf3iaTjFsZ4QSCuSVcg2HqWNSfm/99ubbAM91X3OxdEFWuk0yxO52Dd2XZY4lx421ikE1bT3xOt7rD52Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232749; c=relaxed/simple;
	bh=NF/ifs8wHB6Xc9qZqjK8gb+CVCEJpGCWnrsSIan7fpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z38oAM9f5XUBFpeBib4FGSFoIy5z23MEYOCtUbrOIUAvs6biFD0mT5qVZXe0Q3YLVtrV06iQ+fgJY0cISIZ8tAsHHPopvQOkP1ii0MILitqMY7+UymefGkUDNOouIpqlUXbqQ9ZRKtTk2siR/2RMhVXGhpG908n0BGHN8AzY0jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNtrrpGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNtrrpGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573441F000FF;
	Sat, 12 Sep 2026 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232747;
	bh=oHCEyyOYeAi9o8h4h7VE4h+zXbQ81RR/5CetxnWMed4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNtrrpGq+yzY8GwF7z/HQGUbXjDYyjuYZKsTQC3ip/ajtcE6WiOk2BHgoonPrboI7
	 JqmZGDZ2y06sF9g8WYY87TTzjq0z9/5dJF7EEVOdGaU7VrojWwGQs8qrui8c3wKJF2
	 XmKClSRr5cWvSatAuqgVtI19sTID7JkV4M/DqCgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.15 071/935] ecryptfs: reject too-small tag 70 packets
Date: Sat, 12 Sep 2026 08:51:41 +0200
Message-ID: <20260912065528.465687003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


