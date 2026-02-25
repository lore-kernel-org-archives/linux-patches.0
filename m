Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3359C27E1DC;
	Wed, 25 Feb 2026 01:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983931; cv=none; b=VSzvUneI9EdkfQDgg6SVG2zpK9zwJNOV1t/ung7VKwqE/HKqkJCiGDLMYJjNpbQ5piLLPvzDUhuM3x4R0yjxCRCPVK/oX5sB4HgLN0/L5yV4SCpuQnpK5Gog6VOKORE74SNgDnS7pYDb5QzrFTOMU1HBsF/gDzL4zQnSIizEF8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983931; c=relaxed/simple;
	bh=frUfTgUhOC10gLZDNR4jiyy8RNQLN/68E6sr8H88rik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS60IDwd/qawgeqkZIN3phrwB82Qx+OYgFZ4wN0dgkUdppv6obsO0lk6Cdu4PF09wEGv0YYv5MAyWtDd4/jkayHAu+elaI5csFyl8+ui3VmhFvUiMkgsNKbJvGOioKH0e7JMReliME8CnbQHjnxFrlj32fHfGe+urDR/cHq6R6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wygYh3ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wygYh3ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B84C116D0;
	Wed, 25 Feb 2026 01:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983931;
	bh=frUfTgUhOC10gLZDNR4jiyy8RNQLN/68E6sr8H88rik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wygYh3eeAKMcSM3ThwSwIQV9w+FSiXVcYKsmKlChO5Kupvs7wYfZBODJDyqhS6rVK
	 X520EVxE7JlU+YexR3112DSuEQiL77E4EFpGEqUc9T3GrQcV7UJDFXFoytTT8tXn+z
	 Mp8oU/6t3ARL+4pyNfuHdW6jEJeQOS2pg3RI4Dck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/641] HID: playstation: Add missing check for input_ff_create_memless
Date: Tue, 24 Feb 2026 17:18:43 -0800
Message-ID: <20260225012353.757390828@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit e6807641ac94e832988655a1c0e60ccc806b76dc ]

The ps_gamepad_create() function calls input_ff_create_memless()
without verifying its return value,  which can lead to incorrect
behavior or potential crashes when FF effects are triggered.

Add a check for the return value of input_ff_create_memless().

Fixes: 51151098d7ab ("HID: playstation: add DualSense classic rumble support.")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index e4dfcf26b04e7..2ec6d4445e84b 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -774,7 +774,9 @@ ps_gamepad_create(struct hid_device *hdev,
 #if IS_ENABLED(CONFIG_PLAYSTATION_FF)
 	if (play_effect) {
 		input_set_capability(gamepad, EV_FF, FF_RUMBLE);
-		input_ff_create_memless(gamepad, NULL, play_effect);
+		ret = input_ff_create_memless(gamepad, NULL, play_effect);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 #endif
 
-- 
2.51.0



