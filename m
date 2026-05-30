Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E333832D42B;
	Sat, 30 May 2026 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160437; cv=none; b=Yp/zjFEipEjm4NUXIYwNrBpO2nr8lb9axJ8nxPAvAQyXwyejo+Q1N28WsQWfMLCtVMCPcJ1sYoywVIBv4EnGmW2k1My9w8AtTgAPAvtNXZMme6YE0Bd3nhdI4t9qybqO7sgseTpXZmCXMm+dl2znyuFZsV5WuD7v36c3TVAyLJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160437; c=relaxed/simple;
	bh=OTtGavW3jXhdOETriyLj4qSWzBs1j6JaUcYv9h7MeFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=df93H9lycYuQ9zK54zKFuNb928Y1dy7NzqJmH35NUWtiotTpymoEQw2aSSjnjE0oO3xll6gN+zCxxDg4XLsQb+okSA/9VRWDbWSNO1pzHhFpGFeefxAoOuHWmiVVlTZnKDpYlGjmf3XwtL0XT2Ofw5Tfz4gVLFbtGwL9dlMDteg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1y7egnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1y7egnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F291F00893;
	Sat, 30 May 2026 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160435;
	bh=6yoTdM9HbVoy/2FmKGINzo2s/rXHNu8SXesT4BHNRok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x1y7egnF4EHYh2RaS3msUOR/l7J7dxfjwAgW0H8zHF4VP36A9/eVGVNpeiCveNBeD
	 XxaKd/O6nTqhTm/dsgRN8Z6KWu5+TF10918Ibzo/LIlj/cDaY3S569mkXwd1OVVpKH
	 5v2TyJFCf/7tarlZjJljlH5vwUKi/DQqwQkq1jcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 336/969] udf: reject descriptors with oversized CRC length
Date: Sat, 30 May 2026 17:57:40 +0200
Message-ID: <20260530160309.649530924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 55d41b0a20128e86b9e960dd2e3f0a2d69a18df7 upstream.

udf_read_tagged() skips CRC verification when descCRCLength +
sizeof(struct tag) exceeds the block size.  A crafted UDF image can
set descCRCLength to an oversized value to bypass CRC validation
entirely; the descriptor is then accepted based solely on the 8-bit
tag checksum, which is trivially recomputable.

Reject such descriptors instead of silently accepting them.  A
legitimate single-block descriptor should never have a CRC length that
exceeds the block.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260413211240.853662-1-michael.bommarito@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/misc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -250,8 +250,12 @@ struct buffer_head *udf_read_tagged(stru
 	}
 
 	/* Verify the descriptor CRC */
-	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(struct tag) > sb->s_blocksize ||
-	    le16_to_cpu(tag_p->descCRC) == crc_itu_t(0,
+	if (le16_to_cpu(tag_p->descCRCLength) + sizeof(struct tag) > sb->s_blocksize) {
+		udf_err(sb, "block %u: CRC length %u exceeds block size\n",
+			block, le16_to_cpu(tag_p->descCRCLength));
+		goto error_out;
+	}
+	if (le16_to_cpu(tag_p->descCRC) == crc_itu_t(0,
 					bh->b_data + sizeof(struct tag),
 					le16_to_cpu(tag_p->descCRCLength)))
 		return bh;


