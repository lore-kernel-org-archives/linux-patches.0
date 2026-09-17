Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15884F55D3;
	Thu, 17 Sep 2026 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658911; cv=none; b=V9RTINXa4wP1Cg4puSzbP8/fQrXRs9yatRlRxdnd1reO4whD7J2Ys6MylmDYk/ouo5SHC8+lNANxRgkIN/4LSSQ2LM/hvDJrxT9ySWrKmCqXgaCYKXgwpZ2pT4KTW1YR6L6S1buPMrA5vm/tWh0pJj+bSAy0L324ton1jyjZsgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658911; c=relaxed/simple;
	bh=gC4dqWCCBkce8E/O1FMpcCAdgyTD0Zt74+D0q0obDKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7LsM0mji2H805advdcxkt9vkX+LX57LOzGjybWVSWbjbtEAwZrPj+zroBGMDXwCjzkHV3WAK8Wr/fPbxEMiICPQ3mkOhk9GhojddyU71ma0WyJRCvmlKpg0GyPIvtGzAapm4zPKT1IXiLUwtdV38wIFVe6kbVQU4X/+Dew+pN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLRTg3Ha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLRTg3Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44A11F00898;
	Thu, 17 Sep 2026 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658901;
	bh=IkGiVBU5BW0EpBF6QR1yg6onytlTZ7yZjAU5CeEMR6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xLRTg3HaKKkyRT6wbSeX5P071CSeN1WliWP0UGOk5iHR1X6As0jRYjk8uBYnWlRUO
	 jgrFkd9NjUgaLjwzIC74pvmHMoSf47NRRWyZ3ldjcMkEWeMQrcirMY3vP/DflOBEBv
	 HXCdfemwxeBcrTWDne0ZNG/3wjYGTHzpLj4f1m+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 040/733] ntfs: preserve error code in ntfs_resident_attr_record_add()
Date: Thu, 17 Sep 2026 16:05:48 +0100
Message-ID: <20260917151351.753424140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 8efe00b098b5b3618c885d2a35a5edccfbfbec7d ]

ntfs_resident_attr_record_add() collapses every failure to -EIO at
its put_err_out label. This defeats the resident-to-non-resident
fallback in ntfs_attr_add(), which relies on seeing -ENOSPC to
convert the attribute when the MFT record has no room, and also
hides -EEXIST and -ENOMEM from callers.

Return the actual error code. Every path reaching the label has
err set to a negative errno.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index b4c6137c037b6..fbb1c5f4da18a 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -2495,7 +2495,7 @@ int ntfs_resident_attr_record_add(struct ntfs_inode *ni, __le32 type,
 	return offset;
 put_err_out:
 	ntfs_attr_put_search_ctx(ctx);
-	return -EIO;
+	return err;
 }
 
 /*
-- 
2.53.0



