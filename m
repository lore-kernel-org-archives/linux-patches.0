Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423283F926A;
	Fri, 15 May 2026 16:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861203; cv=none; b=h4+paHSzsZ7QJ1qNPehjHVTPAD6vdM0iXGEsEXOlDc4Vyg4qEP2z8f5LVXlvOAPkpOBCSedTlW1vji21P3lFQ4YJXG1r2K13cj5VQOAD6zkL2od170I6crjKJ6CoFZE5PVtRjVvVUXGFSoKOBc7KVUOu90Nv1+DQDiScFKotj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861203; c=relaxed/simple;
	bh=Cf6vZOe8CslWSO4tlxfIfqnO0s005/tkhrJDAAm7URI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnQdLgfaONp2b3txuUbAFvoP1KuQypzEgCKM7/rTbQBVxxANttLdxSL9ZBGsi8fqtFwzy2rrFSOGKr8m54NNbqVdwokabrGXl1F/1xcFHlD+2F0/z58ac1ULcY5oVOo73A3oDNok2+ujEdsVKgFtDrglnoInJ+7Zamx11J9rLS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFOp/Lco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFOp/Lco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB98BC2BCB0;
	Fri, 15 May 2026 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861203;
	bh=Cf6vZOe8CslWSO4tlxfIfqnO0s005/tkhrJDAAm7URI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFOp/LcovptERBxHriY7nxRAksp2NyvdvcfF+6fcibptB9EcbS8P53KCRAXdr8AeA
	 A6+uJ8dtoxDIM/1V3nZNZov0KiFo/Ww/CM9fr+9aiZofF4Uft8GsJNyk7HyaFA/p/m
	 ue9RIA6CT5iA/lDJuAfjwKCz5EjI/L3iT8YMujIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.6 237/474] udf: reject descriptors with oversized CRC length
Date: Fri, 15 May 2026 17:45:46 +0200
Message-ID: <20260515154720.131472058@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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


