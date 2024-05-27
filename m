Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1DA1607A1;
	Mon, 27 May 2024 19:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836590; cv=none; b=Fm/bK7othlLgRWIkRWUslp1fus0KB1w4uF8Db+C5vommq9Wn/CtlIx41GJgZwwMY+kBL7qbIR7oqjcLnOBUk/cBXvd5Uln8NvFxVy2NqSkJe6dou+/ar8pLpST7LeVc6m6Mok6PZauThuEZpqTl28hUUnYRnZd5c7LYN5b7js20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836590; c=relaxed/simple;
	bh=FkEAw1NMo8FKE7SmBeG8cImGKJyAu8FLXdCdmz5aIPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxLaMIC4FupUw5Jj0E+XgkOftdu3wLYIc4/cW3kcBCTmsWItIrI6/tjw6KJUdRk4POJUc7IkQ4eYVDZAYgNfRavtIxvAJezCgj27jAgk5RcWpIJT/C1JMhAHXUV63lKKTnA//hAihfKWkGQFV+WG53ydi+ey63M3nn+0DCQwtO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtOewKbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtOewKbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4122EC2BBFC;
	Mon, 27 May 2024 19:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836589;
	bh=FkEAw1NMo8FKE7SmBeG8cImGKJyAu8FLXdCdmz5aIPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtOewKbGdqO0toslHUukrIKUoi2PeYtgG4fR8vR6TqZ+8ilkPT1UdRmXG8nIcw+z2
	 rvMfbdV7LZ22mcG38rzj7Jw1b2uLKHuTbN2uKCOoKG9hoDuqqeN7LxS34ZSqxLVhVh
	 78esvv+TgPvY43jmDg6z/J42V/TL/4L8ojXtFPdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 113/427] ACPI: Fix Generic Initiator Affinity _OSC bit
Date: Mon, 27 May 2024 20:52:40 +0200
Message-ID: <20240527185612.323052078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit d0d4f1474e36b195eaad477373127ae621334c01 ]

The ACPI spec says bit 17 should be used to indicate support
for Generic Initiator Affinity Structure in SRAT, but we currently
set bit 13 ("Interrupt ResourceSource support").

Fix this by actually setting bit 17 when evaluating _OSC.

Fixes: 01aabca2fd54 ("ACPI: Let ACPI know we support Generic Initiator Affinity Structures")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index b0d909d1f5fc3..e77783e101c36 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -577,8 +577,8 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_OVER_16_PSTATES_SUPPORT		0x00000400
 #define OSC_SB_GED_SUPPORT			0x00000800
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
-#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
+#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00020000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
 #define OSC_SB_PRM_SUPPORT			0x00200000
 #define OSC_SB_FFH_OPR_SUPPORT			0x00400000
-- 
2.43.0



