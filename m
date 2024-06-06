Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E75199396;
	Thu,  6 Jun 2024 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683219; cv=none; b=SBg1v+aaxZxrWGX2OXn0IF2zhPoDa74kXf3EXmBEVp1HQbzCztNYtqsTaf3semqjvOAjnz3zyuDwnbfow9NHxsep8Z6Jb5JI06rQja+2IjIwEZODD11pjSJVJqvAcmWGrKnELWNf47PR9gn8yYB3yHXTZMrAJKaRDdDO11yNu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683219; c=relaxed/simple;
	bh=Ww3CIt8ehR9OHqu49/6SVH2cHBfjfXYfUPvaTuGH0oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpOrTgxR9+jnUtCMX5RI/1zQxmSP+UrZjQct/vI025TLgkmSOU9zC5y85vn4pdgGUtGOZAK0N5Sy2iXJnxMhOckEwTZoPjEzZ5/LABDVnhjT9IlCEkwkwXDjRmopVuBBsgfDJYibxKCH34W71siQw61WhosvZqm/EmEoWDX79ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2uCIyU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2uCIyU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F23DC2BD10;
	Thu,  6 Jun 2024 14:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683219;
	bh=Ww3CIt8ehR9OHqu49/6SVH2cHBfjfXYfUPvaTuGH0oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2uCIyU+hCqWh7BkbkES3ALwQPaj2REAe/VGYwfKR7sxEY9WfAhBLFRTLYwXSVcYG
	 U2Ma85az9jlSMNf6d/IU0Kdw11WdtJuNcgihmWEqzvCMyZt+8KxhmRpD1tn1Vkzc8H
	 I9HfUqoFgjnDx5oI896eKuH3/sPCrPYTHOmzb4Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/473] ACPI: Fix Generic Initiator Affinity _OSC bit
Date: Thu,  6 Jun 2024 16:00:25 +0200
Message-ID: <20240606131703.075066957@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3015235d65e31..e4e7b2cfe72af 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -582,8 +582,8 @@ acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *context);
 #define OSC_SB_PCLPI_SUPPORT			0x00000080
 #define OSC_SB_OSLPI_SUPPORT			0x00000100
 #define OSC_SB_CPC_DIVERSE_HIGH_SUPPORT		0x00001000
-#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00002000
 #define OSC_SB_CPC_FLEXIBLE_ADR_SPACE		0x00004000
+#define OSC_SB_GENERIC_INITIATOR_SUPPORT	0x00020000
 #define OSC_SB_NATIVE_USB4_SUPPORT		0x00040000
 #define OSC_SB_PRM_SUPPORT			0x00200000
 
-- 
2.43.0



