Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BD31EEEB;
	Tue, 23 Jan 2024 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969522; cv=none; b=SdlNbSGd5z1OqkLK1ADRsMT63JUCDJgA8TZeeyW8pfx3tS5kyQUdao3E4+iP5I78U1jD2DeioZUYx7RIiyoMBrHFMTPtaRgDOhaTHK+EWDXzhUdyoUsKVYW7rpa97sFQOyIovomEZonYUMnK1IULqUk4JO6fk5C46Dtgk7Jmxn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969522; c=relaxed/simple;
	bh=wfM8h/+H/BRrZztxNf0NJ0HK9y0+l9lqFAaBwtqSWjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdTm5MOSmoJpauamxTbYS2ksNb54JEFqsudFll0A4MAe0N6g+1gUXGi0qo3irStPp1q8xgIT3oNP+eYyRvuJWWej4pLVCqFMMp/OthrKzY0KJFn3cksPadLYlsyxTuIfuk737ZurqK2UGh3rmTWPVPA3ARN926LIr7/3LLo3cpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QR19QYPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QR19QYPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C833FC433B1;
	Tue, 23 Jan 2024 00:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969522;
	bh=wfM8h/+H/BRrZztxNf0NJ0HK9y0+l9lqFAaBwtqSWjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QR19QYPB98shfCVFwqOtDVjcP6DbyHT8pSSGBd6zn8cokTlGjbXRvKnI2CHFdNnnl
	 RhklzJz+Ut6hYxXCt+T75uO73S7ybeP4NgxLbTVZKbAYvDIwYezJX3UUwYPjG5Ujk5
	 nMAYnCC9lbOi82++WVQwypWuOeXFQSY0N2tPUSwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Rosenberg <drosen@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 303/641] f2fs: Restrict max filesize for 16K f2fs
Date: Mon, 22 Jan 2024 15:53:27 -0800
Message-ID: <20240122235827.396410521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Rosenberg <drosen@google.com>

[ Upstream commit a6a010f5def544af3efcfe21683905a712b60536 ]

Blocks are tracked by u32, so the max permitted filesize is
(U32_MAX + 1) * BLOCK_SIZE. Additionally, in order to support crypto
data unit sizes of 4K with a 16K block with IV_INO_LBLK_{32,64}, we must
further restrict max filesize to (U32_MAX + 1) * 4096. This does not
affect 4K blocksize f2fs as the natural limit for files are well below
that.

Fixes: d7e9a9037de2 ("f2fs: Support Block Size == Page Size")
Signed-off-by: Daniel Rosenberg <drosen@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 033af907c3b1..5dfbc6b4c0ac 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3364,6 +3364,14 @@ loff_t max_file_blocks(struct inode *inode)
 	leaf_count *= NIDS_PER_BLOCK;
 	result += leaf_count;
 
+	/*
+	 * For compatibility with FSCRYPT_POLICY_FLAG_IV_INO_LBLK_{64,32} with
+	 * a 4K crypto data unit, we must restrict the max filesize to what can
+	 * fit within U32_MAX + 1 data units.
+	 */
+
+	result = min(result, (((loff_t)U32_MAX + 1) * 4096) >> F2FS_BLKSIZE_BITS);
+
 	return result;
 }
 
-- 
2.43.0



