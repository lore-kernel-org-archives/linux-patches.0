Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A5613AA50;
	Tue, 27 Feb 2024 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042338; cv=none; b=ojfzmo4XNCpMRO10KATLxBKfsSbktj0U4TW6JBz4cdAkDt0+vK6u9eagq1FKQs608w+G95PAiDkO+EykQxy01RabZNE2au49lptYku/ej/PhKXZONx30xIXzVkg/uExVSchYlbnRfpas9JLLjpcx+Caz2I4lLzZQ5RZtUwCQ2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042338; c=relaxed/simple;
	bh=UrYo1fI1aVVsQs2huk3IvS4RTSXvEI/11YWLwKXPiOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT9T1h0hYk/XUJkzTyX37mdeXpEbcugzzmjO7u+Z+iZV6PtCQO2S9ov1gfVj/wizxeISuEZMW3ZmisOIdSrQmGVbHECLapIwSeymJMmkDLuNHBzRz4Y0A3taBkr+4XyFxzNO46+6vk02GzQNtY05COz3RVc4bOqxUmBgqcQ+On8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQpFwRqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQpFwRqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409C7C433C7;
	Tue, 27 Feb 2024 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042338;
	bh=UrYo1fI1aVVsQs2huk3IvS4RTSXvEI/11YWLwKXPiOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQpFwRqrTNnsrEbGl5tI5OtZ2i5E+byB9IS2yte2H1G6HSv7ZLkPLA1Q9SMh5+6YH
	 8a6oe6voUrGLXm4gNlLs7oUpuVpykgKm6ZbZvsaGYG6E/cRbgG9DQG8X8VhSe0kQAi
	 M92d27hTGZCnxxH5zBij5M9hSvyl+qaGbfinowXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 260/299] platform/x86: thinkpad_acpi: Only update profile if successfully converted
Date: Tue, 27 Feb 2024 14:26:11 +0100
Message-ID: <20240227131634.071129630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d73cbae4aa218..89c37a83d7fcd 100644
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



