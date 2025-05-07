Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715F914A4C7;
	Wed,  7 May 2025 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643473; cv=none; b=TUPivpExsOuyfSei1VO+al0ZnzAAl3Q1vJyQbmajMMPj+dNIQnZrdSR9rCkeazJvrjZkd3ScwZtSWRT3JKr+qkJ7ZBUgexMU0HcuWI8RwU9W3Ov6vRzKwu5RtVo6eOJO4By14tEbJHoBcGVrinbhvRGGZl+15yTl5ZBhAIeS2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643473; c=relaxed/simple;
	bh=FCeKJ/Hm5vZsF9h5LUVTtkL94gMaMbv/M+4nTD4/IHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUZnWrPbO4JbczhbygiRBHbS7Br4Tfh5I7ieqYoBraPQCQXM/F9gyzegFlCb+vyTV2fzuWd/jsjLd5A2adwi5RKhkJdI7TgTzfBqgqXd8zmqjhJmhxgXapxQNa6S9gx46FdwLhn6T9MHdsOW7/8nFdMacs176HeCGaCB1mqQvVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exn6REtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exn6REtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D83C4CEE2;
	Wed,  7 May 2025 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643473;
	bh=FCeKJ/Hm5vZsF9h5LUVTtkL94gMaMbv/M+4nTD4/IHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exn6REtEqRz+cRa3lN3UXTRmTBeWCpoSOf8DKVWRedJZZEfZbPB/ANMQM1zC3wan3
	 wJ05ZxpsvUNIcR4xDTxTRgvUz0SNhnFsRIyI3X13kB4e8paIe/6XXzui9KReIP4fVL
	 VW3M0XZFL52hBJM17ptySvtZ+h9hvXVO46cFpuEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Paklov <Pavel.Paklov@cyberprotect.ru>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.1 16/97] iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
Date: Wed,  7 May 2025 20:38:51 +0200
Message-ID: <20250507183807.641944031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3610,6 +3610,14 @@ found:
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


