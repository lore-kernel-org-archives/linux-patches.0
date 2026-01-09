Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEC82737EE;
	Fri,  9 Jan 2026 12:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961102; cv=none; b=SYsb7rsCHbXt1SmZZilIZ+RzqGv5ngui6QObHFcB7f9AALgY5G68PfQe9HLx/GguZseb0xmCSzIuxCgKkQUiV/YPAbLN2BevYNvQq9nEnO5qiLzKMXGXC7n4ocZLhb5rXURz+VRr9ceg/VKg/p4zMcv6kwxsig7kD7OIUAH3cRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961102; c=relaxed/simple;
	bh=fyuTTcZOFkqyvZJR5cH/6ws+R83o8Ub192TXV7ntk8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEdsLgC2qU/3vuKaWLpsOtxw4kAGz0aAcndCplIGAHyRMYkOQWAq/cbHO1Czsu7zrQcZKNliosty5W/PjaVVn0YXqpCyq4iOduA2FEfX/Ag9kXelvZJOOXBPCTY5APhjJFJGcl0YvKfRHHfP7nRoZ22eG7/xnfuiziM9erhYkZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ0LPYqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ0LPYqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE326C4CEF1;
	Fri,  9 Jan 2026 12:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961102;
	bh=fyuTTcZOFkqyvZJR5cH/6ws+R83o8Ub192TXV7ntk8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJ0LPYqUZ0aDLl6xCi+xfrjMgjqKfV/rUq1ZvgSiO/RgpijOocW+sBwyduueskCXp
	 JqB8dyHdsYQIfqLG4mkxobxKUMp2AFo1uPQqP3re8Gh8sE41aj83Vu/KGp52P1jjis
	 RXrwE0vqoSzq73fwTnoBN6pZL/pNKiA7doZz9D9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 634/737] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()
Date: Fri,  9 Jan 2026 12:42:53 +0100
Message-ID: <20260109112157.856948629@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

[ Upstream commit c34b04cc6178f33c08331568c7fd25c5b9a39f66 ]

The acpi_get_first_physical_node() function can return NULL, in which
case the get_device() function also returns NULL, but this value is
then dereferenced without checking,so add a check to prevent a crash.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7b2f3eb492da ("ALSA: hda: cs35l41: Add support for CS35L41 in HDA systems")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251202101338.11437-1-arefev@swemel.ru
[ NULL check right after acpi_dev_put(adev) cleanup call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1432,6 +1432,8 @@ static int cs35l41_hda_read_acpi(struct
 
 	physdev = get_device(acpi_get_first_physical_node(adev));
 	acpi_dev_put(adev);
+	if (!physdev)
+		return -ENODEV;
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))


