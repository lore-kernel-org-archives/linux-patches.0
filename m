Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309A1DB148;
	Thu, 17 Apr 2025 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913340; cv=none; b=V/XMFPzR1/OKAweIW5LLL0XkMYxYMdGuYkvUSaZ+1AphmDJBGPP2Lu2vzEc8XUFhJUrr2GrJLArnHSkiDncFJmts4+IY2v5sxqM2XW92dVXCTQCqaBkkwBT/xXDXmufPHUCQy8Uy/mBek6GvRuvucDTyGCWKOY8ADmqCR7YO/9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913340; c=relaxed/simple;
	bh=aVsnTL71g05JmXAneNWW6TH1Qk0nI8n9eQqvohNkcxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPFF1REhicW65nYCswZzysZWiai37rKOVfXS+ZyoRgIbI9N4I8TrOJRIQwAsMa2yDuGwy4FvC1QlXikBwz+MOCwrjuxi3kDwc2GYymUC/LB/fwd+w8LUgBiK7XO+ErYqziMHH2nlcHDZb1qu92hI4A9KL35Y5YPygecG2KOH504=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUhZltI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUhZltI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB37C4CEE4;
	Thu, 17 Apr 2025 18:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913340;
	bh=aVsnTL71g05JmXAneNWW6TH1Qk0nI8n9eQqvohNkcxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUhZltI/r147wgev087PcXelfC9/aPevd1KNIVHfu9fuS+PJPNvgkot8P2k83wRqN
	 Lr/rtPREVcboItPh9AcXT6Esyz6bxi0LMej1lVKuadMF82jLxDC6zDnXKKrkijvkJ9
	 KM9wjL0O8dYqe1bzecL/0F9NrAJ+YIHK9FQUrnoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.14 307/449] f2fs: fix the missing write pointer correction
Date: Thu, 17 Apr 2025 19:49:55 +0200
Message-ID: <20250417175130.466861770@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4749,8 +4749,10 @@ try_onemore:
 	if (err)
 		goto free_meta;
 
-	if (unlikely(is_set_ckpt_flags(sbi, CP_DISABLED_FLAG)))
+	if (unlikely(is_set_ckpt_flags(sbi, CP_DISABLED_FLAG))) {
+		skip_recovery = true;
 		goto reset_checkpoint;
+	}
 
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD) &&


