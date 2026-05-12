Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A673002A9;
	Tue, 12 May 2026 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608569; cv=none; b=Aha9SMP9M9j3qJ6BhkdwEU/lv5I0pLc89urUWgZu4XCqC9ZlvjfBgPlfiJH25UUHrFG4AhH/dPGqZkEUjYe8tb5hxh23PNhRKPH4f/bwUXGG4i2f72lyWcC5m8z4ouw4iMzSKtgG9Om67C2L9RiltQiTd5K2pIwdTYA6kDMTfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608569; c=relaxed/simple;
	bh=EKeVV2k0JvFOTGkbyy0PK6XTmUeZqTkWaZkkXd1rbpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYnvO77NL5hUcUed4PPXbPLiih2evZ/e1uTD0l0WqRS2MXNTeB5VTY91yEc6DpCvxxgUqiYG+fmIr+AzYY36wcQfVBw+xk/0kIdasqmPjV9etMB1BYJWGDAzBPAoQwGPY40MaVKQrY5DjpT8GKIJDCiFtVww2vDlifGhKUAri48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoKTCp+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoKTCp+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F378FC2BCB0;
	Tue, 12 May 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608569;
	bh=EKeVV2k0JvFOTGkbyy0PK6XTmUeZqTkWaZkkXd1rbpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoKTCp+4mY9BNziyUd/3yIHS11mGALu35sZCcS1fV7sVAgUepnHzsRjVa3a5fwuit
	 +CBvSTMsXm+gM6QV2fDYdmxVbtoRC8wYEPK2bDdgMv1J48WJEDmatqVG4jwjf/rrHP
	 AUvefS/qEwYXfVQPxKU3DZbzIOF9/cDtk2SbTYdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.18 131/270] udf: reject descriptors with oversized CRC length
Date: Tue, 12 May 2026 19:38:52 +0200
Message-ID: <20260512173941.211346065@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -230,8 +230,12 @@ struct buffer_head *udf_read_tagged(stru
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


