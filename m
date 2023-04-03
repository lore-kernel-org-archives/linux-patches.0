Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913136FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16851C433EF;
	Mon,  3 Apr 2023 14:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532437;
	bh=eenWOeQQNPEv5V0c223t71Q3Y9U/3KJA4MKAx62PM4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T32tt7BD4rF5i/uw94EgNc1T4MFb2UuwnDk+JzAZXtqELj7FH4SH2SQx47U9Mz3a
	 fpjPjXDVRjCpMD2pSzs3olSbZ5fSxPqlvkO25STh4oAWLa1Ckr40GTap86R0Loje6i
	 7/k9Qw239rzJIpXVXvu3AhNZ3TOb86u61iQmevOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jkl820.git@gmail.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH 5.15 53/99] ice: fix invalid check for empty list in ice_sched_assoc_vsi_to_agg()
Date: Mon,  3 Apr 2023 16:09:16 +0200
Message-Id: <20230403140405.341981874@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakob Koschel <jkl820.git@gmail.com>

[ Upstream commit e9a1cc2e4c4ee7c7e60fb26345618c2522a2a10f ]

The code implicitly assumes that the list iterator finds a correct
handle. If 'vsi_handle' is not found the 'old_agg_vsi_info' was
pointing to an bogus memory location. For safety a separate list
iterator variable should be used to make the != NULL check on
'old_agg_vsi_info' correct under any circumstances.

Additionally Linus proposed to avoid any use of the list iterator
variable after the loop, in the attempt to move the list iterator
variable declaration into the macro to avoid any potential misuse after
the loop. Using it in a pointer comparison after the loop is undefined
behavior and should be omitted if possible [1].

Fixes: 37c592062b16 ("ice: remove the VSI info from previous agg")
Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2d9b10277186b..0b61fde449152 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2758,7 +2758,7 @@ static enum ice_status
 ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 			   u16 vsi_handle, unsigned long *tc_bitmap)
 {
-	struct ice_sched_agg_vsi_info *agg_vsi_info, *old_agg_vsi_info = NULL;
+	struct ice_sched_agg_vsi_info *agg_vsi_info, *iter, *old_agg_vsi_info = NULL;
 	struct ice_sched_agg_info *agg_info, *old_agg_info;
 	enum ice_status status = 0;
 	struct ice_hw *hw = pi->hw;
@@ -2776,11 +2776,13 @@ ice_sched_assoc_vsi_to_agg(struct ice_port_info *pi, u32 agg_id,
 	if (old_agg_info && old_agg_info != agg_info) {
 		struct ice_sched_agg_vsi_info *vtmp;
 
-		list_for_each_entry_safe(old_agg_vsi_info, vtmp,
+		list_for_each_entry_safe(iter, vtmp,
 					 &old_agg_info->agg_vsi_list,
 					 list_entry)
-			if (old_agg_vsi_info->vsi_handle == vsi_handle)
+			if (iter->vsi_handle == vsi_handle) {
+				old_agg_vsi_info = iter;
 				break;
+			}
 	}
 
 	/* check if entry already exist */
-- 
2.39.2



