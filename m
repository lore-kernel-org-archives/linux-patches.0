Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87C739BEBE;
	Tue, 16 Dec 2025 12:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888697; cv=none; b=iALKWEZBEBRSiIV33/SrDktta4ZbXIFKwVaiTDyz1fAmIrV7UaTe+/s4R5QFnwAGw9pkb/50ecz311mnitBgx015aBPNl//Jo7FRMnFEJyviHZVJ+5deOwrfnfdS0fLsukiP0OGLvRizMDeaWc+Bkijj1FFiuDC+b8Ew3pBnD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888697; c=relaxed/simple;
	bh=RasqgUJDQewVd7MRRgmF64HVi37Z1qo2qmeD8s2KpW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcH6dxAqWW2iFkSmYpa3KBrLtzogwGXHR+C4bg4Su3YGyzetVjB18DQIMGvHAAq0CAs8six8nZXN56vDiWAlo0vzrrVORZnQypGbM4GukaviYX8ch8zyITOmhT2vaY67egVdBCu0fDPlzlbXwkJoc5E8PcFtq9BeNYxZsmOl/lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGIw3HMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGIw3HMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD7C4CEF1;
	Tue, 16 Dec 2025 12:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888697;
	bh=RasqgUJDQewVd7MRRgmF64HVi37Z1qo2qmeD8s2KpW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xGIw3HMiqxMt62SEQ2RiKhVMoNXvixkglkwT8Q2h4QUQlWpYr8L86mvYawuGAnDVP
	 RVetFqmNIBAXrQYj8nOS3R41VHiy4dKZbC7W5GHoBvoHmrv5vgStX415J432tCB5h7
	 leHCinIcIUnvzYGqUG7N+S14vD6mnX5CNAvYkGEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 612/614] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()
Date: Tue, 16 Dec 2025 12:16:19 +0100
Message-ID: <20251216111423.572857147@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Denis Arefev <arefev@swemel.ru>

commit c34b04cc6178f33c08331568c7fd25c5b9a39f66 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/cs35l41_hda.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1901,6 +1901,8 @@ static int cs35l41_hda_read_acpi(struct
 
 	cs35l41->dacpi = adev;
 	physdev = get_device(acpi_get_first_physical_node(adev));
+	if (!physdev)
+		return -ENODEV;
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))


