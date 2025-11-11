Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930444C97;
	Tue, 11 Nov 2025 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822458; cv=none; b=NM0oZ/fsCiLud34gMAow5JQKgVLrDZD4N8RqZgQuHBzrDEbahIdHJZol+VmR3HcL1u7dqByZ/YFfBqMKWyZdotyuazM8zO1yGnaoYqDKLNgAUR4w5+wMSwNMCHx50CbnayPiqJbf+zuBRS44SvFY4UpFaiJ6VTgr6pS6vrOeI/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822458; c=relaxed/simple;
	bh=I/CIMITgADnLa8a4mDYFSQhI3h3mf0yuxGytgK6wjRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqaCTHUMIsLeDc2KgE1b3TGsFNPHiPcww9Hdb/NjJUMi8GoTeIKb1ysxCRbBUfkVyEZuC+iH+hJvEz+cXek/wt4aFMIwXKht0ikTaELlA2zYWyr/qYAm8lPiJ594K9eNPt9JMaPf8L6Xm3HmAysoEeHRWQ5xjZYmTMlGtJ3enHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4MM5uIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4MM5uIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C395C19422;
	Tue, 11 Nov 2025 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822458;
	bh=I/CIMITgADnLa8a4mDYFSQhI3h3mf0yuxGytgK6wjRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4MM5uIOZynYsl0wB9c+etxGAs6YfcpWlcQ9iRVwUEFX68a1EMZvrmW/6sTosrXw4
	 0Fu+CpWfdhm3STw/nHH1mQfk8UAibuvcK8QexZj8KWCiZSsxQyBtqTiDrmaKhTmN2N
	 zFPwummRktSQ8YKnqF4zv2SJVR1YbxNI9oVBTTOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/565] drm/radeon: Do not kfree() devres managed rdev
Date: Tue, 11 Nov 2025 09:38:30 +0900
Message-ID: <20251111004528.130674499@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 3328443363a0895fd9c096edfe8ecd372ca9145e ]

Since the allocation of the drivers main structure was changed to
devm_drm_dev_alloc() rdev is managed by devres and we shouldn't be calling
kfree() on it.

This fixes things exploding if the driver probe fails and devres cleans up
the rdev after we already free'd it.

Fixes: a9ed2f052c5c ("drm/radeon: change drm_dev_alloc to devm_drm_dev_alloc")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 16c0681617b8a045773d4d87b6140002fa75b03b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_kms.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 645e33bf7947e..ba1446acd7032 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -84,7 +84,6 @@ void radeon_driver_unload_kms(struct drm_device *dev)
 	rdev->agp = NULL;
 
 done_free:
-	kfree(rdev);
 	dev->dev_private = NULL;
 }
 
-- 
2.51.0



