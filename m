Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DD23BFE59;
	Thu, 15 Jan 2026 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497916; cv=none; b=HEZQ9yrwIh7PdQP8xAaM+DPxo3xr1w+0bgVoNUho2f9LjFhtT7u8HuaKOFC9/GkQrhth9nE4u8RPFifHPbvOt2h4CPijgmF4fvJRISUPTSDKERtA6HvvXcfletiXcja42JXSAnEEODlN3B1tv3JhTWx2wNMZVtdLrarMjZzASrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497916; c=relaxed/simple;
	bh=XaSEIipyskvIe/8CHLwqR3pn73m8dYWuajYqYYeQ+aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phEZa9BEnA2Di7w2D+M5sgg8DVEGnSHkghsfiR761q/SYCZ54mWxnMQ8tlp6JgJ7yG3GVQvUfYrhk2GVZ/nwWiLsMwbJ5INLO+p9t7t3VREIhKTFxGRoVcWIYihjlkhhdYNG7zFt2zox+US9SS9BSXHlDWrd7DcMKYtXkX9jvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBgqMXJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBgqMXJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27C2C116D0;
	Thu, 15 Jan 2026 17:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497916;
	bh=XaSEIipyskvIe/8CHLwqR3pn73m8dYWuajYqYYeQ+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBgqMXJU927YtgWp3oyYnY6AlUwABBs3D0nt/S+DSyts/1iQEPw3Mn5nbNV0so3gC
	 y5/Ch+jNcV67gRe794vs9FY05Vlu6GezIbUwR97zlUMzZ2c69jufeInaHNt2MFaij7
	 6UNLXRgl569qzzIfHadGwctwnDf/vME0E9C+tzmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 249/554] ACPI: CPPC: Fix missing PCC check for guaranteed_perf
Date: Thu, 15 Jan 2026 17:45:15 +0100
Message-ID: <20260115164255.251223632@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit 6ea3a44cef28add2d93b1ef119d84886cb1e3c9b upstream.

The current implementation overlooks the 'guaranteed_perf'
register in this check.

If the Guaranteed Performance register is located in the PCC
subspace, the function currently attempts to read it without
acquiring the lock and without sending the CMD_READ doorbell
to the firmware. This can result in reading stale data.

Fixes: 29523f095397 ("ACPI / CPPC: Add support for guaranteed performance")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Cc: 4.20+ <stable@vger.kernel.org> # 4.20+
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251210132227.1988380-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1198,7 +1198,8 @@ int cppc_get_perf_caps(int cpunum, struc
 	/* Are any of the regs PCC ?*/
 	if (CPC_IN_PCC(highest_reg) || CPC_IN_PCC(lowest_reg) ||
 		CPC_IN_PCC(lowest_non_linear_reg) || CPC_IN_PCC(nominal_reg) ||
-		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg)) {
+		CPC_IN_PCC(low_freq_reg) || CPC_IN_PCC(nom_freq_reg) ||
+		CPC_IN_PCC(guaranteed_reg)) {
 		if (pcc_ss_id < 0) {
 			pr_debug("Invalid pcc_ss_id\n");
 			return -ENODEV;


