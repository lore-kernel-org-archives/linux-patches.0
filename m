Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10437D07E;
	Tue, 14 May 2024 10:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683936; cv=none; b=OkPT/ZkwPzjnWlWbFJX6qldg3ut++HxcZGGqiqrqbAUqeERBIDf5K8NI6n0Vqjfn/TcDinY90ljuKcgzXRrgGEiow0E6+UolnZYnTqPMZJL30IzMrBF+PR4zYiWR3+/tknx509+ZDd6TD0Q+RISBrFsPslfqx/H8Mwr2zmCxEZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683936; c=relaxed/simple;
	bh=IB3twSMxas3EVIaZtn+2oMBENUvliFBAn0iQ9c7AOYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V6j7XSj9C2WY+GI6pJx42/Yq0ZqHuDhpHYmayaPlKxX+PY7kUoH6/lTLlacooL/9DAVqSQpRnBNOb1wX0sT9JYhbwAVsv31wdsKh1K3xJxB+QMRyYLsAg2BkcBVw8yMoDo/rOtyTA1PLVKoOchgch8oG9KndNb/ib+zLslPVCrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfYMAXLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfYMAXLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8497DC2BD10;
	Tue, 14 May 2024 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683936;
	bh=IB3twSMxas3EVIaZtn+2oMBENUvliFBAn0iQ9c7AOYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfYMAXLaofptQE7ZkYEiSYoqBrtY21/dbnp7/KBHF5eunLhk9/BI3i8GsOz9wwjJQ
	 7Y8eX07mKuqHTveyVTjLZ2Z0gVKf3lFotW2TeBQ+Msmvk5C51kGslY0TmpSYHrsv6i
	 NXdkVJsicmOQOUq4y6LX526z0MQEEvxsc9kuiC6o=
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
Subject: [PATCH 6.8 279/336] e1000e: change usleep_range to udelay in PHY mdic access
Date: Tue, 14 May 2024 12:18:03 +0200
Message-ID: <20240514101049.153462276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


