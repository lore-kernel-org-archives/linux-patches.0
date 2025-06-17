Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19861285057;
	Tue, 17 Jun 2025 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178666; cv=none; b=CU8PeX3kQiPN/44UUY+2JNOvcMtMZny4hGGvoj2r8MeNzCMkn6s8ip00ZRSdjOkcV8W8bEU45k4mComJlvjbxnAqizs9tE/lOLUfCDJbsVuSYCzcgpU+PQQgxUmdny7+AvH3pmBvRy0i9tWjH9qPkllv7QyQinnXiGF4YM6oRZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178666; c=relaxed/simple;
	bh=nJybdNTsiYNPm1Bl1o2Zc3AHX3+BUHZteAaktbG+mCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ih+kS29jimRcj+8D3tkA1L21y8DdV1T1qnnDRntW7wSYZrY9csLEsuFwT4dT2/yZiOCcHCRy+8Zz6Sz1j77rVmeN2LpBzwyi/Crl18o4UWkyVPmMoJRWcBF+pJS/wXOKKoPj1CLA7KbBI1giWau8G+0P4kinbu5LW0AvWlImcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc3+40sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc3+40sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A4BC4CEE3;
	Tue, 17 Jun 2025 16:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178665;
	bh=nJybdNTsiYNPm1Bl1o2Zc3AHX3+BUHZteAaktbG+mCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yc3+40sPHG+TQL2Lapv0iq+5nAyO0Lv7g3/UOcWpwSz68FfKG1XGmvPyUwJAA5nEJ
	 yrKP0DxSHC4912l5rqrPJlb1eFwv+qJb8APNNnlwuJbjVR4ot/Hdwq489nbTYlHdz6
	 EHMF/n8NrBFkgar9y8wLWrwdPTdg+Q9gBoan/TK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 517/780] thunderbolt: Fix a logic error in wake on connect
Date: Tue, 17 Jun 2025 17:23:45 +0200
Message-ID: <20250617152512.563725335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1a760d10ded372d113a0410c42be246315bbc2ff ]

commit a5cfc9d65879c ("thunderbolt: Add wake on connect/disconnect
on USB4 ports") introduced a sysfs file to control wake up policy
for a given USB4 port that defaulted to disabled.

However when testing commit 4bfeea6ec1c02 ("thunderbolt: Use wake
on connect and disconnect over suspend") I found that it was working
even without making changes to the power/wakeup file (which defaults
to disabled). This is because of a logic error doing a bitwise or
of the wake-on-connect flag with device_may_wakeup() which should
have been a logical AND.

Adjust the logic so that policy is only applied when wakeup is
actually enabled.

Fixes: a5cfc9d65879c ("thunderbolt: Add wake on connect/disconnect on USB4 ports")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/usb4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index e51d01671d8e7..3e96f1afd4268 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -440,10 +440,10 @@ int usb4_switch_set_wake(struct tb_switch *sw, unsigned int flags)
 			bool configured = val & PORT_CS_19_PC;
 			usb4 = port->usb4;
 
-			if (((flags & TB_WAKE_ON_CONNECT) |
+			if (((flags & TB_WAKE_ON_CONNECT) &&
 			      device_may_wakeup(&usb4->dev)) && !configured)
 				val |= PORT_CS_19_WOC;
-			if (((flags & TB_WAKE_ON_DISCONNECT) |
+			if (((flags & TB_WAKE_ON_DISCONNECT) &&
 			      device_may_wakeup(&usb4->dev)) && configured)
 				val |= PORT_CS_19_WOD;
 			if ((flags & TB_WAKE_ON_USB4) && configured)
-- 
2.39.5



