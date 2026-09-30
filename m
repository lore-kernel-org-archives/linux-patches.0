Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5789237647E;
	Wed, 30 Sep 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796401; cv=none; b=UXjyFoHleY/6O+Y26Pn2RHi9bGMgeJ4IaYynUop1YdtRGGDRrb6Kyf3c5f3OntD0iiztgi91ChbzqqB4x500eR5tRN1WqU8CSVM4VYwha0G7iPowr+eDvlIlV69aQwF9+eASQVjUdKKUG5+sVqd14bYWY31La8qV3ho5e1AhXVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796401; c=relaxed/simple;
	bh=c5aZqRS5zuJgw9bqntd2fLnadaKeji5vlskp9yUoBgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPSOf6BqiAtMk7m04384Dka6ikbUJbWuMbGK2RHFGDB1SGqfvLUMI0t4Z1aDgUpH8VTxebLoopwrum0tUQTmLjQHkeOe9lGzfDZjk53JF0CJwd3+gZqNkGqAEKd1Bbq8qnvTbbc+qbw2vEshz17h0lMOjYR0EneuaJkuKKOFNBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0y4JHjIU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0y4JHjIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E61F000FF;
	Wed, 30 Sep 2026 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796400;
	bh=t13zBtgs0cc4+6TqhLqmB+BHDn4xT6N0XqaL6O+fnxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0y4JHjIUptJCFt4CVCVt+KwbBCsb3I6ikq8zDQX2xjxkV3w47XPqFEvWj+hql4bZk
	 epch7zw9UAF+fT3rTWCNIAGJbwsIXQUWzlM+YWOw6aekl8bzvCjiNhssNas+5OxUGy
	 O3bcEVoN83PTYpsXavJ3Q1JY4udLQ//M00Evuuu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0898/1193] Input: rmi_smbus - fix out-of-bounds read in rmi_smb_write_block()
Date: Wed, 30 Sep 2026 17:26:22 +0200
Message-ID: <20260930152454.192905912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 51cfe54f815ae175c7d1126b983d4d7c89715004 upstream.

When chunking writes into SMBus blocks in rmi_smb_write_block(), the
loop calculates block_len using the original total length (len) instead
of the remaining length (cur_len).

If len is greater than 32 bytes (SMB_MAX_COUNT), block_len remains 32
for every iteration, even on the final partial chunk where fewer than 32
bytes remain. This causes smb_block_write() to read 32 bytes from the
advanced data buffer pointer, reading past the end of the input buffer.

Fix this by calculating block_len using cur_len and advancing the buffer
and address pointers by block_len.

Fixes: 82264d0cf7ae ("Input: synaptics-rmi4 - add SMBus support")
Cc: stable@vger.kernel.org
Reported-by: sashiko-bot@kernel.org
Assisted-by: LLM
Link: https://patch.msgid.link/anLFSMKSoKyyZ272@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_smbus.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -140,7 +140,7 @@ static int rmi_smb_write_block(struct rm
 	u8 commandcode;
 	struct rmi_smb_xport *rmi_smb =
 		container_of(xport, struct rmi_smb_xport, xport);
-	int cur_len = (int)len;
+	size_t cur_len = len;
 
 	mutex_lock(&rmi_smb->page_mutex);
 
@@ -148,7 +148,7 @@ static int rmi_smb_write_block(struct rm
 		/*
 		 * break into 32 bytes chunks to write get command code
 		 */
-		int block_len = min_t(int, len, SMB_MAX_COUNT);
+		int block_len = min_t(size_t, cur_len, SMB_MAX_COUNT);
 
 		retval = rmi_smb_get_command_code(xport, rmiaddr, block_len,
 						  false, &commandcode);
@@ -161,9 +161,9 @@ static int rmi_smb_write_block(struct rm
 			goto exit;
 
 		/* prepare to write next block of bytes */
-		cur_len -= SMB_MAX_COUNT;
-		databuff += SMB_MAX_COUNT;
-		rmiaddr += SMB_MAX_COUNT;
+		cur_len -= block_len;
+		databuff += block_len;
+		rmiaddr += block_len;
 	}
 exit:
 	mutex_unlock(&rmi_smb->page_mutex);


