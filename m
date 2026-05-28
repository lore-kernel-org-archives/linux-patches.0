Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F102426B973;
	Thu, 28 May 2026 20:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998525; cv=none; b=AwICwjdwalW8Vfsc4PnqZHCRsCMKsTjP0TerPApCJFE+dQvMaT9V5cM5f8+Ta00dCVYD1Lmq++J88ExfHke/SMzuA054OdnXpaaxGtGqWJdIVFxedRJS583DLHw+o4wIQrDti3jw9OQqdNAwbHQHNAUFwI2BvJ7RHQLUjKRJM7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998525; c=relaxed/simple;
	bh=SmTvzbvOGnDVguYp4YI1Fla27TjpvzSRHOlsrurIU/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyENTxQZYc3CKySN3h+RgwW91A5MTyTXKx/vVZuHS80tZ2F8x8oj6XIBdXSqh/ZuTz7USDWxNXqCaeGEIo44JSsdM6WFPwNKCBKJHLSTnlVb+kdfGCoUhC2xPmHi6JaKV3sBp/6q3RPSrd6vU2ROxp2gfGuNGJrLzNkas/tu8a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gadOnr+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gadOnr+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC001F000E9;
	Thu, 28 May 2026 20:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998523;
	bh=/sLfSDFb+86D4J80726+Wso9c+FnWhLaiZkVoCZd2MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gadOnr+2gaVDeU3VmpX/nV9LQv6a0l4Yu3Qezy4FOwKNJiUhCGttee5N6JfkMUnYs
	 Mpjv5V1sjQ960vGQsVSkVNeyX9G8ELuyEWbh5vRtb+K2Lpn/Rz+CsRzfJfCGCoOi2m
	 JkaUpenG7XElAabFv7aHXs2NO7Q296oXfNbj2oWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 205/461] ALSA: hda: cs35l41: Put ACPI device on missing physical node
Date: Thu, 28 May 2026 21:45:34 +0200
Message-ID: <20260528194653.042956328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/codecs/side-codecs/cs35l41_hda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/cs35l41_hda.c b/sound/hda/codecs/side-codecs/cs35l41_hda.c
index b64890006bb70..acfccc848f82d 100644
--- a/sound/hda/codecs/side-codecs/cs35l41_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l41_hda.c
@@ -1896,8 +1896,10 @@ static int cs35l41_hda_read_acpi(struct cs35l41_hda *cs35l41, const char *hid, i
 
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



