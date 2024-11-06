Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848F01E048E;
	Wed,  6 Nov 2024 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899192; cv=none; b=HiIpxklDQ1kdfJm527wGquVz/C8mjCDy5eaepYHvrOf5FPBUtnzYAdnftgBVnaKPxWjAFH30oYL6dmNnSK8/c53rJ5kNIf+w/ilgDpz0L1Tw9/3yezplr1VyEJsPryCU97+/zz7HpkuGiVWt/6nYhbJ/iphaXpysNfVP9sHsVbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899192; c=relaxed/simple;
	bh=/UYgAEfSePERiUGMoObSQUqp2jiHpbb0vXKTJPjwndg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ba8iakbPwwHRpKtIf/hBGJpBpmGl+LUFJZ5DhuMNu27gTXnGVyVDCma8ayUnDMdjG5pXt1HzOtwF5PdujPZbrgFyynIboBAOO0hUGkdSjzLHnAOT25dI3oVDxggBMP9KMKJSWszdvEOUNvfpbx9yuH29BICRKDCrL6DlvaQjLSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjHOa3rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjHOa3rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D35FC4CECD;
	Wed,  6 Nov 2024 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899192;
	bh=/UYgAEfSePERiUGMoObSQUqp2jiHpbb0vXKTJPjwndg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjHOa3rnXJPDuGFrVWK90XYfn19Zzqgc6+bR8q2ouBNYm5UtPbZ2qtWGF/l4gyRUF
	 TDMvgfEiUEXn9W+vbYGFWNBqzhS+kNBLXYSuFQyWMHDhbwRgZFV0dozE5FKqFJi7tM
	 0RgPZ1gq+Ap1KZx2FF2Lfzw6fhrEjboPn5o9BGCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/73] fs/ntfs3: Check if more than chunk-size bytes are written
Date: Wed,  6 Nov 2024 13:05:34 +0100
Message-ID: <20241106120300.862962521@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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
index 28f654561f279..09db01c1098cd 100644
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



