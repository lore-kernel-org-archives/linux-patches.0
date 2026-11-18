Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018382;
	b=pFn//DMN+bmMJlL+zj/qwFxLQBHGQEAXcFnCKRFywJDfE+YJ72sj2LRBSrpdny+cqLxa
	 10M77ofOrn/A4wABUJFFsUKaL0BzBu7erwGYXpqtIrvsvd0TseBUuraaOAy8B/FKVOCvg
	 /y5y2aaEotTq9Hsebe9lSCVr3WK9eEZjmUX4AhR2PmJNvM7ODObT8mmxnlPW9KwdfpINQ
	 8/l+w6WA54Stm5QSQorecgZpLim2yj1uNaEguJe3f2/Nm3GXQvTnNB+UF4Q1Y6brgA4uE
	 Z03giTsVTYYn0R8ee+1EcCP2jUAHLnfG6/8bkmxt2AkZjCwTepdt6N3V8LQ91EVZ5cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GoZHnQHG1FNZbPYxlEqbGtWd7yW5qYbRlgK4fdtThog=;
	b=LLzJCcgGWK/1pYvJ6r84qyVhtT6qNBtVs4EOsv4YjspVE1kwSuQ1ecH+9IOpTJKw73Kr
	 +Fx1RQgpcTYHxYQI/AYbpi/TixO1XnHYsycz/DylOW9+o5oHFDH2KzTDbTaSDUx0mpEWO
	 QS9Iozt4q7L8ze4ZQ2spFW4LuqO2B7SJYT3rt8uzGqO/hSITUWd1cvkK94C7PrYl9sG4/
	 4oZoL8+NaySTAToCuM6/tCP4Gq1zpn8mk47V9WT+KygvAgBp+jYobVtrIydhJNMQOmZ39
	 j6YvL3ai8u1599QFSjVxNAC48I97uTkVALDeJzVQkEiqLIMUERhkRKaBmJu445wwrUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iBLVurz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C163606A320;
	Wed, 18 Nov 2026 16:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1iBLVurz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3191F000C4;
	Wed, 18 Nov 2026 16:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018382;
	bh=GoZHnQHG1FNZbPYxlEqbGtWd7yW5qYbRlgK4fdtThog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iBLVurzxFd+eWlCa8jMboFnJFhhEXJHZFb/HN7L6O1vsU0nxAaOauQSiR8sstw87
	 2ZWHC61ZtWIKiWydPGOiF0Ue4q7G2hghT37nNYqClm52C4z840RklA5sc2HlWizube
	 L6qjsiTI69pvycg+c+JjrAjFMqy9i8Ru6HdQwqYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1180/2651] arm_mpam: Add missing mon_sel locking in MBWU save and restore
Date: Wed, 18 Nov 2026 15:40:20 +0100
Message-ID: <20261118150330.490319962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 0045b87f65bbdd3b433747cce0d723ae94f77d38 ]

The mon_sel_lock is used to protect the mbwu_state, as well as h/w accesses
that use MPAMCFG_MON_SEL. However, in mpam_restore/save_mbwu_state(),
mbwu_state is accessed without holding the mon_sel_lock.

Add the missing locking.

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 403f302931817..8ada8eca049b3 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1652,17 +1652,26 @@ static int mpam_restore_mbwu_state(void *_ris)
 	u64 val;
 	struct mon_read mwbu_arg;
 	struct mpam_msc_ris *ris = _ris;
+	struct mpam_msc *msc = ris->vmsc->msc;
 	struct mpam_class *class = ris->vmsc->comp->class;
 
 	for (i = 0; i < ris->props.num_mbwu_mon; i++) {
-		if (ris->mbwu_state[i].enabled) {
-			mwbu_arg.ris = ris;
-			mwbu_arg.ctx = &ris->mbwu_state[i].cfg;
-			mwbu_arg.type = mpam_msmon_choose_counter(class);
-			mwbu_arg.val = &val;
+		if (WARN_ON_ONCE(!mpam_mon_sel_lock(msc)))
+			return -EIO;
 
-			__ris_msmon_read(&mwbu_arg);
+		if (!ris->mbwu_state[i].enabled) {
+			mpam_mon_sel_unlock(msc);
+			continue;
 		}
+
+		mwbu_arg.ris = ris;
+		mwbu_arg.ctx = &ris->mbwu_state[i].cfg;
+		mwbu_arg.type = mpam_msmon_choose_counter(class);
+		mwbu_arg.val = &val;
+
+		mpam_mon_sel_unlock(msc);
+
+		__ris_msmon_read(&mwbu_arg);
 	}
 
 	return 0;
@@ -1680,12 +1689,12 @@ static int mpam_save_mbwu_state(void *arg)
 	struct mpam_msc *msc = ris->vmsc->msc;
 
 	for (i = 0; i < ris->props.num_mbwu_mon; i++) {
-		mbwu_state = &ris->mbwu_state[i];
-		cfg = &mbwu_state->cfg;
-
 		if (WARN_ON_ONCE(!mpam_mon_sel_lock(msc)))
 			return -EIO;
 
+		mbwu_state = &ris->mbwu_state[i];
+		cfg = &mbwu_state->cfg;
+
 		mon_sel = FIELD_PREP(MSMON_CFG_MON_SEL_MON_SEL, i) |
 			  FIELD_PREP(MSMON_CFG_MON_SEL_RIS, ris->ris_idx);
 		mpam_write_monsel_reg(msc, CFG_MON_SEL, mon_sel);
-- 
2.53.0



