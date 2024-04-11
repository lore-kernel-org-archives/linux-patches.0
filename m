Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A503C1DDE9;
	Thu, 11 Apr 2024 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830383; cv=none; b=PFBpIow4jRz2Lp+XGga8c3HH8YJ3SXRSmZUhjDJeAKxSfvpm0cwNh4dtMoBt/Nl9ig5O37TaADGi6P9uFkeRunBhg0uI35PGXnqdBL39MteUVw/JoHepUvmnLts/CZiYv3x6yIWHxCOTFhye+7iRsVqbRLNaKyaZ4kbDLN3mjbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830383; c=relaxed/simple;
	bh=RrgRRlamKe0OW0G8DDpHmPSdxOpKqxAPgLGO/kvGANk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqM8VS4G4FOjnDsP/jbPKeOiY7WkgYLmeepmpFi+xm7cmzVcEGpgL2sY14MxQNo94gCdqIoMp+SoMqpMiBW3D7eGGL062chJrBnAEhtFabwx9SvRoNr6a4wI41hGP08ZRMlsE8lt7nr/BU6qw7UXUP7JrCvLRigzWatgsVvcQtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHl4DAo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHl4DAo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2C7C433F1;
	Thu, 11 Apr 2024 10:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830383;
	bh=RrgRRlamKe0OW0G8DDpHmPSdxOpKqxAPgLGO/kvGANk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHl4DAo4KR75I2PheD+9ewIlrUkI9K3iDJhcOC0CBzOxDT5ZWT7Sb1+FDzu4Kioil
	 4mO+5MAeztSDzNrGUhF1AVvUIFrN/ZB/sTBOilAWEdyEAZGcKi2SFGjzubSnVE6L03
	 twaVxhETwHu3EALDLxLiE2aFi59VP6NfUmFQE7Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 126/143] modpost: fix null pointer dereference
Date: Thu, 11 Apr 2024 11:56:34 +0200
Message-ID: <20240411095424.698209649@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 23dfd914d2bfc4c9938b0084dffd7105de231d98 ]

If the find_fromsym() call fails and returns NULL, the warn() call
will dereference this NULL pointer and cause the program to crash.

This happened when I tried to build with "test_user_copy" module.
With this fix, it prints lots of warnings like this:

 WARNING: modpost: lib/test_user_copy: section mismatch in reference: (unknown)+0x4 (section: .text.fixup) -> (unknown) (section: .init.text)

masahiroy@kernel.org:
 The issue is reproduced with ARCH=arm allnoconfig + CONFIG_MODULES=y +
 CONFIG_RUNTIME_TESTING_MENU=y + CONFIG_TEST_USER_COPY=m

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mod/modpost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 6568f8177e392..ce686ebf5591f 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1053,7 +1053,9 @@ static void default_mismatch_handler(const char *modname, struct elf_info *elf,
 	sec_mismatch_count++;
 
 	warn("%s: section mismatch in reference: %s+0x%x (section: %s) -> %s (section: %s)\n",
-	     modname, fromsym, (unsigned int)(faddr - from->st_value), fromsec, tosym, tosec);
+	     modname, fromsym,
+	     (unsigned int)(faddr - (from ? from->st_value : 0)),
+	     fromsec, tosym, tosec);
 
 	if (mismatch->mismatch == EXTABLE_TO_NON_TEXT) {
 		if (match(tosec, mismatch->bad_tosec))
-- 
2.43.0



