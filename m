Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E4F2FFDF1;
	Tue, 12 Aug 2025 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024788; cv=none; b=Qmhm30W4+8EH1hyEMhmbVgILJoaz5xxau69VeRYjXHvSIotKZ7QUBg4sb1s1+bV/CPyeU0TaP3j3R/o4yx4MTIK7R2Ejim0+DP8voREia2Qv8x3EnpQ/FbDTiGJ7TUXsBuSmZ3GzDmp8SD/8/Oi6jcDcqkjWTYsDaEE/YeTsMjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024788; c=relaxed/simple;
	bh=4jJtxK81L+OGXnHrd/yfO9lMEEkRwsAVYBcrq+VFfsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSTdLIofinMsnJICFxC2VoVm8eZ6VtzmObPTcgJ0xKhyzqlSwZV+vYYIh3WMFSjeoUFQL9TcBFSWq4ShsYAoD7qRb/ytWbpMgJ+BkENRclIk8H9endgSZrm1tkF7NW0G4zRu9IvFP/xNHB4rygK4fRkMx2w6ClregubUzkS2EJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pFPfcEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pFPfcEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD977C4CEFF;
	Tue, 12 Aug 2025 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024788;
	bh=4jJtxK81L+OGXnHrd/yfO9lMEEkRwsAVYBcrq+VFfsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pFPfcEeskkOisLwTzVcahjRdES48BfAM+dQTLQI6C/wTAZNUXqAH1tiMOvbJbgUs
	 lLO2IdmTRhce5akSfY+vtBqpRXdGgnXNPxr0Yo34nwTggqHC6FugGdN1F9/hOYZ/a9
	 DnIiVPigliuzsFBQFdRVb9mCi59P+j6fDxXwnqIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yohan.joung" <yohan.joung@sk.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 477/627] f2fs: fix to check upper boundary for value of gc_boost_zoned_gc_percent
Date: Tue, 12 Aug 2025 19:32:52 +0200
Message-ID: <20250812173442.376214952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yohan.joung <yohan.joung@sk.com>

[ Upstream commit 10dcaa56ef93f2a45e4c3fec27d8e1594edad110 ]

to check the upper boundary when setting gc_boost_zoned_gc_percent

Fixes: 9a481a1c16f4 ("f2fs: create gc_no_zoned_gc_percent and gc_boost_zoned_gc_percent")
Signed-off-by: yohan.joung <yohan.joung@sk.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/sysfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index 75134d69a0bd..d0ec9963ff1b 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -628,6 +628,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "gc_boost_zoned_gc_percent")) {
+		if (t > 100)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 #ifdef CONFIG_F2FS_IOSTAT
 	if (!strcmp(a->attr.name, "iostat_enable")) {
 		sbi->iostat_enable = !!t;
-- 
2.39.5



