Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6F2242907;
	Tue, 20 May 2025 14:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750061; cv=none; b=UFL0ysSYVo4g65TyK0G5JS7/+9rZd8/f01+YzXDqasFk0wQyj+V1gYylaXYeyTO16rF3EYqWFoew7ZFKne/BBZjGuj8exMDD5aTijMm9/NuuCqTZCF4rY4m1T7Vinh4yB1Xr2Y1XMmgFFwi2Lx9JqRQo37jrIkLWiqR0QIwJFAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750061; c=relaxed/simple;
	bh=ZGmDlnskt9+4St0FAr8s1zj1jfM2kZBqlN+1my0jJpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzszlJYwieY2Z4tiASLaHdYim9VMC+OxEcvBfI8PkkQSDO+rD8whPZxUr2xbnGKfcack4Hg6hUHz77smkoDjWA3gOYqSvxeXjMmZdgLhsaVFzcEveLmeO1+2cqcb1Dl1SZpAiFf7S+ALOTCqJUkWXsXZmJJ/UPK8OhiDx44O7HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjATIgC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjATIgC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C36C4CEE9;
	Tue, 20 May 2025 14:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750061;
	bh=ZGmDlnskt9+4St0FAr8s1zj1jfM2kZBqlN+1my0jJpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjATIgC/kfbcCvYBhRwgECYvNw4KIx23owLqY1Ib2JA5hf4B3RHhqNvf/XvvSr7Ew
	 Ao1P1L79iOav5CiUFgHbkhhggv8Hl+i1yNgoa017QRc+8w6hau9P9ePabG2k2ByxFx
	 w1g6nuSjFkVCwf3mCV3M2t3VScTLoT9mnMN2FUks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/143] HID: uclogic: Add NULL check in uclogic_input_configured()
Date: Tue, 20 May 2025 15:49:44 +0200
Message-ID: <20250520125811.194924582@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit bd07f751208ba190f9b0db5e5b7f35d5bb4a8a1e ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
uclogic_input_configured() does not check for this case, which results
in a NULL pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: dd613a4e45f8 ("HID: uclogic: Correct devm device reference for hidinput input_dev name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index d8008933c052f..321c43fb06ae0 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -142,11 +142,12 @@ static int uclogic_input_configured(struct hid_device *hdev,
 			suffix = "System Control";
 			break;
 		}
-	}
-
-	if (suffix)
+	} else {
 		hi->input->name = devm_kasprintf(&hdev->dev, GFP_KERNEL,
 						 "%s %s", hdev->name, suffix);
+		if (!hi->input->name)
+			return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
2.39.5



