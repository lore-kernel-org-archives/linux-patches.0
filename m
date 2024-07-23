Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7563213D600;
	Tue, 23 Jul 2024 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759536; cv=none; b=Eht5oB9uiYdqXuGnz7IDRH5jIesTUE2fdw8P0ppnqjwYRu2cPxraxs6VruuAeRLONaZk1DmXNrYwHiHCo7+OVruvGzU0rN5ckFV2G9TiN4zgkOgVDwClyhYVYazjQ6O7xUYi1tAoJW84RZnG35zHw3OB9E2zP9zGSv3FG/ST004=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759536; c=relaxed/simple;
	bh=aaHOqgRnvMPiDqpGUTIqjvBPtC8apTIbUgAVzlUhLMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8kxuw8w9l9O/oDAAhhRsrWD7wWr2L6Zu2EV2TAF6REc4e/1RhD5Qhlhr8IsImQCFzMHAUiRPZKEd+q5/VPVoYuxVDdgCRWB0yH7Iw0QLwoeG+scTFPo4+l9vRoYWTtXecpRHQf0Eh/N8rdByYfixaHVFHGq3vvTjsAep4TJVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAt4RNpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAt4RNpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E8AC4AF09;
	Tue, 23 Jul 2024 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759536;
	bh=aaHOqgRnvMPiDqpGUTIqjvBPtC8apTIbUgAVzlUhLMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAt4RNpamLSWJ8Pg3Lw+IIk/rmxZHCrWDPfXxofP4Wme8Hxq5zHlAUn3InCf7c2YP
	 mDzG9rZ8CA8UXMivKNqcqNZPNsYoHAkB7E19nZCL+2tBRSG33wXD8me3B3esb0VCJM
	 Qhn9fKgEDQdeojoG/kfMd4vz7djGHW7W2uD0ZhC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/129] mei: demote client disconnect warning on suspend to debug
Date: Tue, 23 Jul 2024 20:23:12 +0200
Message-ID: <20240723180406.491482847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 1db5322b7e6b58e1b304ce69a50e9dca798ca95b ]

Change level for the "not connected" client message in the write
callback from error to debug.

The MEI driver currently disconnects all clients upon system suspend.
This behavior is by design and user-space applications with
open connections before the suspend are expected to handle errors upon
resume, by reopening their handles, reconnecting,
and retrying their operations.

However, the current driver implementation logs an error message every
time a write operation is attempted on a disconnected client.
Since this is a normal and expected flow after system resume
logging this as an error can be misleading.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240530091415.725247-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index bb4e9eabda978..c018534c780f9 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -329,7 +329,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



