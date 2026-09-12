Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1960F3C13E3;
	Sat, 12 Sep 2026 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197054; cv=none; b=HtGllB6XL31T+4odz6DcrKDyytrwj6O7GAydG6OxE6DAu7bb6FJIJIp6OaPzYn13xYCw71cV1bVLIMXBB0md4LinOQWAXvPN3qk+n6EX73eSZRN06x7D000ip/A9LPWlj+ePo5kvOvKevoWgqm6EBslxCMv+MX6DHqDKrWBQsiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197054; c=relaxed/simple;
	bh=iazQDhaPXQEmfi8j4vfIWpheX0YiRqV1ZMop0fcXJZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfYLx9LuLvR3GoRmBOgKeUplpVRhN5CbHhvKz+QKq5Uev7/TrR2qpd72sBD+Vgd3AwV2rhG9booBxl8CFiYY6MmmlQ0TK1uquJwNFcq6SdhiHFXbX+Oz6IvVYfLxb7WuA7PwvwoUh7ueWPtUuH6OWt3z6a2ZvZOal2khixe7x4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ep7LuR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ep7LuR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C71F000FF;
	Sat, 12 Sep 2026 07:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197053;
	bh=hMQhcnzaF6mwmuE5fTYj7vX/4aJAFSIrtv4tHhpguC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ep7LuR7SORw/MqGmLZg9VtfXpi/ffvITu97oPxwWYW/NakEPKh281JVnQjI0JJor
	 6ZwQKo9PXhjb32LfPGEymQOdCRLQXRma9hZfFy3n/YYM2pQvUmM0Snoz+K+EYRNZiV
	 Uk3X2amaLVnlL7LVqqmevoEHyg+hejvrm7c6qT4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0048/1815] gpu: nova-core: gsp: tu102: keep unloading if FWSEC-SB fails
Date: Sat, 12 Sep 2026 08:29:58 +0200
Message-ID: <20260912065650.148321689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 9eaff547805f8556992a9474465001c3e128b7bd ]

On Turing and Ampere, resetting the GSP involves running two firmware
images: FWSEC-SB and Booter Unloader. They are independent from one
another, and we should do whatever is possible to restore the GSP's
unloaded state even if a failure occurs along the way.

Thus, keep going and run Booter Unloader even if the execution of
FWSEC-SB failed.

Fixes: adb99ce3cc78 ("gpu: nova-core: run Booter Unloader and FWSEC-SB upon unbinding")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260529-nova-unload-v7-0-678f39209e00%40nvidia.com?part=3
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260531-nova-unload-fix-v1-1-c8dcdc769b53@nvidia.com
[acourbot: log Booter Unloader errors.]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/hal/tu102.rs | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/hal/tu102.rs b/drivers/gpu/nova-core/gsp/hal/tu102.rs
index 2f6301af71131..eb7166148cc9a 100644
--- a/drivers/gpu/nova-core/gsp/hal/tu102.rs
+++ b/drivers/gpu/nova-core/gsp/hal/tu102.rs
@@ -134,11 +134,19 @@ impl UnloadBundle for Sec2UnloadBundle {
         sec2_falcon: &Falcon<Sec2>,
     ) -> Result {
         // Run FWSEC-SB to reset the GSP falcon to its pre-libos state.
-        self.fwsec_sb.run(dev, bar, gsp_falcon)?;
+        // Log errors but keep going if it fails.
+        let fwsec_sb_res = self
+            .fwsec_sb
+            .run(dev, bar, gsp_falcon)
+            .inspect_err(|e| dev_err!(dev, "FWSEC-SB failed to run: {:?}\n", e));
 
         // Remove WPR2 region if set.
         let wpr2_hi = bar.read(regs::NV_PFB_PRI_MMU_WPR2_ADDR_HI);
-        if wpr2_hi.is_wpr2_set() {
+        let booter_unloader_res = (|| {
+            if !wpr2_hi.is_wpr2_set() {
+                return Ok(());
+            }
+
             sec2_falcon.reset(bar)?;
             sec2_falcon.load(dev, bar, &self.booter_unloader)?;
 
@@ -160,9 +168,12 @@ impl UnloadBundle for Sec2UnloadBundle {
                 );
                 return Err(EBUSY);
             }
-        }
 
-        Ok(())
+            Ok(())
+        })()
+        .inspect_err(|e| dev_err!(dev, "Booter Unloader failed to run: {:?}\n", e));
+
+        fwsec_sb_res.and(booter_unloader_res)
     }
 }
 
-- 
2.53.0



