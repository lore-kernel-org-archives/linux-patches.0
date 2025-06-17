Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F652E8E17;
	Tue, 17 Jun 2025 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177467; cv=none; b=hSADhngc4MhItbOy9SGC2Gn3WjqwbTQ/Nyu71LK3zqV11arM1TorL8Nz42ODq/T2xobbhDd5sr6f6dcBOPN7H76Sxiva+kWEdVreLjywLlBaEnqFO8XRpF9wWuLEpMVp6rHjD49NOB1S1fkzJvXpkrTZ0He3L2NmINETg4kJRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177467; c=relaxed/simple;
	bh=XUcz4GEi/dn4hzvvFhwJ5o+uD+vf2+VCeWTHEf/tzQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhiVwQWZ6lnh8hchzDj0F2ykTf2Ex1g0mUPkUeFw9hwp9BsUdIhofc75WLtzK+lxcopSkFrzaeO8WpnGj6aEX6CanyAM+140fIm+YBW2ums5R8quufLetkAq8fNOKWHpSbehK1DTebfwP8O/JyHFd0RCQ+WB+NbqlSFDgoO0qow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSwsal3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSwsal3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E794EC4CEE3;
	Tue, 17 Jun 2025 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177467;
	bh=XUcz4GEi/dn4hzvvFhwJ5o+uD+vf2+VCeWTHEf/tzQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSwsal3WEdPQURV+XMNoBV2YdDxTHpWEJWCWZ7Efq+xQ7v4RJhp2e53Zk4yluBLXt
	 8vMvSw34kX/OhwobejIoDy8MwShH3OCu/pG9St8HlBqxg4B49ukoYCm7afdjwR42Kt
	 0iTDyNxinT3uhLeW+dlfVJaj++93ZEIEdRXSjbWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zepta <z3ptaa@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 311/780] Bluetooth: btintel: Check dsbr size from EFI variable
Date: Tue, 17 Jun 2025 17:20:19 +0200
Message-ID: <20250617152504.135100095@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 3aa1dc3c9060e335e82e9c182bf3d1db29220b1b ]

Since the size of struct btintel_dsbr is already known, we can just
start there instead of querying the EFI variable size. If the final
result doesn't match what we expect also fail. This fixes a stack buffer
overflow when the EFI variable is larger than struct btintel_dsbr.

Reported-by: zepta <z3ptaa@gmail.com>
Closes: https://lore.kernel.org/all/CAPBS6KoaWV9=dtjTESZiU6KK__OZX0KpDk-=JEH8jCHFLUYv3Q@mail.gmail.com
Fixes: eb9e749c0182 ("Bluetooth: btintel: Allow configuring drive strength of BRI")
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 48e2f400957bc..46d9bbd8e411b 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2719,7 +2719,7 @@ static int btintel_uefi_get_dsbr(u32 *dsbr_var)
 	} __packed data;
 
 	efi_status_t status;
-	unsigned long data_size = 0;
+	unsigned long data_size = sizeof(data);
 	efi_guid_t guid = EFI_GUID(0xe65d8884, 0xd4af, 0x4b20, 0x8d, 0x03,
 				   0x77, 0x2e, 0xcc, 0x3d, 0xa5, 0x31);
 
@@ -2729,16 +2729,10 @@ static int btintel_uefi_get_dsbr(u32 *dsbr_var)
 	if (!efi_rt_services_supported(EFI_RT_SUPPORTED_GET_VARIABLE))
 		return -EOPNOTSUPP;
 
-	status = efi.get_variable(BTINTEL_EFI_DSBR, &guid, NULL, &data_size,
-				  NULL);
-
-	if (status != EFI_BUFFER_TOO_SMALL || !data_size)
-		return -EIO;
-
 	status = efi.get_variable(BTINTEL_EFI_DSBR, &guid, NULL, &data_size,
 				  &data);
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS || data_size != sizeof(data))
 		return -ENXIO;
 
 	*dsbr_var = data.dsbr;
-- 
2.39.5



