Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEF337FF60;
	Sat, 12 Sep 2026 16:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229675; cv=none; b=TAU3DzSBuQhFMmX8xqw3gLsxM/qHW6984p4aoyTMKyaFZH3CaAO/cGllpuSHWF6yy74Y89tSnoUc4PNPSVriqsyxApmid2ispVniPcnKFrgwpWzUOCQaLKOStwNGaNVwIljmjFJYyY5Rx4QsIWJoswpjxHC0AupHrUB8vd0f3Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229675; c=relaxed/simple;
	bh=VeoPXxQqZSlKyCGBxcMYwqpyyglTpj6lNK0AyBvo21s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTVAC8BImFS/R/40eJZF+Tn2NlUuGAV9mortdK4hnxBKpRweKmY4BXefzeSokW0OupLVijiJmm4zBZw1PgY1MfF/VAr4n4Wh+j1kPqzk7hxZHMg+g5ihOtS+TtYZ5uZpYG6vVRJIbQVo8y8oKRKrVF/XEAHiNumMtFe69uScJQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LC7zLT3Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LC7zLT3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28D01F000FF;
	Sat, 12 Sep 2026 16:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229674;
	bh=u8a7yclZdeCYe0BnkjsM0DZUMn8W+IFlx/tLHXGLYnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC7zLT3QlSY7ZOzF8MoyP4H2AryFluMIX3HaMYJtXygwD+esKsRTZQUh5mm7ipi+G
	 E59UH2Bt8BRmNAorhAKAr9bhff9viU3RJb6+abk+X0d+CTwPTiVUuU8KXk1d3LGY9a
	 QcgYmlXsSu+y26phOMo7FpnWRCCUsSMK92jU8Ffs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0637/1191] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 08:56:05 +0200
Message-ID: <20260912065602.562381226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index f3642f9c23f86..c8d11903c3816 100644
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



