Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6635318B9D;
	Thu, 28 May 2026 20:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001378; cv=none; b=WKxmCcnwZDtVRR9yXC+xsJ16E3KmWJdxNVZkYBTUWuF8UqKf8Aym/ZROnJMR8EsqlGIhjb5sYowALUdYY304enFH8Q2NsWC4uEFAqmk8trYai+RhO5ZT/fJgYWX4ZvzJmJPQ7cmv9kLbQ9/5We1DWV/8/8yjI3xh4ipsCUY10/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001378; c=relaxed/simple;
	bh=Q79LXUiEb6+9cVXytGxW5rnv64luW9tA4+YODGmDez0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pv/2UlW3updLlR6VWDj7bPRUjt5AVMXpqLHjEop7RodzmNNDZOAllADgJoWR35YG+t1R+4G05BvR5gHOdwOwLV8tE9cj5jPVWEH4H4vh1kvOkBdV34edtTyvfH/wzxwlegLgy7YQy3II5lt3CcRUSwWgk9Ed/2p9CII//vCCLvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OycI17mt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OycI17mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A0A1F000E9;
	Thu, 28 May 2026 20:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001375;
	bh=lc5UfDRlqNJF4SyNFHCsKdfkEAoBv1YhKzbP2+nUjNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OycI17mtAXopGvDsFaymuNMVP+bv/uL0Put91T95LIJYQEwCTcG4BurNkn5wU21V5
	 k4UZJPRj4ZLY2MUzensBaZ2HDCU8joGEurCEscHPpByz/avzeeta7pAJKqrk3DO0Km
	 lA0RmBDiEfKIJNJWXicZ9RsEXtdruyfJDM0LKbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhao Fu <sfual@cse.ust.hk>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/186] ALSA: hda: cs35l56: Put ACPI device after setting companion
Date: Thu, 28 May 2026 21:49:44 +0200
Message-ID: <20260528194931.745096822@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
 sound/pci/hda/cs35l56_hda.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/cs35l56_hda.c b/sound/pci/hda/cs35l56_hda.c
index bae7b1d592c6c..afb397c32361f 100644
--- a/sound/pci/hda/cs35l56_hda.c
+++ b/sound/pci/hda/cs35l56_hda.c
@@ -855,6 +855,7 @@ static int cs35l56_hda_read_acpi(struct cs35l56_hda *cs35l56, int id)
 			return -ENODEV;
 		}
 		ACPI_COMPANION_SET(cs35l56->base.dev, adev);
+		acpi_dev_put(adev);
 	}
 
 	property = "cirrus,dev-index";
-- 
2.53.0



