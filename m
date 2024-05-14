Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F996311D;
	Tue, 14 May 2024 11:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685818; cv=none; b=hXCL+VdGWwAKCK//hIKsgiod1Qqe3w2Sc+R7Xl+UwdqIftsoSjN9PCvRlMnfL1xr1MIIYt4sXcH1x+Ptc49eJXeQDAjRIFlX64S249zrHkWprTjsd/HZ7JhVWJRKGQDczg/o+hYY4uxh8hvv87u/+9cNw4Cs4kX8oIPI7BDdtKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685818; c=relaxed/simple;
	bh=IKk6ZNHlSeqTOj2so2Vtg4AcpQCbkeGP89ampqKwSKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y63jOJh/8NpTj4EY3xOiI0Gf22ZzTSjsplg/kosAnc2wgUJ7M9K9aMd89SzLqjJKFkvCYq4ynRskuO59X7BfV9H95mCiRYQt1s7UOAzukRICzhC6f5RMI3m51zeMX3WiE7sLHMFsDTCkFyiiweOAnIyLh9fMXeg7HxKyL4xxLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIkRWHh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIkRWHh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6210FC2BD10;
	Tue, 14 May 2024 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685817;
	bh=IKk6ZNHlSeqTOj2so2Vtg4AcpQCbkeGP89ampqKwSKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIkRWHh1bmBixvp5WFFDwZBSSe9SjETMUsC+I/Tw76qCVZ+0AcyEgQY2HFvqnykfL
	 9+DppQlk3EWLH8zGGu2ekkth4OAzUEhsAyXW9AYnEqdxDG6Grbs+ZeA8gGMqMMOGlM
	 0Xi2HISzSrqk5wVs43s5XcCwa8eTToaZUmDTF3Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Carretero?= <cJ@zougloub.eu>,
	Sasha Neftin <sasha.neftin@intel.com>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Dima Ruinskiy <dima.ruinskiy@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 253/301] e1000e: change usleep_range to udelay in PHY mdic access
Date: Tue, 14 May 2024 12:18:44 +0200
Message-ID: <20240514101041.809415184@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Lifshits <vitaly.lifshits@intel.com>

commit 387f295cb2150ed164905b648d76dfcbd3621778 upstream.

This is a partial revert of commit 6dbdd4de0362 ("e1000e: Workaround
for sporadic MDI error on Meteor Lake systems"). The referenced commit
used usleep_range inside the PHY access routines, which are sometimes
called from an atomic context. This can lead to a kernel panic in some
scenarios, such as cable disconnection and reconnection on vPro systems.

Solve this by changing the usleep_range calls back to udelay.

Fixes: 6dbdd4de0362 ("e1000e: Workaround for sporadic MDI error on Meteor Lake systems")
Cc: stable@vger.kernel.org
Reported-by: Jérôme Carretero <cJ@zougloub.eu>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218740
Closes: https://lore.kernel.org/lkml/a7eb665c74b5efb5140e6979759ed243072cb24a.camel@zougloub.eu/
Co-developed-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Tested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240429171040.1152516-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/e1000e/phy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -157,7 +157,7 @@ s32 e1000e_read_phy_reg_mdic(struct e100
 		 * the lower time out
 		 */
 		for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
-			usleep_range(50, 60);
+			udelay(50);
 			mdic = er32(MDIC);
 			if (mdic & E1000_MDIC_READY)
 				break;
@@ -181,7 +181,7 @@ s32 e1000e_read_phy_reg_mdic(struct e100
 		 * reading duplicate data in the next MDIC transaction.
 		 */
 		if (hw->mac.type == e1000_pch2lan)
-			usleep_range(100, 150);
+			udelay(100);
 
 		if (success) {
 			*data = (u16)mdic;
@@ -237,7 +237,7 @@ s32 e1000e_write_phy_reg_mdic(struct e10
 		 * the lower time out
 		 */
 		for (i = 0; i < (E1000_GEN_POLL_TIMEOUT * 3); i++) {
-			usleep_range(50, 60);
+			udelay(50);
 			mdic = er32(MDIC);
 			if (mdic & E1000_MDIC_READY)
 				break;
@@ -261,7 +261,7 @@ s32 e1000e_write_phy_reg_mdic(struct e10
 		 * reading duplicate data in the next MDIC transaction.
 		 */
 		if (hw->mac.type == e1000_pch2lan)
-			usleep_range(100, 150);
+			udelay(100);
 
 		if (success)
 			return 0;


