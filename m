Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCD46AA69;
	Tue, 21 Jul 2026 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655971; cv=none; b=F5oOFiiquN6bqTVqQwfqBp09Q0yK0+Z4nt9tNgUntylyK8q9YX2OH8DubFpJzBPIPV8KnZDJajqgMsooBgOnmp1svFUSAmfUIODpoBvWTCEdxYEb6Le4mFGv9rt9C4haat8hbawyNsdM//beMZb8IGBZs7zjDcxGTSfS0nbm1do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655971; c=relaxed/simple;
	bh=mt2CZ5xFPiWfn2SByAzsCVSpv1r2uuciXWjF8P+XSuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzTPSs1FxeA+nUtYA6NVp2V+b1xxrrUhbKrD1T3Rn2WYe7px5VzhNmK82X2AM3dPUAdaB8ssfIi96SQFt23oElj+hp88QKnzhO93t/VwbXk1VNVxu+vrwyNd2SMAdHoeSppn1bUC5+0kAXwnKuZssSmFm8YRbBlVkarOH53s36I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqXqfnmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqXqfnmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B931F000E9;
	Tue, 21 Jul 2026 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655969;
	bh=iPNjtWto2wlHpR4MvgHeNraOdq17EgzMKSoZfavPGoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqXqfnmZmnMC/QL+cwwn208tHL9VJuqdNdJDK6tfqYxMSPxNYiG/fvMg4MHDQQMHU
	 saRRGo1/ySODZCKnY+P93i0RupC45LwFTFPY1t5XBVZDm73Qv+kmsaRR9iQGEfURcS
	 ymAtFoZPUh0t3TKRCUuHvlJS/L0QQWEgWewMbG0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0210/1611] gpu: nova-core: vbios: use checked arithmetic for bios image range end
Date: Tue, 21 Jul 2026 17:05:26 +0200
Message-ID: <20260721152519.694138655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit 7a1d09e477b6496f13f92b84ed9b2eab191b3366 ]

`read_bios_image_at_offset` is called with a length from the VBIOS
header, so we should be more defensive here and use checked arithmetic.

Fixes: 6fda04e7f0cd ("gpu: nova-core: vbios: Add base support for VBIOS construction and iteration")
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-2-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index b19c577e3a2320..53502efc418364 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -112,8 +112,8 @@ impl<'a> VbiosIterator<'a> {
         len: usize,
         context: &str,
     ) -> Result<BiosImage> {
-        let data_len = self.data.len();
-        if offset + len > data_len {
+        let end = offset.checked_add(len).ok_or(EINVAL)?;
+        if end > self.data.len() {
             self.read_more_at_offset(offset, len).inspect_err(|e| {
                 dev_err!(
                     self.dev,
@@ -124,7 +124,7 @@ impl<'a> VbiosIterator<'a> {
             })?;
         }
 
-        BiosImage::new(self.dev, &self.data[offset..offset + len]).inspect_err(|err| {
+        BiosImage::new(self.dev, &self.data[offset..end]).inspect_err(|err| {
             dev_err!(
                 self.dev,
                 "Failed to {} at offset {:#x}: {:?}\n",
-- 
2.53.0



