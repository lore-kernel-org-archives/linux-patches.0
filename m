Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5F942B721;
	Thu, 16 Jul 2026 14:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212262; cv=none; b=ijegLGIJeCGqgp6LTZcMqmlosA7wBsNVxSextCqpoqtMnwgAeLydiIRd2EGaqY9iV/65+X6wxI4g8tFCxKKYFEZcWilMLrrdJO830Ii/sSgNBta39Kntc3du6VWPX0zD8bix36HANSWeL8WCg21J7bj738WzO7yrgMGebtHG6wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212262; c=relaxed/simple;
	bh=oJICzDLpla/1u1PTwndyFn1F6oBgT4/wUxylpBSZpVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfWIZbsCnxm24HqTnm9+EG54/JjWET39yca/Qa5y/J/4aT+u/vStPrv9c+AYEj4WnTUk9pnXl7uLgtuy05zWqO3V0lOFncGsqE1i0PWEyr+lQoVboOhzKpMkzTtDGIBZ3O0NDqRT7a5qOH5QKAU43AcXayoQVz4sdu5qhLroey0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVPGHy4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVPGHy4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93FB1F000E9;
	Thu, 16 Jul 2026 14:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212261;
	bh=P2lezxOd9pnM6c5PQ6pgDAiYmJCwkWVlw3E1Hx12uKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVPGHy4LqavcYo1UDDoSc9cGuuU5vqs4H7W4ffE61JEVvHfzMvitdSXUSTS9zUvKD
	 BO1KPrsjivedhNER8+ENtbeRn2/9qqiQcXceDHWEVk2/3qmdSed8I/lKISkZ9wQdSv
	 bCDPjwC5kGc0y+0MVfykY5bIQD9dPk9O/3Ex3cA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.12 260/349] udf: validate sparing table length as an entry count, not a byte count
Date: Thu, 16 Jul 2026 15:33:14 +0200
Message-ID: <20260716133039.169245615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1426,7 +1426,8 @@ static int udf_load_sparable_map(struct
 		if (ident != 0 ||
 		    strncmp(st->sparingIdent.ident, UDF_ID_SPARING,
 			    strlen(UDF_ID_SPARING)) ||
-		    sizeof(*st) + le16_to_cpu(st->reallocationTableLen) >
+		    struct_size(st, mapEntry,
+				le16_to_cpu(st->reallocationTableLen)) >
 							sb->s_blocksize) {
 			brelse(bh);
 			continue;


