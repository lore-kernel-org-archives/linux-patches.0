Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF108E56A;
	Thu, 15 Jan 2026 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497821; cv=none; b=J3tIyT1s5hmQ2zwWoHSvN42u+tcZl9WCn7Kl4qXfGepc3TwmWhQ8S3ylC4KPC6d2temDAiCJUwPFGpdhZ3K+d48lJwi33K97mERzQl3lsC9ZD7+aBaFusMXRbyAKX/h+ZHGdiR0gutvw+NyZR6Qz2sDISi40SspMFz+4/9LbGw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497821; c=relaxed/simple;
	bh=qYArBgSmzVXcLSzshQM9vEN1/YeB5m99GDqKBghIKr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8Cv0OISRo3g63lVZPjarTaEo2ZSMAGuklP5CSdbwyJDruQFWJLjiRMdI1In3zuGp5nlNXLdRR8kX7BaXpIkXR2MlIqaC9tV4CGMN5TaujX72lvLQ4yBC/JlajOBdchvcr/xOx64+8dMO+JKvZUkww+UWyEsli4Xu1CSO2YwP94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfwmOqLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfwmOqLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06424C116D0;
	Thu, 15 Jan 2026 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497821;
	bh=qYArBgSmzVXcLSzshQM9vEN1/YeB5m99GDqKBghIKr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfwmOqLWBEtd0BKLM0wQkmSitAi61umccSEDQZL5+2EWpAzcEO4YY90CjQ8kMzvL0
	 wD2IXbTWgIBP70r/1wtQnSHMLMXaU3jaPU/RoAkhxHQ93sc74o+JZbyXF9pqYgpVjS
	 FItj2eeZTEE983FrMrt5Oem/RY135gx6HGX2bo/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 216/554] fs/ntfs3: Support timestamps prior to epoch
Date: Thu, 15 Jan 2026 17:44:42 +0100
Message-ID: <20260115164254.068353663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5180138604323895b5c291eca6aa7c20be494ade ]

Before it used an unsigned 64-bit type, which prevented proper handling
of timestamps earlier than 1970-01-01. Switch to a signed 64-bit type to
support pre-epoch timestamps. The issue was caught by xfstests.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 69d1442eea623..d93cba03a65aa 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -975,11 +975,12 @@ static inline __le64 kernel2nt(const struct timespec64 *ts)
  */
 static inline void nt2kernel(const __le64 tm, struct timespec64 *ts)
 {
-	u64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
+	s32 t32;
+	/* use signed 64 bit to support timestamps prior to epoch. xfstest 258. */
+	s64 t = le64_to_cpu(tm) - _100ns2seconds * SecondsToStartOf1970;
 
-	// WARNING: do_div changes its first argument(!)
-	ts->tv_nsec = do_div(t, _100ns2seconds) * 100;
-	ts->tv_sec = t;
+	ts->tv_sec = div_s64_rem(t, _100ns2seconds, &t32);
+	ts->tv_nsec = t32 * 100;
 }
 
 static inline struct ntfs_sb_info *ntfs_sb(struct super_block *sb)
-- 
2.51.0



