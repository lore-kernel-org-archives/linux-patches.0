Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F601350A3A;
	Tue, 21 Oct 2025 20:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077224; cv=none; b=CQMm2W+24BfNY5EUVpXdLYTGyWNZJoIM5cJZQ2sm6NPrF9NP2uER8737cWi4FSmUoHm9nzAdD674NYt7YhCS/p0NO9dHYZS05QX2rlKo8DmqgcLQ0eLy5mKMGaHBig0h0XALHJtV62VA5ZJ6BiGd8i6sdZ6uyBDxQpYNdg5NFXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077224; c=relaxed/simple;
	bh=Pet8mZuTEAmeDoxOH1q/eVMdXoT4wp0gsp1HW3Rodvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le9wCSeEl5P7SHQgv49dd+uP4UKs9n57EVir8iy9PaNS57jlgwYpWSbJeNg2yGSPbckE8/6gh/OfSDziFBMyBAToDFth1SbHlpQn7XiTn7WQs3568eYVl1k6ez5a9RgZFmcPx3C0/CDuZlTFEp4h8ZLrVVEiq1C7Oo3IqJEXGyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxwAfROp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxwAfROp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE833C4CEF1;
	Tue, 21 Oct 2025 20:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077224;
	bh=Pet8mZuTEAmeDoxOH1q/eVMdXoT4wp0gsp1HW3Rodvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxwAfROpS1leNdJdEzeKJ/2wndEicKKk5w7Mzw5otW5LeiRDAB1XWP/yOIG5bU0vt
	 IoMx6Nt64ORZGl4irmySRlXsSmt1cbVRENsdUPjrNTXMQRiNfQvf8Fe0rzcox3p/JW
	 7iS9xEGpTAwoMdtgTZFx6E+OTGakAwoOKv63S6do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Arefev <arefev@swemel.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 037/159] ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_get_acpi_mute_state()
Date: Tue, 21 Oct 2025 21:50:14 +0200
Message-ID: <20251021195044.089958406@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Arefev <arefev@swemel.ru>

commit 8527bbb33936340525a3504a00932b2f8fd75754 upstream.

Return value of a function acpi_evaluate_dsm() is dereferenced  without
checking for NULL, but it is usually checked for this function.

acpi_evaluate_dsm() may return NULL, when acpi_evaluate_object() returns
acpi_status other than ACPI_SUCCESS, so add a check to prevent the crach.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 447106e92a0c ("ALSA: hda: cs35l41: Support mute notifications for CS35L41 HDA")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Arefev <arefev@swemel.ru>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/side-codecs/cs35l41_hda.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1426,6 +1426,8 @@ static int cs35l41_get_acpi_mute_state(s
 
 	if (cs35l41_dsm_supported(handle, CS35L41_DSM_GET_MUTE)) {
 		ret = acpi_evaluate_dsm(handle, &guid, 0, CS35L41_DSM_GET_MUTE, NULL);
+		if (!ret)
+			return -EINVAL;
 		mute = *ret->buffer.pointer;
 		dev_dbg(cs35l41->dev, "CS35L41_DSM_GET_MUTE: %d\n", mute);
 	}


