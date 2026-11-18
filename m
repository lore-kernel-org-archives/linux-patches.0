Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018385;
	b=LMLGWNH44b2II5n9n0GpiiqWHvyqxWdDB9fTcNHRLqa7vI8rfYPQ5Dx1sHOdIxCsDBFu
	 xVtp7aDoS2yVDbyJsZdgnJVIgslUjLwsAAdxy8w52arqXI6K0C8gpXi7k+EjJlWkKGnJ+
	 E2n/01PBELVIyQEX2bZzu9scsztUDEXkSWleG9FeNvrVy7RoFMGLarRm2IRvMxiHAiy/F
	 US+qvvonDpIxHXxZw3EhJoipbcbRunMbo6GSBQ+KOvTUDakVfQbB38vI6agBNXI5B8bkn
	 RPIFY/j3C963hm3T20FHlUZp8yAURlE8FzbcD5iZa+pOrbwnNRSz21vxDDCqN46id4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ym2P2NazjfoQWaOrz2Dx7HGtDy9rTZurvAvDFFsLlrk=;
	b=0OednkjgSkkp3jar/e0XYf05+wea6+8VNcNFucrWSykaemuzhyGbUkwvKeQBf/wajIwo
	 UcBYZg1yg77lXvJIYVP/+Zd81mllVp/CCVcpivaTtYoUVll3H/Kt8DlWLAijvuhhq6jsk
	 fglxKmvo5QJSNCGV7nj0dnlUyI6V9Kjvo6byPO9ypax8qELx09tbXqlh9qrxCWH8Mk2no
	 MH9ofk2DZdK6yJscqpjTeFQEz/2oaW7vdEFPjmIKFuw30kptOIzjqyezxE3ppGmFE463R
	 ecl1rMBkUwd5RJrDn/cayApqOTN/BTuafPmsGl9x6aeL22cASvKP8Vg2QYJDEytfJgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkTeOahp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D48F606A31C;
	Wed, 18 Nov 2026 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkTeOahp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EF611F000C4;
	Wed, 18 Nov 2026 16:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018385;
	bh=ym2P2NazjfoQWaOrz2Dx7HGtDy9rTZurvAvDFFsLlrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkTeOahpYykn1WrLPmQfZLVw0p6e5KzQYwbCxEV2xdRdIvDmvun+lGEnBmTLEpKpn
	 DU9XG0TDpPN4pp15oAzY9zi4BvmroapGzxs4kIhZZQU+P7ZdXR8lYVyHb0Apen0hi6
	 FWmcyGv1uULZe444AimCtr0Fv1hNQz8hb145tI5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Horgan <ben.horgan@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1181/2651] arm_mpam: Ensure MBWU counters are reset on restore
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118150330.525075243@linuxfoundation.org>
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

[ Upstream commit 80db6616c710a358391516ad82de44361580f8da ]

When an MSC becomes inaccessible due to cpu offline CFG_MBWU_CTL is set to
zero in mpam_save_mbwu_state(). This is very likely to mean that the config
will mismatch when restoring and so the monitor will be reset. However, the
state may have been lost and so there are no guarantees. Ensure the reset
happens by setting the reset_on_next_read and remove the unnecessary writes
from mpam_save_mbwu_state().

Fixes: 41e8a14950e1 ("arm_mpam: Track bandwidth counter state for power management")
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
[morse: Restored clearing of CTL register for kexec/powerdown]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_devices.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/resctrl/mpam_devices.c b/drivers/resctrl/mpam_devices.c
index 8ada8eca049b3..8223e764e46e7 100644
--- a/drivers/resctrl/mpam_devices.c
+++ b/drivers/resctrl/mpam_devices.c
@@ -1652,6 +1652,7 @@ static int mpam_restore_mbwu_state(void *_ris)
 	u64 val;
 	struct mon_read mwbu_arg;
 	struct mpam_msc_ris *ris = _ris;
+	struct msmon_mbwu_state *mbwu_state;
 	struct mpam_msc *msc = ris->vmsc->msc;
 	struct mpam_class *class = ris->vmsc->comp->class;
 
@@ -1659,16 +1660,20 @@ static int mpam_restore_mbwu_state(void *_ris)
 		if (WARN_ON_ONCE(!mpam_mon_sel_lock(msc)))
 			return -EIO;
 
-		if (!ris->mbwu_state[i].enabled) {
+		mbwu_state = &ris->mbwu_state[i];
+
+		if (!mbwu_state->enabled) {
 			mpam_mon_sel_unlock(msc);
 			continue;
 		}
 
 		mwbu_arg.ris = ris;
-		mwbu_arg.ctx = &ris->mbwu_state[i].cfg;
+		mwbu_arg.ctx = &mbwu_state->cfg;
 		mwbu_arg.type = mpam_msmon_choose_counter(class);
 		mwbu_arg.val = &val;
 
+		mbwu_state->reset_on_next_read = true;
+
 		mpam_mon_sel_unlock(msc);
 
 		__ris_msmon_read(&mwbu_arg);
@@ -1703,13 +1708,10 @@ static int mpam_save_mbwu_state(void *arg)
 		cur_ctl = mpam_read_monsel_reg(msc, CFG_MBWU_CTL);
 		mpam_write_monsel_reg(msc, CFG_MBWU_CTL, 0);
 
-		if (mpam_ris_has_mbwu_long_counter(ris)) {
+		if (mpam_ris_has_mbwu_long_counter(ris))
 			val = mpam_msc_read_mbwu_l(msc);
-			mpam_msc_zero_mbwu_l(msc);
-		} else {
+		else
 			val = mpam_read_monsel_reg(msc, MBWU);
-			mpam_write_monsel_reg(msc, MBWU, 0);
-		}
 
 		cfg->mon = i;
 		cfg->pmg = FIELD_GET(MSMON_CFG_x_FLT_PMG, cur_flt);
-- 
2.53.0



