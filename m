Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566A1F76AD;
	Tue,  3 Dec 2024 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242194; cv=none; b=B/RQdJUV76yLrnObEZSqGIL8K09Xw4Ps8Whe9PrdKmA4QEkPHvTUq1L9cuHEzMdWIKcu4P89/GqVp/cmiyqZfHduSuXettdQ2fC5XvTCTv4yNmq0ctjm8KAf5yAfhDK8HiPxjPvwH21+gmajdLM2S3ukQytolhuGILJoA70mWbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242194; c=relaxed/simple;
	bh=Eoyka4hCb/yjSaTsFgmc0SEQP5gZ75B0nBdCDOTWvDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQfzFi9ScUryRwlWCl9RSueCIp4MOVOCwylpuvtNHROOTeGw8mH0qF8kM5MnXrQ0laP6e6Eoqh+C/H7YXTC2aoprh+759/kz5PYEWKvwuoZtENQpMJfK2b1oFsC5Sa+ZPiZ8IitfjLJC7WQSMXe2UXNNj2MdIsGmnhIRTyyrQk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkV2oRso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkV2oRso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4A8C4CECF;
	Tue,  3 Dec 2024 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242194;
	bh=Eoyka4hCb/yjSaTsFgmc0SEQP5gZ75B0nBdCDOTWvDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkV2oRso3jZVvAgez2r3HZRzUR7cv7zKXehV5TGPQq9+7L3Ed2dzzvk8zCz1s4MMf
	 MC60RJsdLWUfle1CKgj9mu15XBPmzFB6pWydUtqLLbToBI2sdGiGnib8QuIh+dGYSk
	 +ofsSlQR0HGocqe6I1u1tBxBkwaa2/77WXK1n3PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Sadovnikov <ancowi69@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.12 634/826] jfs: xattr: check invalid xattr size more strictly
Date: Tue,  3 Dec 2024 15:46:01 +0100
Message-ID: <20241203144808.484615336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Sadovnikov <ancowi69@gmail.com>

commit d9f9d96136cba8fedd647d2c024342ce090133c2 upstream.

Commit 7c55b78818cf ("jfs: xattr: fix buffer overflow for invalid xattr")
also addresses this issue but it only fixes it for positive values, while
ea_size is an integer type and can take negative values, e.g. in case of
a corrupted filesystem. This still breaks validation and would overflow
because of implicit conversion from int to size_t in print_hex_dump().

Fix this issue by clamping the ea_size value instead.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Cc: stable@vger.kernel.org
Signed-off-by: Artem Sadovnikov <ancowi69@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -559,7 +559,7 @@ static int ea_get(struct inode *inode, s
 
       size_check:
 	if (EALIST_SIZE(ea_buf->xattr) != ea_size) {
-		int size = min_t(int, EALIST_SIZE(ea_buf->xattr), ea_size);
+		int size = clamp_t(int, ea_size, 0, EALIST_SIZE(ea_buf->xattr));
 
 		printk(KERN_ERR "ea_get: invalid extended attribute\n");
 		print_hex_dump(KERN_ERR, "", DUMP_PREFIX_ADDRESS, 16, 1,


