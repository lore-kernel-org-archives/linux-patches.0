Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D453BD63B;
	Tue, 21 Jul 2026 22:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671208; cv=none; b=t8MqHIo4alQ4Zw17ErZdAbjRrlG9yCHTvt/fD/oLtPGhC5S5LPKHllVqzr5W3wU66DSnWrY7ZgWgVxhdRbJRdnuxRAzpFCDG95En+xaOBBibVCQvEkU6By25U39H+r+rSdzbUbETfbA12EMZ7lN+oaKTK9Cm1aYmnPpJsPVrNtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671208; c=relaxed/simple;
	bh=qMot84Wyp618vYykJ8Yn/Ns7BdLw5wk+jAr1nt+T+So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3+PUI1LBiVGXrAj72SauxFA2AuugMofEAhsiaVt6oxqOnkpKbRgVmAN8ZWcEDw3GeQEgqDUDh6b5h1upHzV3h1Clan8TfI0K4N5qxTITBVU5jvTioCSY7++s4HM0dT7F4YIiURA1BbU4owkwkXCOt1z8AHzTMCwyQMo8dZia0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0UECHNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0UECHNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F6A1F000E9;
	Tue, 21 Jul 2026 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671207;
	bh=C3IVIVym7u7FAdtjVJC3VR7FxyuMGes7JH29gy9jUvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0UECHNtTSL2+o42w/DIJ0xO3qsk/dXmCSnrI7PtV7Y38meG8LV4vSGz1BI9bPQn7
	 MBHXgyLoNtuX6RHVlrfVhteuRlAl5gCrdIv2jE0g6RsVWawxZ9qAs5crbObTroRviu
	 1YjDuqnhQZ+z885UwsoIEew+3bStJ+/VdX0xiZFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 158/843] udf: validate sparing table length as an entry count, not a byte count
Date: Tue, 21 Jul 2026 17:16:33 +0200
Message-ID: <20260721152409.568429821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 3ec997bd5508e9b25210b5bbec89031629cdb093 upstream.

udf_load_sparable_map() accepts a sparing table when

	sizeof(*st) + le16_to_cpu(st->reallocationTableLen) > sb->s_blocksize

is false, i.e. it treats reallocationTableLen as a number of BYTES that
must fit in the block.  But the table is walked as an array of 8-byte
sparingEntry elements:

	for (i = 0; i < le16_to_cpu(st->reallocationTableLen); i++) {
		struct sparingEntry *entry = &st->mapEntry[i];
		... entry->origLocation ...
	}

in udf_get_pblock_spar15() and udf_relocate_blocks().  A
reallocationTableLen of N therefore passes the check whenever
sizeof(*st) + N <= blocksize, yet the consumers index
sizeof(*st) + N * sizeof(struct sparingEntry) bytes -- up to ~8x the
block.  On a crafted UDF image this is an out-of-bounds read in
udf_get_pblock_spar15(); udf_relocate_blocks() additionally feeds the
same length to udf_update_tag(), whose crc_itu_t() reads far past the
block, and its memmove() through st->mapEntry[] is an out-of-bounds
write.

Validate reallocationTableLen as the entry count it is, with
struct_size().

Fixes: 1df2ae31c724 ("udf: Fortify loading of sparing table")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260612-b4-disp-91780c4e-v1-1-f15112ff6882@proton.me
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1397,7 +1397,8 @@ static int udf_load_sparable_map(struct
 		if (ident != 0 ||
 		    strncmp(st->sparingIdent.ident, UDF_ID_SPARING,
 			    strlen(UDF_ID_SPARING)) ||
-		    sizeof(*st) + le16_to_cpu(st->reallocationTableLen) >
+		    struct_size(st, mapEntry,
+				le16_to_cpu(st->reallocationTableLen)) >
 							sb->s_blocksize) {
 			brelse(bh);
 			continue;


