Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B2178B61;
	Tue, 27 Feb 2024 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043636; cv=none; b=rQF4IipZFHNgF35dQx/RFamZCAxMbV8mDETvlZefPaCHwh2yZi0Whm0ZEPrRLxbOHyx6q9elPCefLcAJpvDzemKKrkDNQRVY3sUZ4SCXwitYEDjAHggpXOmdBnoUo6nF2ytGZAcyV8izpa8rtITOcZJZfuzYwJFXsU/lxwefyjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043636; c=relaxed/simple;
	bh=w9WzCQ9FtAumBqlioULiDnWJLifsamx8FUfFpLDIc/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMXHx17/bEHsn+lAmxOcdH6h/4csNGiLVhj0o/7iEMtF335yx9FzaUcldMQDewr9WSbFu/E1VCvohR8Q67K3dmndsVrd5nIuH/9twNZ73W13MVwjpYWN+ohMIwci2QBExWpOnX20afHNWpzaPxEz7lWSnnyZUBmdcncQ5K5fAWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9Gpk/ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9Gpk/ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97956C433F1;
	Tue, 27 Feb 2024 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043636;
	bh=w9WzCQ9FtAumBqlioULiDnWJLifsamx8FUfFpLDIc/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9Gpk/acKAkcq9+xCJ0jhBR2JwilB9RHaqixFmv25hyQgeo99YFn3DBzu5qV9sB57
	 9sAF+VO0kECahvREMhqjCvyIHE2pDrwoeDXBqbk5HRtyqjZPpVYMwTlNqX3VZno2sw
	 TiSo+hEjd1L97cDA1CTx65tM6IgT2QDK9hdqdcm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/195] platform/x86: thinkpad_acpi: Only update profile if successfully converted
Date: Tue, 27 Feb 2024 14:27:03 +0100
Message-ID: <20240227131615.762204358@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 427c70dec738318b7f71e1b9d829ff0e9771d493 ]

Randomly a Lenovo Z13 will trigger a kernel warning traceback from this
condition:

```
if (WARN_ON((profile < 0) || (profile >= ARRAY_SIZE(profile_names))))
```

This happens because thinkpad-acpi always assumes that
convert_dytc_to_profile() successfully updated the profile. On the
contrary a condition can occur that when dytc_profile_refresh() is called
the profile doesn't get updated as there is a -EOPNOTSUPP branch.

Catch this situation and avoid updating the profile. Also log this into
dynamic debugging in case any other modes should be added in the future.

Fixes: c3bfcd4c6762 ("platform/x86: thinkpad_acpi: Add platform profile support")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240217022311.113879-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 6edd2e294750e..c2fb19af10705 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10511,6 +10511,7 @@ static int convert_dytc_to_profile(int funcmode, int dytcmode,
 		return 0;
 	default:
 		/* Unknown function */
+		pr_debug("unknown function 0x%x\n", funcmode);
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -10696,8 +10697,8 @@ static void dytc_profile_refresh(void)
 		return;
 
 	perfmode = (output >> DYTC_GET_MODE_BIT) & 0xF;
-	convert_dytc_to_profile(funcmode, perfmode, &profile);
-	if (profile != dytc_current_profile) {
+	err = convert_dytc_to_profile(funcmode, perfmode, &profile);
+	if (!err && profile != dytc_current_profile) {
 		dytc_current_profile = profile;
 		platform_profile_notify();
 	}
-- 
2.43.0



