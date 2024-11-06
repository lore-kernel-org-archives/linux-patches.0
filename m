Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DBC1E0B7C;
	Wed,  6 Nov 2024 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897447; cv=none; b=QFhjk3aWLnhHGWN+x8iuZQGhPC4wJDnFNYl4vA6z1NSfTb6GeuSQNGSPBrUx+ATyltV0JwYwOX5Oc45FzPnX02jlWMhSxciPIMQwYjawyX2y5qT4+XBWngLkpSXCBSQoGLg8t+EMDqLRWLBQ7aykLfZbnsr6ryFQNzDXRbTL9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897447; c=relaxed/simple;
	bh=GPnnOKSp57biSLO6PLAG82Qp0Atta0wB7MafzQ/9VRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvfRFAak/EnOpVlEv+cYe88lk+VGr3sEZWxnAU0cUtYMRyJ+yOZgRZ5PEtTTlhissQr8NpTmlFKQSiQI8AkCI/4H+5P0MRkWhsEjufYCwjeHaAgwE905pWZnW7/rMAnw4ljISrG4Po/rRrl9xcLN4z65/chAJZOoBQSoso5DhQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INMpPCUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INMpPCUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7AFC4CECD;
	Wed,  6 Nov 2024 12:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897447;
	bh=GPnnOKSp57biSLO6PLAG82Qp0Atta0wB7MafzQ/9VRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INMpPCUHuJVNsl+IqNuB5/d0g9pHIzbS7Vysxqf712hg8ztRt4jW7VhDeKcrTUvTQ
	 DiATjsSveLIPm8vULe5IvAsADJ9Hb3ktGw7jKoKtdhCpl7JlVuj2gsDB0PWhLJXBzF
	 cXhXzGAtaJuRByvfUZQAYRqJnqM7+VipjsRqg7qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/151] fs/ntfs3: Check if more than chunk-size bytes are written
Date: Wed,  6 Nov 2024 13:04:04 +0100
Message-ID: <20241106120310.379487290@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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



