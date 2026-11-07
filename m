Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062462;
	b=raVGSZun3eYa1LhoIQbLLcbGqF+xQTTvA4hnZbF7mSummxu6pSmBJoZMMgy75aPje2Jn
	 VLYcNMIQnLoALCqpcC723/uuUBi+xAtutdHiG1B0iv8iOUQikC7Sp+PscGmjUSkqPfSRe
	 Rcn2AeKnjtaM9lsG6tgkyImgA8Op9/pFLLfdC2VStLaIhshtGVfa6L/Q8h5ajCpWFxqv1
	 pUsedoFw2mBfHOsnOUuNl5yW26mopmCmh29yhqwwVPXhEALTSgeP/nLPKD0VOHJnKJ4n0
	 WZ//DVjdeXjDZ/iOqabDe/vlYZWmsLKyI8ahyJpA/e44T0K6xphKn+zluwceqS/2pbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SUCfv7IrVHsfYvypXDf3mHAHyf2hsqxtz0Jz8D3s1+Q=;
	b=zQYiQR/pAxKpVknQ5HQ01j90seYPksYigJgPspGs4rllbaNhGvqz7K28oKP2COprjw5h
	 iIK+igKX636KSrJH2LcjU2PeDUSOYHKKxFhdLds2SVCMgthHofsgbWDsAEQp8P0K75jBJ
	 sCNWqMS2OWVSucnAXSsibV4aeTiKIZHahDTxGnnElwtjodHFsj3jU6V2fpGJE63hF2M3i
	 iBd+gz2GPZvLl8WM2tBuRYUoVtEWQNYEbdBz3hakqZBwBR4VGKPmKMB8hxRE+d5KejwAG
	 31NcZ1lBlaNQTFjW/H2lFIonXMNRSXdVijSmo/CwE92XyOEZjkUYMLyy+tgsp94UFKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/CEoxFE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA62B606A642;
	Sat,  7 Nov 2026 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/CEoxFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774071F0089F;
	Sat,  7 Nov 2026 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062461;
	bh=SUCfv7IrVHsfYvypXDf3mHAHyf2hsqxtz0Jz8D3s1+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/CEoxFEdkHMxt7RtMF9xjZP/0U+e08CzY7CfBt3BZp0LlsfLg9GH7+EHRJUwi1xk
	 czJNUTLTgG/m5JF3hx3dUxURVr9VRRovPaEp/1hNIZa2L6Nl31DyLTu2Tm6t5aJ/iR
	 ht5rCurRhkwmZ1pQNm8FgEMuv83g/TX0XIDrZl5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1360/1536] f2fs: flush SIT journal during filesystem resize
Date: Sat,  7 Nov 2026 08:56:16 -0500
Message-ID: <20261107135036.031197792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qwjhust@gmail.com>

[ Upstream commit a6ede405455106bf42164ec96fd84008c5aabdd9 ]

During a filesystem resize, SBI_IS_RESIZEFS prevents new SIT entries
from being added to the journal and forces existing entries to the SIT
area. However, f2fs_flush_sit_entries() returns early when there are no
new dirty sentries, leaving existing journal entries behind.

After the main area shrinks, a later checkpoint can access a journal
entry whose segment number is outside the new geometry and trigger
f2fs_bug_on().

Only take the zero-dirty fast path when entries may be written back to
the journal. This lets resize drain existing entries through
remove_sits_in_journal() even when there are no new dirty sentries.

Cc: stable@kernel.org
Fixes: 04f0b2eaa3b3 ("f2fs: ioctl for removing a range from F2FS")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 1ec43e1537fb2..6abe435b9f0d8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4553,7 +4553,7 @@ void f2fs_flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	down_write(&sit_i->sentry_lock);
 
-	if (!sit_i->dirty_sentries)
+	if (!sit_i->dirty_sentries && to_journal)
 		goto out;
 
 	/*
-- 
2.53.0



