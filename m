Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA5C28B7D6;
	Wed,  7 May 2025 18:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643297; cv=none; b=c0aQ0sqGH0ExO8UpHZqvti+sjxogU644Eu5tcgPZD1vXlgfQcQnGwjBRqeBTdJQJSmyMP4YBI0DX9IAwzGp67ZpUCXnN6MqD5q6DO0AiNCMacH5qzt1muUrwDVHA+4vaIve9k81vRBSAt9AP+TBfbV6hxCRk1eoFfOb3nuwjWlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643297; c=relaxed/simple;
	bh=oy6EfjFJd/XEUByuV4uGLBlskjZPesAYLVLu0HICF+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbM9+XJiPgfJ0qB8WDWYyk0JgUYmJky0WNHKvGvwEfx35SsiA+ughiEZxCZhdLHSYu6oJ+k+SHYNKAlki/IYA5kdojyS/Q2J45Xq+a4BgrL3x6y+GlyAcjGofoUK2IE0BEQNwO7wQgkdzLV78J0/stuMDgNIdtJejlGx4XrAHbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuVywNID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuVywNID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42B3C4CEE2;
	Wed,  7 May 2025 18:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643297;
	bh=oy6EfjFJd/XEUByuV4uGLBlskjZPesAYLVLu0HICF+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuVywNIDuZ+8OmP27yRHUT9UZHJ0tV0xd1jLy1tRs57SxM6KU5EqoSx1lfYc412qv
	 ckQE5cXYykkK9gF8etFRCOFQilvAM6UVjdYriMuEdGR53LPRY6U3hSXOZ8KhsVg2Su
	 y2+hBQwQrErl4GmWOF4tfO68WEx0G5Y6QJPg6B6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Paklov <Pavel.Paklov@cyberprotect.ru>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.15 13/55] iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
Date: Wed,  7 May 2025 20:39:14 +0200
Message-ID: <20250507183759.585715426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pavel Paklov <Pavel.Paklov@cyberprotect.ru>

commit 8dee308e4c01dea48fc104d37f92d5b58c50b96c upstream.

There is a string parsing logic error which can lead to an overflow of hid
or uid buffers. Comparing ACPIID_LEN against a total string length doesn't
take into account the lengths of individual hid and uid buffers so the
check is insufficient in some cases. For example if the length of hid
string is 4 and the length of the uid string is 260, the length of str
will be equal to ACPIID_LEN + 1 but uid string will overflow uid buffer
which size is 256.

The same applies to the hid string with length 13 and uid string with
length 250.

Check the length of hid and uid strings separately to prevent
buffer overflow.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Paklov <Pavel.Paklov@cyberprotect.ru>
Link: https://lore.kernel.org/r/20250325092259.392844-1-Pavel.Paklov@cyberprotect.ru
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3343,6 +3343,14 @@ found:
 	while (*uid == '0' && *(uid + 1))
 		uid++;
 
+	if (strlen(hid) >= ACPIHID_HID_LEN) {
+		pr_err("Invalid command line: hid is too long\n");
+		return 1;
+	} else if (strlen(uid) >= ACPIHID_UID_LEN) {
+		pr_err("Invalid command line: uid is too long\n");
+		return 1;
+	}
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));


