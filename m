Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7D2C324D;
	Mon,  2 Jun 2025 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874462; cv=none; b=GbaTJ44vNP6f4zClaFj1PR9MzstBd0fb9k/2LN80MDWSYiVm5AmLod2Q0L1VLleHdKWUWvIqsM2u1t3ZOAPPE+vJSw89uc04vjNF4TX38PokKCgypMVTd6xkVdzronlNZso7jkAhz+KEaqbDiHCNzLm7jZgcqr1JCZk6X5n+7iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874462; c=relaxed/simple;
	bh=vhz1JRrGAH8NRxOAdP4hRudbvwKjt0cgFxkZTfOVhtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khitK7nu4wUSvaLFT1B1i9IHuk3/8f57oLkuD2ASJatLB/qd36Ciu9lai7nw8zSZ+R2ORInBwCtm4iJhlQfk1wGLWfCyMZmQHPR/PzqazUvgcam/YQlwJpq8aJHK33hUACxusD21iP2GKF5SSgHtu6dMJuNWTz0cPYiFZ/8VplM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D2V31wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D2V31wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3573C4CEEB;
	Mon,  2 Jun 2025 14:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874462;
	bh=vhz1JRrGAH8NRxOAdP4hRudbvwKjt0cgFxkZTfOVhtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1D2V31wHODIccK1YqYdzPAWo7jHQ0C6odBjEfKEqxdj+RhtngOYxKRtUFW1vyXHZh
	 4smJeXzryqe8/TcBu4SOizQZ9P0nrFahuxOXn4U6gdwS3K1DIDxE/96aLgogIrsGKz
	 idlGbXvFCdO9kAAwOYe6e4OFIcGi7HNgeV1kqKgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Paklov <Pavel.Paklov@cyberprotect.ru>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/204] iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
Date: Mon,  2 Jun 2025 15:46:04 +0200
Message-ID: <20250602134256.903879813@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Paklov <Pavel.Paklov@cyberprotect.ru>

[ Upstream commit 8dee308e4c01dea48fc104d37f92d5b58c50b96c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0abb714fdbf10..de29512c75ccc 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -3124,6 +3124,14 @@ static int __init parse_ivrs_acpihid(char *str)
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
-- 
2.39.5



