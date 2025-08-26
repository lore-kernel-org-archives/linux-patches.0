Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF2017332C;
	Tue, 26 Aug 2025 11:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208456; cv=none; b=YMaLOAFfi+DdPz83Ms17EAixfZnivYaQ98I4V0rpLZr5tmL+/861Qwp+F63v9o4PY636v++6OjPPpjBQW9ZB9iqO2d3xv8fAs9Pc6P070jGVz6197cJ70Uz6qX7zk9OldZpOpCEOn+riwRTvV2Lpgdfa0cK1VKvKdrGOFk5Z8hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208456; c=relaxed/simple;
	bh=aUWBy0JrP+a3KyInS2H7vLCc1ZsUdv3CVh5TN0gPVqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UacOGD/5nTkcAD82hTUc73jIbKEBKzE3eJQmj7jDt0CZGIuaKvOFB6WarMZ61dAAwblf4TNkHrdzoWQlBat0kch9npFeuzFMJ8AreT/aGpFRbpVcQQ6DlN9nX1+CzQFQIoEC2abn2x9NDLZXx65Gx5OnbblKXH2Gq5NzP0pL7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8t2Kat6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8t2Kat6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CDAC4CEF1;
	Tue, 26 Aug 2025 11:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208456;
	bh=aUWBy0JrP+a3KyInS2H7vLCc1ZsUdv3CVh5TN0gPVqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8t2Kat6UJiUsFxpADNc5CGNX/b0SpPyo5kkQCIrs8ANEkZHGyxw/7NTTn9TsKipr
	 GD/Za75Og2E/wJRTmqDcfaKFsdRrQ/X6xeu7nWF5lQU0OHXGfmNtZNoleT64TDb2Ui
	 AVS9XbISXZ5G7u0QvxzaDqmq0kXib5M8Fft3bho8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 119/322] drm/amd: Restore cached power limit during resume
Date: Tue, 26 Aug 2025 13:08:54 +0200
Message-ID: <20250826110918.738505882@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit ed4efe426a49729952b3dc05d20e33b94409bdd1 upstream.

The power limit will be cached in smu->current_power_limit but
if the ASIC goes into S3 this value won't be restored.

Restore the value during SMU resume.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250725031222.3015095-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 26a609e053a6fc494403e95403bc6a2470383bec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -2153,6 +2153,12 @@ static int smu_resume(void *handle)
 
 	adev->pm.dpm_enabled = true;
 
+	if (smu->current_power_limit) {
+		ret = smu_set_power_limit(smu, smu->current_power_limit);
+		if (ret && ret != -EOPNOTSUPP)
+			return ret;
+	}
+
 	dev_info(adev->dev, "SMU is resumed successfully!\n");
 
 	return 0;


