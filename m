Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC510242D92;
	Tue, 20 May 2025 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749770; cv=none; b=XtfNWFvaXfOi8naqbrUCpvLmvZzkk5EqSK4xWAKnFGqUuF0sp+eZL0HHS2BBw8F7vfus2M/1aaQ8oTC3MrWYkzYb1E6++tGrRHQFbd7wsHW8ezstej3Ed+tGVYFPtMZNe/dnLZwscIlo9L3T7ebc8Q3lJ1XpfTzeMPzb4YCGsFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749770; c=relaxed/simple;
	bh=K3akb0ELxL9O28CBr3MC7skzNCFiiwt7DnohKU/+d8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRLmqzRwlIg2P7Z4meVu1byhg7R6c3LdqKno56TU1zDDs5S/IIodfQ9tf6iwd1ufZRm9ocr83glEN0zA/PK4Qrtw96ORhUnp5mFtkoPmKwJ9Sar9VVNf2V7EhljGYkoyTsRiTnII4vAOsrRlKSHCppj1+03dN42G/KJkBMsLPyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKWe6a0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKWe6a0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BA8C4CEEA;
	Tue, 20 May 2025 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749770;
	bh=K3akb0ELxL9O28CBr3MC7skzNCFiiwt7DnohKU/+d8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKWe6a0G8WOiRVlXV5/8ziPJQ04RQXgQvnXCgLz9yySlQPgt1i9taZfCzJHKp8mL5
	 mQT8RgXjVOQqceQdFQ8m6v9aUuXxdX9HKH5P0FjfYS11PGYLn6yCz8RsWX2T5GmjSB
	 p3OA25dGRFe/4Ry/wHvYLy/lR9CQnMwuh3D91DEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/117] drm/amdgpu: Fix the runtime resume failure issue
Date: Tue, 20 May 2025 15:49:49 +0200
Message-ID: <20250520125804.939032847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit bbfaf2aea7164db59739728d62d9cc91d64ff856 ]

Don't set power state flag when system enter runtime suspend,
or it may cause runtime resume failure issue.

Fixes: 3a9626c816db ("drm/amd: Stop evicting resources on APUs in suspend")
Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Stable-dep-of: d0ce1aaa8531 ("Revert "drm/amd: Stop evicting resources on APUs in suspend"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index 8b8e273662b39..a6fd52aed91ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -1534,6 +1534,9 @@ bool amdgpu_acpi_is_s0ix_active(struct amdgpu_device *adev)
  */
 void amdgpu_choose_low_power_state(struct amdgpu_device *adev)
 {
+	if (adev->in_runpm)
+		return;
+
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
 	else if (amdgpu_acpi_is_s3_active(adev))
-- 
2.39.5



