Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647A335E551;
	Fri,  9 Jan 2026 12:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962917; cv=none; b=h+tMpJwI+bwuTTK2Gcmkji97/BhbS3wA1FYpLZj/gvLMRRz9wlPbwktLRZhQzfVf2jb99eS3dm2UQyx39MxKJRDpRYh8x46fIynEDCL8xoVSTySdlp5cQeFOwXvqK3GxtRSKxoyQboW8ITmZ7/erNsYce8Lbiyna0Foer19Mk0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962917; c=relaxed/simple;
	bh=WOSJJDzCshTIulFLsjl4NCMgQk+NpQCrUHLJWAXOpIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgayPhbKcv9ADNKO5DaP8Gx0YjBHxW1r4olFr440m9CShWmpghmjfDkSvldJT170bUl0pAwnm6tMgTO/DRfBBs8KFKzXjRGrHyB1Wr+vWtRsoZhuBckmr2GQGk4igMdxHHkG6qeo7suDWX/HVZzrDIyZYjMP1kqln4Jy7+Qkowc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dr/hCUF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dr/hCUF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0F3C4CEF1;
	Fri,  9 Jan 2026 12:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962917;
	bh=WOSJJDzCshTIulFLsjl4NCMgQk+NpQCrUHLJWAXOpIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dr/hCUF2btO5fMuEj8Lz7DK5oIg9MdCCJVBd4rET3d/ziCLQBpe4xHEb4nG5OAn0v
	 zZ+07XCWrrAtfFtUvzlYYf7y8QPEiVhEYqazBcLAHChDx4CtGkZLIBJXFPI54vjXAZ
	 4Xay8PpZ7wWXDmU99B7FU0Pi9TBNwttT+FE2j5tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 534/634] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()
Date: Fri,  9 Jan 2026 12:43:32 +0100
Message-ID: <20260109112137.667226800@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1278,6 +1278,8 @@ static int cs35l41_hda_read_acpi(struct
 
 	physdev = get_device(acpi_get_first_physical_node(adev));
 	acpi_dev_put(adev);
+	if (!physdev)
+		return -ENODEV;
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))


