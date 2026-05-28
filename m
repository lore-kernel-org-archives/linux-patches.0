Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8804326B973;
	Thu, 28 May 2026 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998522; cv=none; b=WXFy55BlqnfUqY9lkP6rP3XcLEHrdyifNW7HZAjzJ5aNS7ZjXLGcVBKm/ZcOC6+smdN0/D0xG7T15lHhlr+9gnRfNhJdZg2W194uB6MhScFeBMlkMw569lCurIzyAkJXqzc0FwdnlvyjN5ydTzMpXlzgw+nTwQ+0GjeWh7yDG4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998522; c=relaxed/simple;
	bh=Y5IdkzHbVELWhrzvjrfmM49UvvW6tBH814Exyv/Mvz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrWDnMC6XuJaIggsdq0AF/8cWeC8XhCeULzJ6+Vlb9xIx24gnqi6RuHoFJTvIJI96DLM304f5MKmsLts968HapxX9tztZd9hPPClBuAukZ3qh3TNMN6Z1dbMGfDQ8PQ9nJlj+ClvBQSY8sv4Fk+QcDJOGLvk27SDokYqdQUbadY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb+EHBPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb+EHBPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBF51F000E9;
	Thu, 28 May 2026 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998521;
	bh=v8CcjAWxye0Pk5NJsIYT/L37dV4AMGCSgHuLo31asqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tb+EHBPESMO1K8nLkPYa551WcCx85PFHqg0c3IRMBnkxUW9WyJuups4P0KkXLRv8E
	 zamhTrYH0WVza/Ox8kVQiM+zA74HinVWmAAQi6ehFDkLalUmJKEU/GbwDozVPF3TTa
	 urxtjmn6POMVZV/jbsqt9ccW8zibSvSB7PyvkSFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 204/461] ALSA: hda: cs35l56: Put ACPI device after setting companion
Date: Thu, 28 May 2026 21:45:33 +0200
Message-ID: <20260528194653.010640346@linuxfoundation.org>
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

[ Upstream commit aa2fbece1b07954ef26488c800d126a36a8ab93e ]

acpi_dev_get_first_match_dev() returns a refcounted ACPI device and
callers are expected to balance it with acpi_dev_put().

When no companion is already attached, cs35l56_hda_read_acpi() looks
up an ACPI device and sets it with ACPI_COMPANION_SET(), but leaves
the lookup reference held.

ACPI_COMPANION_SET() does not take ownership of that reference, so
drop it with acpi_dev_put() after attaching the companion.

Fixes: 73cfbfa9caea ("ALSA: hda/cs35l56: Add driver for Cirrus Logic CS35L56 amplifier")
Signed-off-by: Shuhao Fu <sfual@cse.ust.hk>
Tested-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260428080139.GA1649104@chcpu16
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/cs35l56_hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/side-codecs/cs35l56_hda.c b/sound/hda/codecs/side-codecs/cs35l56_hda.c
index 4c8d01799931c..cdbc576569efe 100644
--- a/sound/hda/codecs/side-codecs/cs35l56_hda.c
+++ b/sound/hda/codecs/side-codecs/cs35l56_hda.c
@@ -1041,6 +1041,7 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int hid, int id)
 			return -ENODEV;
 		}
 		ACPI_COMPANION_SET(cs35l56->base.dev, adev);
+		acpi_dev_put(adev);
 	}
 
 	/* Initialize things that could be overwritten by a fixup */
-- 
2.53.0



