Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160BF2222A9;
	Mon,  2 Jun 2025 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875048; cv=none; b=G2FalALA2AYl5yE1jRjfJ0Ks0b0p3NcWW6LTLsZ/qqixvMRxx2k4Pq3BCI91VlUbPGKCIwLt8kXKbKnfgF/ZpayFmL31Q8u6QGbwA/Ev7mC+o+tZYAZ+xQnuG3dLAMJ03O31gf0LBeP5EGS5oOu0LAPBYCrMmOvnEKNOM3q43wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875048; c=relaxed/simple;
	bh=U19b0cg3vc0zXucVO2ipJfJsnFycqB9ZniJKSyyRkLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZkyskTNxTl5lSTPJCEDc3NYct91QRGUI3DAcsOMHaPaZfpsv8BZLf1+70ivWlw0DESVdOwyurxrAeTd8SHC1cU8WEnhBNx0JDOHuSELRN1G/d0Nci5rYZo6LYWRDfTz2hm0pJXb8Y0Eb2wHpPbpELqR3t+/sX+wjaYxyCBlHzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDWAaBxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDWAaBxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8CCC4CEEB;
	Mon,  2 Jun 2025 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875047;
	bh=U19b0cg3vc0zXucVO2ipJfJsnFycqB9ZniJKSyyRkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDWAaBxTklntiSFK1uj0wKcMFyx35Hc75ygCdY/SaoBNK0Ya4f6z/wUNq2ATZtFLv
	 bFbg/Dmv3+0PBouJWS46Q/j/Wmv7LBkjqX9VCZTOkKvVFdXAa0I3d9OeZhmQQAfaR7
	 BF3/z2n5oGagdc1CgmUW7cUKjrDfYOV6msNJ3t7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Paklov <Pavel.Paklov@cyberprotect.ru>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 012/270] iommu/amd: Fix potential buffer overflow in parse_ivrs_acpihid
Date: Mon,  2 Jun 2025 15:44:57 +0200
Message-ID: <20250602134307.697408597@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3243,6 +3243,14 @@ found:
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


