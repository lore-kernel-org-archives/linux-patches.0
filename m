Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF453264DF;
	Thu, 28 May 2026 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000779; cv=none; b=dYk8evR5DgX9+3QY5yz0zJJbhnEqsWRd62FfTMKWKACdF6usJAmpgDoXWcqyl4ltO72OIydAG/dKatuKyM1PNkb+LB8QVFdaPUSfg8MVzk9CAfuwkx/rwb+59DG7kuwyW28H+0PClgSQRJFPXdYFFpU2ZpcSwqV7N7XgujtaXfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000779; c=relaxed/simple;
	bh=D7T6KDi2rHEWEQ+pFPMkhc73cGtz5JPH1cKOB8qf2T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6zNWZ+F35PsGcHE4yb7nrgEAQaK3nxV3dxIVwpiepFiA8lnD7lv5uDIVgxCkH61/VCDDy8bRYgeKWncZr7743q6dd3B9+LCycNWDVDH0A4KUJmuGapqGf5OkmDyfMSfu1CIgUNg/bUNgOD33tqfFMCLip+BaPoQJ9USpqyK5y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsRWrx4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsRWrx4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802A31F000E9;
	Thu, 28 May 2026 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000778;
	bh=4y0SoloXFQTWr8+HKEVMokgsySm3mBeBeJSC8CJVOHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsRWrx4KeQskFHLkvBNhcoWp3y7zoPcvBGUf0h9EaUToOUeY3veN4iS0mglfh2VVn
	 nhxXoLUh9fEkKzXRRtH9QhrYRuwFNGeLyryOdx4mxGl3hEpjxEg0+64NL7aBY4EQu7
	 KZ+JIeWqTnU18raXYJVlR4nPaVHUm10KUEMbMoJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/272] ALSA: hda: cs35l41: Put ACPI device on missing physical node
Date: Thu, 28 May 2026 21:48:58 +0200
Message-ID: <20260528194633.924125419@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuhao Fu <sfual@cse.ust.hk>

[ Upstream commit fca7401fe37f7abc6e54147ea560f37279231137 ]

acpi_dev_get_first_match_dev() returns a refcounted ACPI device and
callers must balance it with acpi_dev_put().

cs35l41_hda_read_acpi() stores the returned ACPI device in
cs35l41->dacpi. That reference is normally released by the later
probe cleanup or the remove path, but the NULL-check on
physdev exits before either of those paths can run.

Drop the lookup reference before returning -ENODEV.

Fixes: c34b04cc6178 ("ALSA: hda: cs35l41: Fix NULL pointer dereference in cs35l41_hda_read_acpi()")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Tested-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260428081238.GA1659932@chcpu16
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index e115b9bd7ce3d..42c576d9f1179 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1865,8 +1865,10 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 
 	cs35l41->dacpi = adev;
 	physdev = get_device(acpi_get_first_physical_node(adev));
-	if (!physdev)
+	if (!physdev) {
+		acpi_dev_put(adev);
 		return -ENODEV;
+	}
 
 	sub = acpi_get_subsystem_id(ACPI_HANDLE(physdev));
 	if (IS_ERR(sub))
-- 
2.53.0



