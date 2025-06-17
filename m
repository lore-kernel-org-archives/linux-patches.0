Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511212DFF0A;
	Tue, 17 Jun 2025 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177296; cv=none; b=av8zBdkmnkuLr6hOBlKBM+H6bn0UQPe0HSV+t+rYFZHt0lNt5oxyH3bq8Sx1IsQjOadX92F4vMe/YXFiWRAhkdwsxnRhCinyQ5gyjIFgE5rCVhgV+tC9CiZhsRzVbxxPoCSsTCTrgCDgV/cXlg6Q5II9HPa+b3AZRHD24yXlU+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177296; c=relaxed/simple;
	bh=RZw+R8aktxuKN+xF6SMkhyKgIXgW7yOawilHae1I15Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcY3TXr+/u9m9NJ8KsqSWrAnMNMSeOPcf9MV1KlOK4bRpj4Uomf7HxT4cHVpKbV3ZFMURHm9Qeu+uO8r+GALhCd2/bWXyLXY2f264PwdKgojG2EMO3vR5Y1NlKjYaGjNG7azZND5oqTbMMuxLk/bUFIG+m/Wi2LvYViQ5bZ4aCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5Pwp2WU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5Pwp2WU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0630C4CEE3;
	Tue, 17 Jun 2025 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177296;
	bh=RZw+R8aktxuKN+xF6SMkhyKgIXgW7yOawilHae1I15Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5Pwp2WUrbiUAAbARCPE/I/uqvMIpKgYjgLT2olNHizTzYbqBmG8nmC3HWOFCIFP3
	 NQxcTtLKEaAxxz1fKD72v0j0K1wfMR87VUzUFetg6iaHb3ZqUauw2y73m35W4c/NnZ
	 d2GWpCI5zPJAd/qrIHHHQ17z1gVg5DQ5HjG0yk4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/512] thunderbolt: Fix a logic error in wake on connect
Date: Tue, 17 Jun 2025 17:24:49 +0200
Message-ID: <20250617152432.691419642@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 402fdf8b1cdec..57821b6f4e468 100644
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



