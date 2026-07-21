Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAEC6395AE9;
	Tue, 21 Jul 2026 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668506; cv=none; b=ghEqLjFgrgzkwfC3zZmUZ4MOvJS0YLqZwZ6I5j3fnBUwYvtYVykWV1a0E/vu0h4wgCFsEmn3jqZ2LuHUNPD0N81sV0KpbvPhxlXy8rUcy+tYVaHhIJO2tOKV4e/Yt3bO0f2+wldjy/wm7e04u0fjALzcGUppVZFRMQRyNM36dp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668506; c=relaxed/simple;
	bh=C57uTt4x8pfPj6mc8WiBpCOn6FzkQK68CJwuQLi8Pu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNwXu6zsQDvlbLDTzqJ9lOdOU3l7EH3xE0XSagMTOl9Z3E/96m7wzpviijHumq8S+q/48ujXOr0vkuc0Q0cchqAcjY8TFRgq+zziRIMmqWsYZm8Mwh7aeOLbV97J5VChAo5CDxHEdaZ+6mdAE0FhwPba2zfPJzhIdmYE6NkY1+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/TOI+E5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/TOI+E5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3844F1F000E9;
	Tue, 21 Jul 2026 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668504;
	bh=VocE2JunZGgUmATbF95amM+s7FGC6DpzZviZq07Or1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/TOI+E5dgGQnBRzSNtq9GwNXpr4UfGlr0W2SKapzsQiZ2ljdzUtH2vltUDCe0f2J
	 8eIArsjM6nT9/0lMmmKe3MCb1jQ2GGfMwk5k+z9nPt2qN5p2R7rzlhCOGknUsymhW/
	 LTgH2ZRmUGs5ICVRrCVY6+s5h79OH/pUPs0rIzPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.1 0202/1067] udf: validate sparing table length as an entry count, not a byte count
Date: Tue, 21 Jul 2026 17:13:23 +0200
Message-ID: <20260721152429.112309472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1396,7 +1396,8 @@ static int udf_load_sparable_map(struct
 		if (ident != 0 ||
 		    strncmp(st->sparingIdent.ident, UDF_ID_SPARING,
 			    strlen(UDF_ID_SPARING)) ||
-		    sizeof(*st) + le16_to_cpu(st->reallocationTableLen) >
+		    struct_size(st, mapEntry,
+				le16_to_cpu(st->reallocationTableLen)) >
 							sb->s_blocksize) {
 			brelse(bh);
 			continue;


