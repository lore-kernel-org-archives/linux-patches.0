Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7EC1EEE0;
	Thu, 13 Jun 2024 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282389; cv=none; b=jRtaaOLCV6E4ZYM3Fy1Sx8iJx79KCo4GIEdk5jV3AA4MRHY8D5ocp3vop/LLI2xPwVMK9zYH6xyEm+gXQ/t+nLpiqdF1WgLjpKaq+rVmGsGsOY5CuQmiVaAB4P/u6cYOVCOZrpGAEvADiVA7bnkYN59YTA+x24fZF0aisuB6aCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282389; c=relaxed/simple;
	bh=8Rz1Y3/je7dXhFgZdrfc8NjbXxJ0e3VWoxNB8fbJI3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ+lwzKvYL/X+dQMqRRftU8Y0i/Oc/upD7y082ogNXRe6NP9TksYRNNmZbnscV6QEilvVKktPWHudlqL7ZV52eAABC/12UBOoG5aIeZwaatf+C9cGQKB1JD5+BSAVRgZq9QpiQxP4OFsdkZm7NTbhS3F0M71AAdckc177GbpLVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhbK6pFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhbK6pFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F47C2BBFC;
	Thu, 13 Jun 2024 12:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282389;
	bh=8Rz1Y3/je7dXhFgZdrfc8NjbXxJ0e3VWoxNB8fbJI3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhbK6pFO5k0NrzhXQXPbtW5FM+4t7jMmeiCvJO9c1kZ8gqVkiOucXG8rOA4D5w0Ii
	 1+IvRsDobDscoouyk6CTxwVAg655f61IME+UGA111aJtfqVezfFJlJ67qb7pPOj/1M
	 a7MwkKt9/05z650buVyWcMQZ58IWBFAuAj1eIxx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/402] fs/ntfs3: Use 64 bit variable to avoid 32 bit overflow
Date: Thu, 13 Jun 2024 13:33:38 +0200
Message-ID: <20240613113312.329267127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit e931f6b630ffb22d66caab202a52aa8cbb10c649 ]

For example, in the expression:
	vbo = 2 * vbo + skip

Fixes: b46acd6a6a627 ("fs/ntfs3: Add NTFS journal")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 6ba1357f3ed4c..369ab64a0b844 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1181,7 +1181,8 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			struct restart_info *info)
 {
-	u32 skip, vbo;
+	u32 skip;
+	u64 vbo;
 	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
-- 
2.43.0



