Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAAC37E2E5;
	Thu, 30 Jul 2026 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425412; cv=none; b=eyMZP+DT03Hvkv/y8bV/E9+5deYO5jXvmFq/KPKVw5EzxlRKEMY56Vh0oVkDNgn6347MquN9XuJO1551fZg4ZxIvDF9DMhDDLWodvNhV+RJ+BzMQp1ztl5CZnEFf6FvG38KWX3tvVqjF9+TGcyA9lvL7j5q3cupqvGcIz5pH4DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425412; c=relaxed/simple;
	bh=0/J1IEwMOxtMXbY12ZJBIcIE/sQoCLsaOFMMgTQRMwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/sjVUJyYChj4B7At32HD1G/JzCK/5sg0qMVt8GbCDZhW3FYXJOLMokZ8pAAx9xY8R+cwPHc+uhbHDxRP5bolQjS8kM/LyE5R8KplLMBRviFqHqq/OyqPseYC7LHXEa+2gV0kJpDSIeWGGbmmT8nN/xigiufaoqv9iCzFhTgw98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0Xm0xE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0Xm0xE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD231F000E9;
	Thu, 30 Jul 2026 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425409;
	bh=tp83tGty8zcDBcxTh0Ktir3LZbPZht8eHTSf5H89yXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0Xm0xE5iQg93o4H9w4KnfO2A37G3GZWszu4Ke6raW+wjFwbKBV6dcK3gv4fmKofP
	 +xyavD6BgnUaBJ+dY+ZK1Z8dVd3Pi2ATv8tmLrupbMSy2j3XfkEej2WH6Ow/6BqfQw
	 DeBhq8cAqZtgkLqx0ajBvx97QuLrmcbr+2sniUK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/602] wifi: libertas: fix memory leak in helper_firmware_cb()
Date: Thu, 30 Jul 2026 16:07:32 +0200
Message-ID: <20260730141437.263209682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

[ Upstream commit 63c2391deefb31e1b801b7f32bd502ca4808639b ]

helper_firmware_cb() neglects to free the single-stage firmware image
after a successful async load, leading to a memory leak in the USB
firmware-download path.

Fix this memory leak by calling release_firmware() immediately after
lbs_fw_loaded() returns.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
the current wireless tree.

An x86_64 allyesconfig build showed no new warnings. As we do not have
compatible Libertas USB hardware for exercising this firmware-download
path, no runtime testing was able to be performed.

Fixes: 1dfba3060fe7 ("libertas: move firmware lifetime handling to firmware.c")
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Link: https://patch.msgid.link/20260624085343.575508-1-dawei.feng@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/firmware.c b/drivers/net/wireless/marvell/libertas/firmware.c
index f124110944b7e9..9bf7d4c207b9ed 100644
--- a/drivers/net/wireless/marvell/libertas/firmware.c
+++ b/drivers/net/wireless/marvell/libertas/firmware.c
@@ -78,6 +78,7 @@ static void helper_firmware_cb(const struct firmware *firmware, void *context)
 	} else {
 		/* No main firmware needed for this helper --> success! */
 		lbs_fw_loaded(priv, 0, firmware, NULL);
+		release_firmware(firmware);
 	}
 }
 
-- 
2.53.0



