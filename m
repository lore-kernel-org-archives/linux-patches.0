Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EC12F2D;
	Tue, 27 Feb 2024 13:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040753; cv=none; b=VaOV60AXQwBnnZ+RNm3/67hboc/H+/VJ2HaqhL9C/wsTrWsGpqFC6S1WXmW1UZd9V/WrRoPPbKE/g1u/Uf8Q/oiLNYloSEwbfGlu700rPAJuaoksSEu/Z2txGa3sT8lrZycqiZ3pv9raW1FyC2N0cYV682q5+qnbNH0vXBUk1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040753; c=relaxed/simple;
	bh=iW0TE7SE692mPT1K9NzPEc4/FllN9J4oRKZjihsQPHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWZ1xf350sq86mfAdTZPuzTQWCee6huuaEz2suMWIn7CE80j2Sq+9sjL9TjTHFzcR5G8U5pmhE7yiXZBHH3OzKHkeNd/3wbOtbicxUKuxov6FXm2lHvEyg7mNydn3/Ku8eaeZOtgnlo6cizkgc99F7qljqU8wZwsABtFFLtr54o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGsXMm8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGsXMm8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83630C433C7;
	Tue, 27 Feb 2024 13:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040752;
	bh=iW0TE7SE692mPT1K9NzPEc4/FllN9J4oRKZjihsQPHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGsXMm8W6gF2LRhMImEPzJnouIEEZ+jlpifDwhOz3G75LofTUYAhMMA9eCtb9BiCo
	 gX+/wsx6RJmyOwNhtmY1rB1Pobzclyu+3xTrL6FoGFISphDPdkESKlPRPw9+/OB8ok
	 8K2n2vN+dR7gtYQKCjXWuBxlDrneVXd2LEpJtDSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@csail.mit.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 098/334] fs/ntfs3: Fixed overflow check in mi_enum_attr()
Date: Tue, 27 Feb 2024 14:19:16 +0100
Message-ID: <20240227131633.664060965@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 652cfeb43d6b9aba5c7c4902bed7a7340df131fb ]

Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 7b6423584eaee..6aa3a9d44df1b 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -279,7 +279,7 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		if (t16 > asize)
 			return NULL;
 
-		if (t16 + le32_to_cpu(attr->res.data_size) > asize)
+		if (le32_to_cpu(attr->res.data_size) > asize - t16)
 			return NULL;
 
 		t32 = sizeof(short) * attr->name_len;
-- 
2.43.0



