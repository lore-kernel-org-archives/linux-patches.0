Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435D91D5141;
	Wed, 25 Feb 2026 01:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983520; cv=none; b=nqhWHp2BY7x5ZgfuBl1pIlsSoUEIuyFiK7gniv2JML6hgyhgiLTofUDX5j3/uIOXiPPrXUqnyWeNtEKng21xuJg2CP7hO/c4uIAMFfqQmQzOIRJBZjgpkyU4FXySLNmn4HWMTZm+5HnlPDRr/XKev4I841vR2Ma9UGQsIDJ+sHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983520; c=relaxed/simple;
	bh=sB+I6BBpZRtA1mAk30fNHuCqdb3IAHGlafK8WVohLGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UK31j3K3jG2ZWgPhJG9Od99xF034ruXhHlXNXgxSp+gFiDvmVR3e7jsmRuKQt0vLMtstXHB1N+5ms5awoEc6evlwb5Vx8uFmv7rl6AnDSpEKmv1XCLw9jSgLr+5I0CH+UfGbuYDTMej+NAv0gysvBoWNvyYAR9lX6K9yatsM2x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuTVqQim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuTVqQim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE5C116D0;
	Wed, 25 Feb 2026 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983519;
	bh=sB+I6BBpZRtA1mAk30fNHuCqdb3IAHGlafK8WVohLGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuTVqQimJ5AM5SEERv/z2VFlvlKM2nHayqPOpudUOJc6XwZXuzHTrcNAiEE/K1jh4
	 d01ifk+d9F7iK9WCGprC4DPvN3WjCSzBQ1qVu2Rt/p4bLlqsouEfN35Y+rW0mMY/i2
	 ZvrdWvyn/Y9W0qbDzs0FEh9HJFy2OBPTa9bXs5AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 620/781] fs/ntfs3: Fix slab-out-of-bounds read in DeleteIndexEntryRoot
Date: Tue, 24 Feb 2026 17:22:09 -0800
Message-ID: <20260225012415.018758421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 38934e6978ece..28bd611f580d9 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3429,6 +3429,9 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		e1 = Add2Ptr(attr, le16_to_cpu(lrh->attr_off));
 		esize = le16_to_cpu(e1->size);
+		if (PtrOffset(e1, Add2Ptr(hdr, used)) < esize)
+			goto dirty_vol;
+
 		e2 = Add2Ptr(e1, esize);
 
 		memmove(e1, e2, PtrOffset(e2, Add2Ptr(hdr, used)));
-- 
2.51.0



