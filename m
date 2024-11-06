Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E18A1EABD7;
	Wed,  6 Nov 2024 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897059; cv=none; b=MbMvGfuko5XZgizWS7BOhyCR3xcL0XRYlfftlYsBszLDLuinNZUOCFc/UNvsAJNM9GgeiM8mBVxDHQ9gpAToZAv6rrGUCKd9CL4SNU/jMjdRb8aCWFWAH4ULTzh4vNbL0dSIGzhd+La0NTtgtCjhvyQeDOcd35M/0268SfdWpiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897059; c=relaxed/simple;
	bh=MNMTUf7XzaFA4sZnd+eQLaZmC8rI3brwe2SeJwQDtdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yf9LZfduKvMGCQ3T4pEwfVh9RjW3e5lorqHopbn1zgN7UpsQPpvYq8PeIdwfwyFGizz4yBzB7c/QvNyiPFPsnFBJa50wYxFXCwov9Aji3yw+KarMCraRTt7wnNTHQLQOur02+rWkXWNa4XeTy3hmHT/Em1fT7tjTvH+A5ql177c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhfvRGKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhfvRGKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1ADC4CECD;
	Wed,  6 Nov 2024 12:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897058;
	bh=MNMTUf7XzaFA4sZnd+eQLaZmC8rI3brwe2SeJwQDtdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhfvRGKKRIlDwJTZzqYKqDzeH1bZpuFod4+KsfEc5D+P7FkHph2A2MSxfHZKceGaD
	 lglKhUikb6Vu8/3/k3L21O0aWAw9czdifJtwk5JjpaalxKwshS/8GSxzBo/ViYFhrx
	 5QELEa/G/W9YwmQvY1Gvrv8xynA+NngOtXSxiN/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Ballance <andrewjballance@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/126] fs/ntfs3: Check if more than chunk-size bytes are written
Date: Wed,  6 Nov 2024 13:04:13 +0100
Message-ID: <20241106120307.506944613@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



