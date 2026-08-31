Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B78E43E078;
	Mon, 31 Aug 2026 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184721; cv=none; b=Xiwi8y/ZlwOSj7sC30Ew+Lsbsro+7jFP7XgkBVwItwjoCLzGuRRwVj0qMCb1n5ztNpyVg6qteqjnD6oEbw10OF1vrorSqavFzks7fuosBeJSL/uASwGmWs6eIkM/RRttU4A3Dp1STvFm77ctQHP7RLvyzqF9T/DSZyN3qc0Dr5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184721; c=relaxed/simple;
	bh=C1TpBTqKngi7N9doM2n8DeE0LWUXCuB+i/Dj890sEcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srDyqqD4yvpk8NtWxV8iJ20GiMV+mvRLroHh08Y8FPsQj6CQq4fCZYpolZCouNGftPuyZtHHlk+5VkiLkE5rAsyfwkettJQyhZCBK9DDAFR42W9/sRl/OLQ5AE+sDdoy7XQCvrY+8M4Aw6FjylTMrGElHlW1FJ6jnwyp1hCVNw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Te/AhkSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Te/AhkSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA631F000E9;
	Mon, 31 Aug 2026 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184719;
	bh=qLDuMp6IBme2mnMRmSwdy9xC3rX4qA9N06gWhwfYujM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Te/AhkSVLjvfpork/BaMsoBk/bZe0XNDn1MkwEyD3HAKQmhghLlr73r3Q3MDY60iw
	 JNcD/xyFtqxfotdErbN31ucjMBlHiiXbEb5OaTdFqXHsMYDz4Oj6Wk1FuDrhDqOLU3
	 EbmwziHqvONl+6HzhWSCU5fes7YMsqPAkl9bKheY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianzhou Zhao <xnxc22xnxc22@qq.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/92] exfat: fix double free in delayed_free
Date: Mon, 31 Aug 2026 15:34:13 +0200
Message-ID: <20260831133400.318826435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1f3d9724e16d62c7d42c67d6613b8512f2887c22 ]

The double free could happen in the following path.

exfat_create_upcase_table()
        exfat_create_upcase_table() : return error
        exfat_free_upcase_table() : free ->vol_utbl
        exfat_load_default_upcase_table : return error
     exfat_kill_sb()
           delayed_free()
                  exfat_free_upcase_table() <--------- double free
This patch set ->vol_util as NULL after freeing it.

Reported-by: Jianzhou Zhao <xnxc22xnxc22@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/nls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/exfat/nls.c b/fs/exfat/nls.c
index 705710f93e2dd..0e05c6b5a2864 100644
--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -804,4 +804,5 @@ int exfat_create_upcase_table(struct super_block *sb)
 void exfat_free_upcase_table(struct exfat_sb_info *sbi)
 {
 	kvfree(sbi->vol_utbl);
+	sbi->vol_utbl = NULL;
 }
-- 
2.53.0



