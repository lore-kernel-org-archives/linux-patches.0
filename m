Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B332F2D;
	Tue, 27 Feb 2024 13:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041289; cv=none; b=k3jQOPiuaMKUnW8iro5jijx0qZbIoewN801JDIpPfm7HlvklrxFSF1OCIHmHnnXWIVu4lWG5IUJlz1v5iaHYbdOvkt14ZdsqxsGBArN9rZCUAKFEOGNpTfi728yDiVvmCr15nmMQDiMIiLayDbIu4+QxVWd+mkSb3CUfk2W9FzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041289; c=relaxed/simple;
	bh=+OnFaFCWCSy94JQqElc/lQlU5oBoNEpN9FkI45XrWI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mbh+k7FZYYmVeAXx88sYJH1aqmYcUO3tbnmYDEbrtH4TiEfzv0Ht7m06u0lppBVj1m2Pg+LQcOq9psa9PbBR38lUhvVMERN1AB+GBQaGQ6n4TQKXTnXcuK/gCe6wSm1qVTa9EedkrIS0Q/nZpLH60wKb68adJGeS8I4QZtc9Mn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbLZQpeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbLZQpeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F6EC43390;
	Tue, 27 Feb 2024 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041288;
	bh=+OnFaFCWCSy94JQqElc/lQlU5oBoNEpN9FkI45XrWI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbLZQpeA/PKPCh33xvK27CVjTKXL+b/gYfsacwJ9lngcnsGLF4w57nx7+ZQRLBoqF
	 3StEp/WTdQHDhNTrRXjudzl1895HbHFP3ZAgA8MxS6wZYukOpVu6xb8tNlpBgUfYPf
	 lQR6gXH7xNEh4gUGXw4w71FMyEB8kn4Svc4LlMDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 287/334] platform/x86: thinkpad_acpi: Only update profile if successfully converted
Date: Tue, 27 Feb 2024 14:22:25 +0100
Message-ID: <20240227131640.263096437@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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
index c4895e9bc7148..5ecd9d33250d7 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10308,6 +10308,7 @@ static int convert_dytc_to_profile(int funcmode, int dytcmode,
 		return 0;
 	default:
 		/* Unknown function */
+		pr_debug("unknown function 0x%x\n", funcmode);
 		return -EOPNOTSUPP;
 	}
 	return 0;
@@ -10493,8 +10494,8 @@ static void dytc_profile_refresh(void)
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



