Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8A3218B8;
	Mon, 18 Aug 2025 12:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521835; cv=none; b=ooSKYzXz2XWHCk7ZTNI4Gz1jY83cVfYCq5550FDbJkBF6dCowXgFb5QPrXtZaD164JREhrYKcwgBZqadm6gTFf0b8RTGt2NvHRtw0BD4vq1fOgg8KBjzRjIDmRNcGKKyD3R4R9nFvwpzpMSEgsHVVdmZWCo5g4yAHxbnwlF78f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521835; c=relaxed/simple;
	bh=P4UvKsKmop1+EYNBilNqpU+0saO/k1G7iz3BmIZ8acg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvTChtOadgAC8KOk4FQY7g3+8TJG4Kb1wdrQ0cSu1stjgVUpvFt6tHr5RZXZgBkpxgc7dW4d4sVHbnjXg80VbKipCG+aTHpYRnXft94iloE87TJnhXDR46Ax4kIYQMvR/E55jbK3ZV1mfx12HykOkIiU7gs7b1qiP4k9igHy8Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJxUBDmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJxUBDmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D726DC4CEEB;
	Mon, 18 Aug 2025 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521835;
	bh=P4UvKsKmop1+EYNBilNqpU+0saO/k1G7iz3BmIZ8acg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJxUBDmVZtMrnAf370voVY4Oc6GxqOC1kvWtvZr/TsFQAwlGm2ymdN4cLGae6WmGG
	 hLwjU+2P6GbAsz7CYtgeIn+UgKyMMqdALrnLci8AvA7X/mLbtmBOipduH92l4KOC/E
	 aaEVBeyJfp7N5obFGIP5b+hWB3Bz9gcrpoe0Y0OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/444] char: misc: Fix improper and inaccurate error code returned by misc_init()
Date: Mon, 18 Aug 2025 14:42:42 +0200
Message-ID: <20250818124454.008285590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit 0ef1fe4bc38673db72e39b700b29c50dfcc5a415 ]

misc_init() returns -EIO for __register_chrdev() invocation failure, but:

- -EIO is for I/O error normally, but __register_chrdev() does not do I/O.
- -EIO can not cover various error codes returned by __register_chrdev().

Fix by returning error code of __register_chrdev().

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250620-fix_mischar-v1-3-6c2716bbf1fa@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index dda466f9181a..30178e20d962 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -314,8 +314,8 @@ static int __init misc_init(void)
 	if (err)
 		goto fail_remove;
 
-	err = -EIO;
-	if (__register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops))
+	err = __register_chrdev(MISC_MAJOR, 0, MINORMASK + 1, "misc", &misc_fops);
+	if (err < 0)
 		goto fail_printk;
 	return 0;
 
-- 
2.39.5



