Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A241BD002;
	Tue,  2 Jul 2024 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940256; cv=none; b=pocnd616AfXP1zARrPHBJYDMmBD5dKuuH0vFRZh7xXDm+rDHmOpV/y4RO31pyoFcfwCL79BfOd9Q/2Kx6W/Hyklf8QvFsGQvGo12CKBDeGyQvL2Cf/jCvYwAW2wiKtjXNRGkFt6MZopT+66U36wjDrUQgQhArDL2b9GqcmiV9QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940256; c=relaxed/simple;
	bh=+JxtE16RxdIFc9qPfBrgxVs1HYhMWOd/XSuoLdbniGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeG1qIaTGNs6foCLIstMlSthOKAwot61rohk+meT3AGpA2w/hFLKss5hTg2MXYcL3ARpJyCNMKJ9kIlxrTR/KHVf7CKnUKier8B24s8Xjzzc68meN1SBuIpGemOJmRggq27EUiiedh45SzAdNuiaXgLviEmK7P3bCjwdzTmxTtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y9Asfkez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y9Asfkez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5FC116B1;
	Tue,  2 Jul 2024 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940256;
	bh=+JxtE16RxdIFc9qPfBrgxVs1HYhMWOd/XSuoLdbniGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9AsfkezdRpFojlokdZurFD9WDvomzvhuomGIQjcSJr4KfGjG2QEW5h/KpME7VQJK
	 5lHvPrPqf55sZr7OJz3dpsVBvfrgOrlvZtB5aX2YTwoxVCI8jdhqCr862zy0MONFNP
	 wBd2321uZnDWrjx4a189aNHCh+Q35iIKCm3TWM0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 099/222] arm64: Clear the initial ID map correctly before remapping
Date: Tue,  2 Jul 2024 19:02:17 +0200
Message-ID: <20240702170247.753335606@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit ecc54006f158ae0245a13e59026da2f0239c1b86 ]

In the attempt to clear and recreate the initial ID map for LPA2, we
wrongly use 'start - end' as the map size and make the memset() almost a
nop.

Fix it by passing the correct map size.

Fixes: 9684ec186f8f ("arm64: Enable LPA2 at boot if supported by the system")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20240621092809.162-1-yuzenghui@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/map_kernel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index 5fa08e13e17e5..f374a3e5a5fe1 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -173,7 +173,7 @@ static void __init remap_idmap_for_lpa2(void)
 	 * Don't bother with the FDT, we no longer need it after this.
 	 */
 	memset(init_idmap_pg_dir, 0,
-	       (u64)init_idmap_pg_dir - (u64)init_idmap_pg_end);
+	       (u64)init_idmap_pg_end - (u64)init_idmap_pg_dir);
 
 	create_init_idmap(init_idmap_pg_dir, mask);
 	dsb(ishst);
-- 
2.43.0



