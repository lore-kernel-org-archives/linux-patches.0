Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5902268683;
	Tue,  8 Apr 2025 11:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110586; cv=none; b=MjFXn6fNUGMDzUY+kTi0DFV1KbF0YU2SyhQu+obKvanfNI1DOamH0SsXyPgaMOdpllYqA1vo+sVg5xkLrVT/SfHuPGFh8ua/xIFkXHcPvgv6k1XIx5Ud+R5mxz4YGRGgJy0YW6h4W/dG8BBZuOkTtYFm+vo1XlU18rYjdXxj1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110586; c=relaxed/simple;
	bh=IHcAyMBmVRQpA9Z1zbnEQv0YavBoN4FVxdfycY8nj/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrB/FJWUiMlxSXHNPXf1JUjOjc7WzqrD9mgAya06Nv1UwbxAn6S6/HRzz6jq09d46qY/gqKzAOxoc0bAO7A2Pd/GZho1cj6jND2ZAHXBqpUfKlkdXi3UAYnk90JkZrMtPJig6wQcWC00RopAmePx87hNuut/9hRsNybe9ZH5lD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzMwh+kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzMwh+kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3514FC4CEE5;
	Tue,  8 Apr 2025 11:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110586;
	bh=IHcAyMBmVRQpA9Z1zbnEQv0YavBoN4FVxdfycY8nj/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzMwh+kUj32ecslt8tyOlHHlCoqweJPTYa1tNjmaGEh2y2OWLg2Mh7HTvV19mv6hY
	 0A48+L9SNaS9CTWcN9PpEYh9c3QoCgqJSGOtxA2DLImXE+sPNJAs/wQAgsk8gD42Ah
	 2OdHBGNFg64qhWD41MZzpmR4p5W6O3vRLR3AgAHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Homescu <ahomescu@google.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 118/731] firmware: arm_ffa: Skip the first/partition ID when parsing vCPU list
Date: Tue,  8 Apr 2025 12:40:15 +0200
Message-ID: <20250408104917.022911878@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit c67c2332f8c80b03990914dfb66950c8d2fb87d8 ]

The FF-A notification id list received in response to the call
FFA_NOTIFICATION_INFO_GET is encoded as: partition ID followed by 0 or
more vCPU ID. The count includes all of them.

Fix the issue by skipping the first/partition ID so that only the list
of vCPU IDs are processed correctly for a given partition ID. The first/
partition ID is read before the start of the loop.

Fixes: 3522be48d82b ("firmware: arm_ffa: Implement the NOTIFICATION_INFO_GET interface")
Reported-by: Andrei Homescu <ahomescu@google.com>
Message-Id: <20250223213909.1197786-1-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 25b52acae4662..655672a880959 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -935,7 +935,7 @@ static void ffa_notification_info_get(void)
 			}
 
 			/* Per vCPU Notification */
-			for (idx = 0; idx < ids_count[list]; idx++) {
+			for (idx = 1; idx < ids_count[list]; idx++) {
 				if (ids_processed >= max_ids - 1)
 					break;
 
-- 
2.39.5



