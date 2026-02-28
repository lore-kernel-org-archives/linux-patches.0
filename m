Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D382D346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302243; cv=none; b=LFBC2W8whkbwvQ3mXEd80vRSIp8aNxuvfNmgBX6NuToBJOzw7V0rASpY0qqTiOP1b+//4OKs1KbDXg9kW4Eews9bN/x6J4nUCW5rAfz+gK+7iDmhbpAzssghpyWwYHPGD7pwJhUUdSK6IwMiSR2aE4lSXi3PrC4MYNJ+tASok3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302243; c=relaxed/simple;
	bh=ToBBrG6yhZj32UEh4WWGlV6l3aOIanYZKl6A0j9k/ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5XS6RslLdnQdSitv1S04u4WPxNnIqfUXhjnX9qweI3xeVjqIouD7JTNl8MkS5BSw3yBzJ/MoVlqxqyHL23/Hk+g73005CpRczjJSMiWXk81w80ahjSwitnwsixVmWRcyQBPkAbJysgz8PtpcG97daW6jOqOPq4NzPK+otZi9b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9b7q+qA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9b7q+qA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465D0C19425;
	Sat, 28 Feb 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302243;
	bh=ToBBrG6yhZj32UEh4WWGlV6l3aOIanYZKl6A0j9k/ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9b7q+qAwLw6Gnqwn9USkRFKDBGb4oZuS+UTCWjCvP46r8/cm6zqBJQpzrQJprqul
	 h880mh43Ltkf/f/DwvZ26XvZQC0l34gLaCTccE6Vv8AtGRPOXK+Lf3z1RioLM/QoUq
	 zrFyQF+YCIQF5qxMoDCy0ieYirhwZXwquyYNQIcJT7xZeGc2G13IQzFLBW0EiahV7h
	 YcmUAwFpKNzx72p6FGOx7y0pFCPVvkVPjiTPCaGwQgGCy0oUpG9V6B2n9ZcZF7VJi7
	 V5Js2VzS08qrjMZ7VyOnIMPiIBmckEBbwhhlulbZTFL0vsltm9s0654vNXu5Sp40yh
	 eQkcfUsPREhZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/283] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Sat, 28 Feb 2026 13:06:38 -0500
Message-ID: <20260228180709.1583486-256-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit b2bc7c44ed1779fc9eaab9a186db0f0d01439622 ]

In the 'DeleteIndexEntryRoot' case of the 'do_action' function, the
entry size ('esize') is retrieved from the log record without adequate
bounds checking.

Specifically, the code calculates the end of the entry ('e2') using:
    e2 = Add2Ptr(e1, esize);

It then calculates the size for memmove using 'PtrOffset(e2, ...)',
which subtracts the end pointer from the buffer limit. If 'esize' is
maliciously large, 'e2' exceeds the used buffer size. This results in
a negative offset which, when cast to size_t for memmove, interprets
as a massive unsigned integer, leading to a heap buffer overflow.

This commit adds a check to ensure that the entry size ('esize') strictly
fits within the remaining used space of the index header before performing
memory operations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 2a1aeab53ea4b..598b7f42b5e7e 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3431,6 +3431,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0

