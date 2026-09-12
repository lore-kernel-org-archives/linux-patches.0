Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903103AF646;
	Sat, 12 Sep 2026 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239042; cv=none; b=he3/weZptCJsk54xIO/oHkg1ueMP9cpGl5rRTJ124HLXgtlbTJPdeQMcAzU97dn6T1Suf32nbHFfBghIh8yiX+CI+0swOoyIPml30N6wk5Xf2K2cBI0eENt0YALEriQJHebV35UdQxGCsnr3WQapD7YDIcqMiosszlzpNIc2dt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239042; c=relaxed/simple;
	bh=2oSGyBk3qRs472mWH0t7M60IP4htJDKl2cobXEAst7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DN0gtKEi2vmn2TRgfUwgnj4KtA5QmhwZdiBPyB1CbYPzTdOA5U4lKIF5eSGngkNlp4dCnQ0wsqXG7CzaKKy40U5JP9WVT2l0y/GFpvpvz4w7dy1fpLPb2ABMBIepKW5EFLfSBs3zI04SCyLN3zvTCcToz1z4zBqpguHbIQaZ//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzM3CPny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzM3CPny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324861F000FF;
	Sat, 12 Sep 2026 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239041;
	bh=cDn2TsfUW9SUyaLMhszJiaYN+CkIF7b4c01UhHPE/A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzM3CPnyuJ1WaLmZRL8AFOY4DI8vPLxoKFMJ4n7W62D9EVUZoVIWoi2uyvx3cX5ve
	 vjf8tKAKn5tjAiw27x+RRkzVO0OWQkxMfTqZKJl2gdtoZ70cvf/GaNR+8qofRuwPhP
	 4AWLvyp9J37+iZwuN/XZW7/M5d92f+GXv7MQFYQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 541/935] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:59:31 +0200
Message-ID: <20260912065539.232127741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit d23eb7380d1594cda31a5dc8487dd2a5c8def8c7 ]

udf_symlink_filler() can enter udf_pc_to_char() with a partial pathComponent header.

Validate that enough input remains for a complete pathComponent header
before accessing it. Reject malformed symlink data that would otherwise
make udf_pc_to_char() perform an out-of-bounds read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260717104722.41446-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index 9b223421a3c55..b327c3acfee17 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -40,6 +40,8 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	/* Reserve one byte for terminating \0 */
 	tolen--;
 	while (elen < fromlen) {
+		if (fromlen - elen < sizeof(struct pathComponent))
+			return -EIO;
 		pc = (struct pathComponent *)(from + elen);
 		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
-- 
2.53.0



