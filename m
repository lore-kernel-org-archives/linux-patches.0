Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BC3BCD0D;
	Tue, 21 Jul 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648715; cv=none; b=JZAZoaYZUk0Vn1ETsQ07G/pZcIOxFVdKDWshqDnO1tSFuX1jcgOdcW3bnJNl3SUJYXYjTzmlou1AeyMh+HRDdZXZYiub+dS2iLnDofR3bfhinYNb8IMHGOxtGRBYMzTebhpgTnIbAb7S0xIeObx2I8zVhzNnIX9JxwghFjTh3N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648715; c=relaxed/simple;
	bh=EuJWSl4FlxNzrdpUnZkwEYc0VehdGQPpcPGNwjix+68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1nYwtZ46mONnsSACRAoPIktOc38R7mO2WlQihdgFf5CuKoor0Z9TlmEURdIF6V/sBMeJgn5Otjxczm/FKWE3fKbveac+zKnD+SEj/TWIVJye0I2nwtZqb8E+J9nqHbW3XPA0/cThUx53hp+fHKw95ePWiGQ6URfahq64sut/SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2X6twO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2X6twO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166451F00A3A;
	Tue, 21 Jul 2026 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648714;
	bh=ryrPt/D/ZI4c/uNCePUdUxJpl0vWSXmAdwJHfC6FAas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2X6twO0njzXYMvmZJEOxT2+l2hbh4tJmwzFLNRTg8uI8tzBomBI0AMHE8CjeB4zY
	 WSyOuLp4MVvSrH4ojBpnMYn4sRJB+b5I0QApIUbA+NZ6JD0rkjhVc7djBIZSst0NOW
	 HPQ0eiKHejEL275YZBrSy/jzVdkv7LR8gxhWo41s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Fernandes <joelagnelf@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0303/2077] gpu: nova-core: vbios: use checked accesses in `setup_falcon_data`
Date: Tue, 21 Jul 2026 16:59:36 +0200
Message-ID: <20260721152559.825283608@linuxfoundation.org>
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

[ Upstream commit 051ae1b21ff7a3cc27522b0b3b56e277b62c1207 ]

Use checked arithmetic for `ucode_offset` in `setup_falcon_data`. This
prevents a malformed firmware from causing a panic.

Fixes: dc70c6ae2441 ("gpu: nova-core: vbios: Add support to look up PMU table in FWSEC")
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260525-fix-vbios-v5-7-e5e455251537@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/vbios.rs | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 394877d5b2eae1..19361104a4cd3d 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -953,14 +953,15 @@ impl FwSecBiosBuilder {
             .find_entry_by_type(FALCON_UCODE_ENTRY_APPID_FWSEC_PROD)
         {
             Ok(entry) => {
-                let mut ucode_offset = usize::from_safe_cast(entry.data);
-                ucode_offset -= pci_at_image.base.data.len();
-                if ucode_offset < first_fwsec.base.data.len() {
-                    dev_err!(self.base.dev, "Falcon Ucode offset not in second Fwsec.\n");
-                    return Err(EINVAL);
-                }
-                ucode_offset -= first_fwsec.base.data.len();
-                self.falcon_ucode_offset = Some(ucode_offset);
+                self.falcon_ucode_offset = Some(
+                    usize::from_safe_cast(entry.data)
+                        .checked_sub(pci_at_image.base.data.len())
+                        .and_then(|o| o.checked_sub(first_fwsec.base.data.len()))
+                        .ok_or(EINVAL)
+                        .inspect_err(|_| {
+                            dev_err!(self.base.dev, "Falcon Ucode offset not in second Fwsec.\n");
+                        })?,
+                );
             }
             Err(e) => {
                 dev_err!(
-- 
2.53.0



