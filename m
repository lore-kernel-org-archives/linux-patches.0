Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621822F1B;
	Thu, 18 Jan 2024 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575040; cv=none; b=GUosEJXdBrInOWYf6w8f/5uiL6uSb5u40ERtCGlccblUshkEXMhs7EAL/5gyL5pUWVv+tM2of2Kj+B4HMMRKJOllNPwbNNIcMPzZnSD7DQ2PCqH5d/S6uo0DEYvHMbjNpitYbx8RLgOzCxyFjxj007+RFrXiTzY+m/Jyv83PrGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575040; c=relaxed/simple;
	bh=g/d12xICLI6H6AAQ6scq6beCrHXhI03isVAHKyWFy+Q=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=TBDob2CBv3eXMs0lXgxfdkI9/zOXm/pV3D+Hz/cfta8/e/GUC9wO3egTpVtWi99YtxKv6LzN5piG1FnNnHLugVH67j3AqosuxUp+3aOcXllqegD5sjBEY7Ds2bhE2SUuLCJ5dsyMJFmJzBUqNc32UqkR0VvSpFuUlz7eMnP6dxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stOT3/Bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stOT3/Bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F08C433C7;
	Thu, 18 Jan 2024 10:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575040;
	bh=g/d12xICLI6H6AAQ6scq6beCrHXhI03isVAHKyWFy+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stOT3/Bo57DM0POCD/zI2wDSoFRGU2RwJJlTkpOrlR9qT5HcGAckCKSKkjX+B94OI
	 7gQXBZs9zp2cyOLHlMy9Iqh10G5fWdt3fn9w+bE7lqpLpeojfjJIvaPUuNJtI2GUK6
	 8nWHcUUjWeyxE9OK+HdvRey8vuaA9DC2FDgf9d/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenz Brun <lorenz@brun.one>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 08/28] ALSA: hda: cs35l41: Support more HP models without _DSD
Date: Thu, 18 Jan 2024 11:48:58 +0100
Message-ID: <20240118104301.521904009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenz Brun <lorenz@brun.one>

commit 7d65d70161ef75a3991480c91668ac11acedf211 upstream.

This adds overrides for a series of notebooks using a common config
taken from HP's proprietary Windows driver.

This has been tested on a HP 15-ey0xxxx device (subsystem 103C8A31)
together with another Realtek quirk and the calibration files from the
proprietary driver.

Signed-off-by: Lorenz Brun <lorenz@brun.one>
Cc: <stable@vger.kernel.org> # v6.7
Link: https://lore.kernel.org/r/20240102214821.3394810-1-lorenz@brun.one
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/cs35l41_hda_property.c |   44 +++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/sound/pci/hda/cs35l41_hda_property.c
+++ b/sound/pci/hda/cs35l41_hda_property.c
@@ -42,6 +42,28 @@ static const struct cs35l41_config cs35l
  * in the ACPI. The Reset GPIO is also valid, so we can use the Reset defined in _DSD.
  */
 	{ "103C89C6", 2, INTERNAL, { CS35L41_RIGHT, CS35L41_LEFT, 0, 0 }, -1, -1, -1, 1000, 4500, 24 },
+	{ "103C8A28", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A29", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A2A", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A2B", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A2C", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A2D", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A2E", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A30", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8A31", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BB3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BB4", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BDF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE0", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE1", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE2", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE9", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BDD", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BDE", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE3", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE5", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8BE6", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
+	{ "103C8B3A", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4100, 24 },
 	{ "104312AF", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 1, 2, 0, 1000, 4500, 24 },
 	{ "10431433", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
 	{ "10431463", 2, INTERNAL, { CS35L41_LEFT, CS35L41_RIGHT, 0, 0 }, 0, 1, -1, 1000, 4500, 24 },
@@ -354,6 +376,28 @@ static const struct cs35l41_prop_model c
 	{ "CSC3551", "10280BEB", generic_dsd_config },
 	{ "CSC3551", "10280C4D", generic_dsd_config },
 	{ "CSC3551", "103C89C6", generic_dsd_config },
+	{ "CSC3551", "103C8A28", generic_dsd_config },
+	{ "CSC3551", "103C8A29", generic_dsd_config },
+	{ "CSC3551", "103C8A2A", generic_dsd_config },
+	{ "CSC3551", "103C8A2B", generic_dsd_config },
+	{ "CSC3551", "103C8A2C", generic_dsd_config },
+	{ "CSC3551", "103C8A2D", generic_dsd_config },
+	{ "CSC3551", "103C8A2E", generic_dsd_config },
+	{ "CSC3551", "103C8A30", generic_dsd_config },
+	{ "CSC3551", "103C8A31", generic_dsd_config },
+	{ "CSC3551", "103C8BB3", generic_dsd_config },
+	{ "CSC3551", "103C8BB4", generic_dsd_config },
+	{ "CSC3551", "103C8BDF", generic_dsd_config },
+	{ "CSC3551", "103C8BE0", generic_dsd_config },
+	{ "CSC3551", "103C8BE1", generic_dsd_config },
+	{ "CSC3551", "103C8BE2", generic_dsd_config },
+	{ "CSC3551", "103C8BE9", generic_dsd_config },
+	{ "CSC3551", "103C8BDD", generic_dsd_config },
+	{ "CSC3551", "103C8BDE", generic_dsd_config },
+	{ "CSC3551", "103C8BE3", generic_dsd_config },
+	{ "CSC3551", "103C8BE5", generic_dsd_config },
+	{ "CSC3551", "103C8BE6", generic_dsd_config },
+	{ "CSC3551", "103C8B3A", generic_dsd_config },
 	{ "CSC3551", "104312AF", generic_dsd_config },
 	{ "CSC3551", "10431433", generic_dsd_config },
 	{ "CSC3551", "10431463", generic_dsd_config },


