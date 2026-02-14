Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D5C3C2D;
	Sat, 14 Feb 2026 21:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104348; cv=none; b=HCsl4KScEekFUGSB7meSf1lTtjOTQzl9uwjpqwddQHnDtmQvu+Dlh0/MbsLDgfX1JKvwq4qkNejMHBRbZX6SvsOq0S4S2M32l5WR0CVRTHpi7Dh1o1Bj0sCZHliUnL5nQLhMTM7tNx5UbrM4fah45PW9l70N9QhUQ6ARr4/ZPtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104348; c=relaxed/simple;
	bh=qtzvSU1xUyfdSvvz1PfxevNaBtXAPlKkWNlcoDKZVps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXQbMmzRtE7GldYItmdxB72GVVv4UjzigvGM2CkJ1lVVKWNwLal1cUsmiwalwzLD+vSva49vyZ11j7N9KcAiDsNXHvT0TU9A868x3vfnrRY2cnf5sEP2NoC1c1kixp4+GSbSARsPc6S9eOso60hSO1lRx8WyX4q/ELlxEdQyU1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oa6RX6VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oa6RX6VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A3F3C19423;
	Sat, 14 Feb 2026 21:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104348;
	bh=qtzvSU1xUyfdSvvz1PfxevNaBtXAPlKkWNlcoDKZVps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oa6RX6VYkd8MhLZwMWPoKShJtHRDKStl61xeQoUHBWuDG6SJD4goYTNdJ7cimjSJY
	 /A8kznCzRUeBJUrenUd4hUjgZfKuIsG4aHEfVxIuUhTMg0KfEG56A9CL+mKqdwblmQ
	 5beuwJzvRRfFPghT3rdQZy2rApmrgDPp/ZquXzo9AODxaFsVezE7n1q0B06L2j4Fdw
	 fclNWfJHLmb7pkLGImi9mwjCbPyadlScNln9RgzxdmKSULjm89cVQvKYdbE6BRSAbs
	 XPW9SBuaaoUImwXAqNomBGB157aOxt4O1c6rSAS8i9GvH3TL5nXmujZfxge8oWVaYP
	 3+gpKjdm+R8kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	jjohnson@kernel.org,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.6] wifi: ath12k: fix preferred hardware mode calculation
Date: Sat, 14 Feb 2026 16:22:55 -0500
Message-ID: <20260214212452.782265-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit 7f852de0003219c431a6f2ffd951fd82a4673660 ]

For single pdev device like WCN7850/QCC2072, preferred_hw_mode is
initialized to WMI_HOST_HW_MODE_SINGLE. Later when firmware sends
supported modes to host, each mode is compared with the initial one
and if the priority of the new mode is higher, update the parameter
and store mode capability.

For WCN7850, this does not result in issue, as one of the supported
mode indeed has a higher priority. However the only available mode of
QCC2072 at this stage is WMI_HOST_HW_MODE_SINGLE, which fails the
comparison, hence mode capability is not stored. Subsequently driver
initialization fails.

Fix it by accepting a mode with the same priority.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260112-ath12k-support-qcc2072-v2-4-fc8ce1e43969@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The code context confirms that `ath12k_hw_mode_pri_map` is a priority
mapping array where lower values mean higher priority. The
`WMI_HOST_HW_MODE_SINGLE` is in the array, and the fix ensures that when
a mode with equal priority is found, it's still accepted.

### Conclusion

This is a textbook stable backport candidate:

1. **Fixes a real bug**: Complete driver initialization failure on
   QCC2072 hardware
2. **Obviously correct**: The logic error is clear — when the only
   available mode has the same priority as the initial value, strict `<`
   prevents it from being stored
3. **Minimal change**: Single character change (`<` to `<=`)
4. **No new features**: Just fixes the comparison logic
5. **Low risk**: For already-working hardware (WCN7850), the higher-
   priority mode still wins; the `<=` only affects the equal-priority
   case
6. **Tested and reviewed**: By Qualcomm engineers and the subsystem
   maintainer
7. **High user impact**: Without this, an entire class of hardware
   doesn't work

**YES**

 drivers/net/wireless/ath/ath12k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 3ce5fcb0e4600..12f4d378f50d4 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4545,7 +4545,7 @@ static int ath12k_wmi_hw_mode_caps(struct ath12k_base *soc,
 
 		pref = soc->wmi_ab.preferred_hw_mode;
 
-		if (ath12k_hw_mode_pri_map[mode] < ath12k_hw_mode_pri_map[pref]) {
+		if (ath12k_hw_mode_pri_map[mode] <= ath12k_hw_mode_pri_map[pref]) {
 			svc_rdy_ext->pref_hw_mode_caps = *hw_mode_caps;
 			soc->wmi_ab.preferred_hw_mode = mode;
 		}
-- 
2.51.0

