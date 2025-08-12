Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BAF1EBFE0;
	Tue, 12 Aug 2025 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022881; cv=none; b=mh6FJA/BdiQb54mJYgtf7NXh0RZpZRSMciGmSf8hoLdUFfLMaoibVx4gNpuTEbTpy31L2vDgsezVNmCgZXv/wOnnbbIaTlHAA0QsyH3sm/UkHrzU1Xd1OQQFR2ijqVwK6DrvWw0ep8saWDNC7jmEQs28cebPaoOoXc4yyXTUQkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022881; c=relaxed/simple;
	bh=64r630jbVa5PLttT0srOWBAHtoWF0bTf4iEpcnjeNaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1RH9OH0YgB0I7to+81aZbcpTE4NtmIip7JIb5oH5m4yL8zwWh5yblWvZmu3QjQmlnC4dcYqxkFXG1NpKzENE/LKoOxp/VDAragnLtsdSaZyoQrdE9OxDWaG9xPXwqCtnZcFcEeduUHaYME2XuE2mVMzNnM5kj/82LqX4vanR4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtQBSak8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtQBSak8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5AAC4CEF0;
	Tue, 12 Aug 2025 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022880;
	bh=64r630jbVa5PLttT0srOWBAHtoWF0bTf4iEpcnjeNaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtQBSak8A0UW11vDV0MI/X6QOrzwTt5l/Q9Qia+zo4SJBbvIVOZfc0NLLX6mx1wIg
	 mOFrhWv7H7rV6mMvPMotBWcjNzROuEo6+jyBX+ykl2k/7i8en8t4UclG8yCTly8XDz
	 EyIiH9QrKOslRQ/C0pEV3CUYQUUomo2VvHJnZN1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 254/369] f2fs: fix to check upper boundary for gc_no_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:29:11 +0200
Message-ID: <20250812173024.314097272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit a919ae794ad2dc6d04b3eea2f9bc86332c1630cc ]

This patch adds missing upper boundary check while setting
gc_no_zoned_gc_percent via sysfs.

Fixes: 9a481a1c16f4 ("f2fs: create gc_no_zoned_gc_percent and gc_boost_zoned_gc_percent")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index d79d8041b8b7..eb84b9418ac1 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -623,6 +623,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_no_zoned_gc_percent")) {
+		if (t > 100)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 	if (!strcmp(a->attr.name, "gc_boost_zoned_gc_percent")) {
 		if (t > 100)
 			return -EINVAL;
-- 
2.39.5



