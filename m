Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373151A6166;
	Tue, 30 Jul 2024 16:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358056; cv=none; b=BaphedaDAIajhLK+u+8pdQTLe/MmtG6AEmUZv6TqF8ASAgCEUkO8juSLlMvjlAEsb2ocpn4Gxj7HhOsQScc0W+wz5WUn1XNtY17E6fZ1hziv2YCPf3HR1Vt0qI14mFNtWrTukoayf50tkKa7uIFLrtQUl5jo+i1wZKTZBCYRKMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358056; c=relaxed/simple;
	bh=KMqOYIDLrOPMQnRcvhlUIGD0VQHX3xTqnX7DoTgWVR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTA6YLd8GYM40x/yiKyTupzE7cK5Ousxq2PUEmO/OHQXcEaFcV/1xFboEDfAPhy+olIfm018SLkD1IYSG3mZcvaBuKkETEoZB+KMjqS0qvNKreRhr00slU9L8W6mSZX1XM2Z62IZZuvvsvVm9Jz2U/AwV3JeyOH8mShe1nYVpW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w09vSypH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w09vSypH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4C8C4AF0F;
	Tue, 30 Jul 2024 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358056;
	bh=KMqOYIDLrOPMQnRcvhlUIGD0VQHX3xTqnX7DoTgWVR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w09vSypH8lhjitcoIHu4P+XjGK9x2TVWJu+/MGCt0rqCO3y20/l+PDZ+ie9yREAxW
	 bParyT+L0xSaKNBsVAHSMEvUkUCDWWFfhwdQEaVJG7C0y/2KvRyG+e7EyrkcldceE7
	 E7ufsLtJov0J7Bxf8stNw5yYHTe6r1kkBa5Dwb9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 321/568] fs/ntfs3: Deny getting attr data block in compressed frame
Date: Tue, 30 Jul 2024 17:47:08 +0200
Message-ID: <20240730151652.422261772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 69943484b95267c94331cba41e9e64ba7b24f136 ]

Attempting to retrieve an attribute data block in a compressed frame
is ignored.

Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index e6c0e12d1380b..60a764ebaf570 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -975,6 +975,19 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 	if (err)
 		goto out;
 
+	/* Check for compressed frame. */
+	err = attr_is_frame_compressed(ni, attr, vcn >> NTFS_LZNT_CUNIT, &hint);
+	if (err)
+		goto out;
+
+	if (hint) {
+		/* if frame is compressed - don't touch it. */
+		*lcn = COMPRESSED_LCN;
+		*len = hint;
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	if (!*len) {
 		if (run_lookup_entry(run, vcn, lcn, len, NULL)) {
 			if (*lcn != SPARSE_LCN || !new)
-- 
2.43.0



