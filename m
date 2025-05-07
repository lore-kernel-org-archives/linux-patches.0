Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FBE21504D;
	Wed,  7 May 2025 19:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644974; cv=none; b=U9LsN6sfnVF5JuS9nDIDI5QhqR11fysqB4Dd8bFUk/aUeP6JjYoQ5aOhh+2hbrL/OWKlbsm863Ey/ClB4+NfnwBKCCgoXwy5NWIFVPzNlUm8DJWIR3Z8xJWnHADHRfKzrU8q1lzQ5NnoJ4fd4uB1ireFWHNsWH+07Bgrlbu2Zy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644974; c=relaxed/simple;
	bh=supyRvM0b/vzwurIriEgCDpZmH1KqLtAsqTmArMYIJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6K0q7u5BxIHKTDzXMGdycKMhNL5DATdmqC3E1bKY/VU8dkpaeYgRVA3cbA0Ik/OXBtSUMoTlHQcXpxKwwe1RdKDk8C4nSAJv8Babzx1LZUed8P8t5Out2EUkSYej3oDqJe6BZHi1sWGCJ0/2SWN5q28Zl55pQUxBIvVHabDvpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RUTyEL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RUTyEL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BFEC4CEE2;
	Wed,  7 May 2025 19:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644974;
	bh=supyRvM0b/vzwurIriEgCDpZmH1KqLtAsqTmArMYIJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RUTyEL5TlidUQnTA/hXstVXWe0mE2PvO6NbUncIsxUdZsLrnoT5Mxhd0Uy/r+lLj
	 U9+m4+Qe3udlQKTO4VmBJy3Ao4FIId9WIArbFGIKUqKl4UqgjyxQkY+t7R8w0vlQla
	 J7EbaQmaRoQmAAvCJ8M/wZQmpXAewGyDiACCYLAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Paklov <Pavel.Paklov@cyberprotect.ru>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.6 024/129] iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
Date: Wed,  7 May 2025 20:39:20 +0200
Message-ID: <20250507183814.508995203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3682,6 +3682,14 @@ found:
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


