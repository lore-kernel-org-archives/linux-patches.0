Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A084E3246;
	Thu, 17 Sep 2026 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658824; cv=none; b=YYgUK49zlHi+xsdX5wDN233kT0Mb6MG5TqpGlx+Qn7pW3ByMjg+FFTUJTTy3pi65ppXxNmgOwXmzUDHVCwYndUq7AOpLVmd2QCzPrJBrfr7t8jtBXnW0Z4o/pRab5i/4Vyq+KiaFCkz3VYMctGINwFp1o8hFShM8l+2cbBvxsKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658824; c=relaxed/simple;
	bh=HfpmJJhlSmWAScOKYvbkaqF/uIz9g76LyrahsPEeQfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLsiLy6r5ly8qayrhwdmPjKeu3i5ao09lp6BSfaQHMI0oD/ODQdVEgiM2826RDLUWknO24fOJaCesxGEWXqz3DHO/VnqKiBszkQO/9VYr3LDdmgNonNwNQ074ijrrySkTWxxd+wUFDY7Tn315G3DhNPj4CHdoxAIcEq0W1DoHas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reM8GJBH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reM8GJBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD4F1F00898;
	Thu, 17 Sep 2026 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658811;
	bh=x5nXIyl0tLhfxjt2OJYTSP6mZi4n0Yul6aEd/iJI8S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reM8GJBHZfy528CnNU44qnkpANVHsMZeQrbBX2HsNoKNQO5/PigKgTFeD5LfQri6C
	 M+9cs/SYgDmyUeO3qKaEs0hpxgUrF4iM3pqXfsPm+TXMVuCHYtO3425o+/XIr939jH
	 q22/7zVZF2zwMQLKIcfDFblPKchI7JSk5kmsNELE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Tighe <dennis.tighe@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 048/733] ntfs: reject invalid sectors_per_cluster in the boot sector
Date: Thu, 17 Sep 2026 16:05:56 +0100
Message-ID: <20260917151351.974034323@linuxfoundation.org>
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

From: Dennis Tighe <dennis.tighe@gmail.com>

[ Upstream commit 323751a604e7533fa473874d999371592a614207 ]

is_boot_sector_ntfs() checks the boot sector's sectors_per_cluster field
with a range test that rejects 0x81..0xf3 but accepts 0 and other
non-power-of-two counts. A zero value reaches parse_ntfs_boot_sector():

	sectors_per_cluster_bits = ffs(sectors_per_cluster) - 1;
	...
	vol->cluster_size = vol->sector_size << sectors_per_cluster_bits;

ffs(0) is 0, so sectors_per_cluster_bits becomes (unsigned)-1 and the
shift is undefined:

  UBSAN: shift-out-of-bounds in fs/ntfs/super.c:673:39
  shift exponent 4294967295 is too large for 32-bit type 'int'

This change rejects any non-power-of-two value, since it feeds the
aforementioned shift via ffs() - 1, which only yields the correct shift for a
power of two.

Fixes: 6251f0b0de7d ("ntfs: update super block operations")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dennis Tighe <dennis.tighe@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 242f6f9b5598e..63aa83ff77f5d 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -557,8 +557,8 @@ static bool is_boot_sector_ntfs(const struct super_block *sb,
 	 * Check sectors per cluster value is valid and the cluster size
 	 * is not above the maximum (2MB).
 	 */
-	if (b->bpb.sectors_per_cluster > 0x80 &&
-	    b->bpb.sectors_per_cluster < 0xf4)
+	if (b->bpb.sectors_per_cluster < 0xf4 &&
+	    !is_power_of_2(b->bpb.sectors_per_cluster))
 		goto not_ntfs;
 
 	/* Check reserved/unused fields are really zero. */
-- 
2.53.0



