Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C03446D549;
	Tue, 21 Jul 2026 15:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648702; cv=none; b=MgbvSI5NHwpbAA6ISIFtZTmnYYR8W3WfzrHCKopYiYPAxm091FWJv3YEov5D2tMksYyPFN5b7Wpa8jeiGL+Zrv2rqyax4EWeAYfzPlbsyw+J8WvltUF5cnCUXD5Hv67mhL1iHjjuTcqmbX5w9QHRgjuqjnvCQssn1u4A55h8lWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648702; c=relaxed/simple;
	bh=ccv71BffqpCmeNO9akaOD6M44OzKmj1KG/qgyHRNFOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UibFOBEmW7heg+LyixJI757seGzAGqL9NAyXnBSMTBxyUSLDkKLe0Jmih79VNri8sN27gkIXiL6Uquw6UOeD7PuXUdNrkyPGSwFSkU46f4WbRPpFGMQ4hvyWAkLnY5f0eX9sxO8Sxb3K9wHzi1Q99x1jXojlPmAup40+zsSZ5L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zk8cXRb5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zk8cXRb5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D4E1F000E9;
	Tue, 21 Jul 2026 15:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648701;
	bh=JSE9SN6mOlE1LK4ttn+IE4leJbkzao3eu554ep+EIUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zk8cXRb5JFx8ykw4FLj+i9ObxP+milyL2vdje+Na0o0xkp/kvjtOweB1S9fhROrpK
	 cXeDOwlIH74KzFth9PksufFy+qYQ0aq3Ficyc1svleExHdfimi7cjVd3O5UOWkliTD
	 nN4lU5vmEUEE8ARUQIGVAEhO3ud3bbltUOaZAeEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0298/2077] gpu: nova-core: vbios: use checked arithmetic for bios image range end
Date: Tue, 21 Jul 2026 16:59:31 +0200
Message-ID: <20260721152559.707000737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 871c1163f90a3d..d25f9a11228009 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -155,8 +155,8 @@ impl<'a> VbiosIterator<'a> {
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
@@ -167,7 +167,7 @@ impl<'a> VbiosIterator<'a> {
             })?;
         }
 
-        BiosImage::new(self.dev, &self.data[offset..offset + len]).inspect_err(|err| {
+        BiosImage::new(self.dev, &self.data[offset..end]).inspect_err(|err| {
             dev_err!(
                 self.dev,
                 "Failed to {} at offset {:#x}: {:?}\n",
-- 
2.53.0



