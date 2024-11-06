Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BB31DDA15;
	Wed,  6 Nov 2024 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896188; cv=none; b=PR56Cob5hnVAL65O3VMqXlHuQizkzRxs1EL01IHXBgNgxUa4PEzmHEqw4GXKZdm7XDLWMDBUW8u8kovpKSozGxbBElt8/vvUY/u33M6WfyIiXxH7fJZAmpZJXgg64b4fyzyILBhnsPx3PmEZrvBVdi6BymPt89/2lhPRyO6rT4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896188; c=relaxed/simple;
	bh=ODpBx5dwom3v1c1djb9e8CV/vQMFvxajqfsEGJjENnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOgs4MhXECS+toZuJbQe+U4szx99TtMYy+AHoCy+E78vy9RdQjFdz9T2ZZT6kajgtjp3pOWsHx5bBB9PhrUo5GOWevKM6a3CtFoVKEIT9kLdk4ecQzi+Y9TfOgo+HoxkRNzkCZHvkg6ILZCAmJbjcfxOn2QwAsMHxCXOQSNcUCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLPo9vRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLPo9vRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC66C4CECD;
	Wed,  6 Nov 2024 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896188;
	bh=ODpBx5dwom3v1c1djb9e8CV/vQMFvxajqfsEGJjENnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLPo9vRLBeNGXBQVVGbUDrcAe2WNgdQeBVpYdAM+nT0lt9I+HsESgGIagUoU3dTa/
	 pspb31wnSQIqV1LOKo7xCCgUt+5fcJHAcXW+cd/NX1VUDEoFbD+ucmUNr4IgiuMv4n
	 fb3i6jGQATaHnejkr5lRkwzJUXvANkl8bM97NOWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 083/245] fs/ntfs3: Check if more than chunk-size bytes are written
Date: Wed,  6 Nov 2024 13:02:16 +0100
Message-ID: <20241106120321.247702981@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Ballance <andrewjballance@gmail.com>

[ Upstream commit 9931122d04c6d431b2c11b5bb7b10f28584067f0 ]

A incorrectly formatted chunk may decompress into
more than LZNT_CHUNK_SIZE bytes and a index out of bounds
will occur in s_max_off.

Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/lznt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/lznt.c b/fs/ntfs3/lznt.c
index 4aae598d6d884..fdc9b2ebf3410 100644
--- a/fs/ntfs3/lznt.c
+++ b/fs/ntfs3/lznt.c
@@ -236,6 +236,9 @@ static inline ssize_t decompress_chunk(u8 *unc, u8 *unc_end, const u8 *cmpr,
 
 	/* Do decompression until pointers are inside range. */
 	while (up < unc_end && cmpr < cmpr_end) {
+		// return err if more than LZNT_CHUNK_SIZE bytes are written
+		if (up - unc > LZNT_CHUNK_SIZE)
+			return -EINVAL;
 		/* Correct index */
 		while (unc + s_max_off[index] < up)
 			index += 1;
-- 
2.43.0



