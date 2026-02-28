Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23814ADDA5;
	Sat, 28 Feb 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301315; cv=none; b=G/CT8gjlN1H1+3BtcqcdAsKeUU8cMGupD1lSFr+mpHWRobLdvGyWiiTcQWVlUqbzFfBYQQOitjCyP4v48q9sEFThbbQvc4r1NeFGhfpD/fFLJZR6OTW9ds6ttBpilsbJfB+KDE3D5kRSr0vMZd6pZm34nirx0TleVLLphe+Anqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301315; c=relaxed/simple;
	bh=OssYHVtpqWoKQFKjafrGzXcfF6y3P6GuD0ExBSD0byU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4UpKMwEDdtoKuDlg4hHzh5TDPri3aqqu1iKan0tRttpffrzmocDR25lUaw5Cj5e9Em02sKDJINY82qAkDyQT4/sbb21XPK1zV94K7FTiczqcGNmRzaZy69EFULycB3KKGqQqq24yg4zvwT3c4cFakiBLBpafRx3RNcDezlt7cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpOVC/4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpOVC/4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B69EC19423;
	Sat, 28 Feb 2026 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301315;
	bh=OssYHVtpqWoKQFKjafrGzXcfF6y3P6GuD0ExBSD0byU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mpOVC/4FCc2HCJEWOWEGSMJlhJbXm8NPLhpMTgPfw8yoFgU+h5lrSZeYWgLzlJLf0
	 zw64Xekd8hSR3yPNbdOb4BzTyX9ujT6s8/vCmMNzNr9Sd1ccu0a4Zkd/RoKjvFD7ax
	 Su5dyw409q5ekS2ikiyIyS7Yu4AZ5zRjI69XuZVMrUbfl1Xjq6GVpim6aoFBZpvH8+
	 0R8kmeTkj2hHSaHCNZWq8uQC/+1uRwkCRgXqynHLTp1VNBieE4mGpJBCKCnvFwtobu
	 zSqLe0soeofIWmgq6VrrSRoMp7eX+3RZrW52O4x7EFzfv7xTY4/JBV51O6P3C+3tQ5
	 OJ0n1QL6mdT0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Oliver Neukum <oneukum@suse.com>,
	stable@vger.kernel.org,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/752] HID: hid-pl: handle probe errors
Date: Sat, 28 Feb 2026 12:43:32 -0500
Message-ID: <20260228174750.1542406-501-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 3756a272d2cf356d2203da8474d173257f5f8521 ]

Errors in init must be reported back or we'll
follow a NULL pointer the first time FF is used.

Fixes: 20eb127906709 ("hid: force feedback driver for PantherLord USB/PS2 2in1 Adapter")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-pl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-pl.c b/drivers/hid/hid-pl.c
index 3c8827081deae..dc11d5322fc0f 100644
--- a/drivers/hid/hid-pl.c
+++ b/drivers/hid/hid-pl.c
@@ -194,9 +194,14 @@ static int pl_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		goto err;
 	}
 
-	plff_init(hdev);
+	ret = plff_init(hdev);
+	if (ret)
+		goto stop;
 
 	return 0;
+
+stop:
+	hid_hw_stop(hdev);
 err:
 	return ret;
 }
-- 
2.51.0

