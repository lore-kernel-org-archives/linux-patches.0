Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590720;
	b=a4WXPDDAQvlLcGGY3/rmsL/BUdqdFU+REp5/Crp2lp66K7rCgP1+cTDvHfQPbf9moBWB
	 +2q1WhuygiXBe8ewoumzp2gSb7RLLo7D+B14AbevGTBUbYdOXSwosWNu0Ca1cxfc49j+S
	 UMEczamDMtkoN7eSZkmjvMlNfmzb5lDnCt/Ktx9torwuepWrRVBgcYgOIGkSSWFZkkNOB
	 zSV4lzi0DZT3cbnvk3b4gKnmkG3Hc6LK15skEaqCmK3OUeChAyFcf5sjfcUBRiFO+yikB
	 HQgcL+JbDUP2ylMouKyURnUpP8NOVu3xNqa3yJDPihspLod0FnPjo7QO4ecZ+NUikrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NXKFrjdEGEILy0ShTJOMxi2w3BrQVHOP1uZRsYhRxe0=;
	b=YvKMydQGaRCsSAP0Phk8bEUbExFamCRaHDnknUcki0DWTJESCVbdulk00MJNassTRsoe
	 iOMm4UQnn+X+18POw3J7p26NzMv4mzi2YucvwdGA4/iB/bu0stUDji+ZiHW+lv0NAWGcB
	 9QWEwfbGWilWEUJWJ8+hRnlJhTp6s5svftw2ZIeWmGpCbKFOv5BOFCdXkQwWzomkpNKLM
	 dABTJoEl9bTbcoMvbidEHkJ/9DpKnH4fKsD3K/fFzW/VCyQ46dI4ZWxBmtpmUViGvBMKL
	 kHT0Pw9EBiD7kOreNtPfv/TG30yi5OHa6jZtbb3KZEjovLFurJ4PL6QSzjtGoNEwk5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui51mZXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC281606A33D;
	Fri, 13 Nov 2026 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui51mZXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886E61F000C4;
	Fri, 13 Nov 2026 17:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590720;
	bh=NXKFrjdEGEILy0ShTJOMxi2w3BrQVHOP1uZRsYhRxe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui51mZXMVOqyeSD40+PbPlRRDiBx0bniFaU2bZX3Oph22iWNOIaE+omhua/IVQEm7
	 DKG8TmQR1R3J5geKyGvxQdMACsi5FTEzwuoCXCbaVJpa2OogEUc/Jgn6EE5JvDiuKc
	 ioO6Ka4DDO/eOcvtce2fY6F9eX6nP4M/3CsQYt5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 627/686] fs: spell out fenced ->i_state accesses with explicit smp_wmb/smp_rmb
Date: Fri, 13 Nov 2026 10:52:40 -0500
Message-ID: <20261113153843.095009627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit cb5db358ab5769cbd3e8e864f14af321126cccdb ]

The incomming helpers don't ship with _release/_acquire variants, for
the time being anyway.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 8ee09f597763 ("fs: rotate inodes whose page cache could not be dropped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c           | 5 +++--
 include/linux/backing-dev.h | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 85f21ecc59958..e479e310f92c6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -476,10 +476,11 @@ static bool inode_do_switch_wbs(struct inode *inode,
 	switched = true;
 skip_switch:
 	/*
-	 * Paired with load_acquire in unlocked_inode_to_wb_begin() and
+	 * Paired with an acquire fence in unlocked_inode_to_wb_begin() and
 	 * ensures that the new wb is visible if they see !I_WB_SWITCH.
 	 */
-	smp_store_release(&inode->i_state, inode->i_state & ~I_WB_SWITCH);
+	smp_wmb();
+	inode->i_state &= ~I_WB_SWITCH;
 
 	xa_unlock_irq(&mapping->i_pages);
 	spin_unlock(&inode->i_lock);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3e64f14739dd2..065cba5dc111b 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -277,10 +277,11 @@ unlocked_inode_to_wb_begin(struct inode *inode, struct wb_lock_cookie *cookie)
 	rcu_read_lock();
 
 	/*
-	 * Paired with store_release in inode_switch_wbs_work_fn() and
+	 * Paired with a release fence in inode_do_switch_wbs() and
 	 * ensures that we see the new wb if we see cleared I_WB_SWITCH.
 	 */
-	cookie->locked = smp_load_acquire(&inode->i_state) & I_WB_SWITCH;
+	cookie->locked = inode->i_state & I_WB_SWITCH;
+	smp_rmb();
 
 	if (unlikely(cookie->locked))
 		xa_lock_irqsave(&inode->i_mapping->i_pages, cookie->flags);
-- 
2.53.0



