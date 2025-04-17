Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2411225F997;
	Thu, 17 Apr 2025 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914718; cv=none; b=uNNVo0dGkBYjUqhA7dTvkMTaZ7+Pxon4BUfXcrLEjqeOFaUu4O496yJT7QBW6QO3shXup60PsZg7MmGIIiNXVltJ9VvXfpBfIIYA6DYSJxETEVbIIIRGSRu7QhN2ed/sNYrvLJMDUajjl6L3QFVwKk8wuo+3f8LPYsZU1RwJo5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914718; c=relaxed/simple;
	bh=7YW5/AcXe6vJllZWmqrpxaGVTRf7m0Ak6KLMp/SktLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn08pvAreBZpMrL3zXB3mEQ3ZXheVyO8ZLUB3jtFEYjnA1xB1xybJtdOp/woCXkw9Kxa5CZIDv1VjOb25yj7W5Pc7L0r0aDRSdL0NkDqLpI/Zu4Xwl+we2tSi+oNzZIYd0oxlIdLeimiO3sKdk/u3zuU6LnP6MoXxlzyZxsLZTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrAhWTFX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrAhWTFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E5C4CEE4;
	Thu, 17 Apr 2025 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914718;
	bh=7YW5/AcXe6vJllZWmqrpxaGVTRf7m0Ak6KLMp/SktLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrAhWTFX6WpefHZiGw/wYAV+eVYI8U15dWpgImOzer74EHRgLCX8O2QdPBL28cx+8
	 oTHBCkyk2J9NxNWhNP/XLCnyIRETKFjhaBUltfZ4tzJDLOtrZBT9JP/giJExYZL0el
	 QhZ/1o9s2HHD3mfIOjfOQiCs08UZH3ODWH3JjTh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.13 278/414] f2fs: fix the missing write pointer correction
Date: Thu, 17 Apr 2025 19:50:36 +0200
Message-ID: <20250417175122.611276920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 201e07aec617b10360df09090651dea9d0d4f7d3 upstream.

If checkpoint was disabled, we missed to fix the write pointers.

Cc: <stable@vger.kernel.org>
Fixes: 1015035609e4 ("f2fs: fix changing cursegs if recovery fails on zoned device")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4729,8 +4729,10 @@ try_onemore:
 	if (err)
 		goto free_meta;
 
-	if (unlikely(is_set_ckpt_flags(sbi, CP_DISABLED_FLAG)))
+	if (unlikely(is_set_ckpt_flags(sbi, CP_DISABLED_FLAG))) {
+		skip_recovery = true;
 		goto reset_checkpoint;
+	}
 
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD) &&


