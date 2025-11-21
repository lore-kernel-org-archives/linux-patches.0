Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058E93F9D2;
	Fri, 21 Nov 2025 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731858; cv=none; b=DJhqBraSteUuexJr/zseYpu3d8DpIBX9US22uoQ8yj4+c/+P0xauCipy7d0cXppNiNz2AGPcXV+Qf94wkCW+2qnjJStBFFxfMq4Kk2DC88JVZ10qR5E5vUp+O7lv/yXmY/n6cec8dVzBfkbjMYGYxuwTAQyaWgBMjlQsp+OpLWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731858; c=relaxed/simple;
	bh=qmKRMspvxxmjAZi1q6yzMrYQRluPFc3oSzIr4+L3gCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuhlDclHdoE3rg/6f4vSritm/dNGG5EOv2ZUhW3y1eS7Cjhm65N7/WPE1I2RW9Kk425FKuAExKSkdrT40AwrbTCWhD2GTXnTIna3Cb8ogBj5VV/2aqbCut2MlatX7IvebAzMdYtRZKHYdfetuRVAnoK7Jpa9ysZj18Cwrt1KrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fn4/EyyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fn4/EyyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EDDC4CEF1;
	Fri, 21 Nov 2025 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731857;
	bh=qmKRMspvxxmjAZi1q6yzMrYQRluPFc3oSzIr4+L3gCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fn4/EyyUlRaQIcJfh1ifI3g5tpf0o3H+9RaakqUeBfe8QOlOcH37vdQg0GmVgtP7K
	 SgoYj5jOEK76uvLJM1Y71fXVVc2R+sJTZNnQ6j2KJJhD4HeqioptD39oCX6Oyk/9w6
	 C7vq7bNAs9ZEGpPv+ORLkL8PwWBED50m0egDULjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/185] HID: uclogic: Fix potential memory leak in error path
Date: Fri, 21 Nov 2025 14:12:12 +0100
Message-ID: <20251121130147.662512985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit a78eb69d60ce893de48dd75f725ba21309131fc2 ]

In uclogic_params_ugee_v2_init_event_hooks(), the memory allocated for
event_hook is not freed in the next error path. Fix that by freeing it.

Fixes: a251d6576d2a ("HID: uclogic: Handle wireless device reconnection")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index ef26c7defcf61..89fa2610f02ba 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1367,8 +1367,10 @@ static int uclogic_params_ugee_v2_init_event_hooks(struct hid_device *hdev,
 	event_hook->hdev = hdev;
 	event_hook->size = ARRAY_SIZE(reconnect_event);
 	event_hook->event = kmemdup(reconnect_event, event_hook->size, GFP_KERNEL);
-	if (!event_hook->event)
+	if (!event_hook->event) {
+		kfree(event_hook);
 		return -ENOMEM;
+	}
 
 	list_add_tail(&event_hook->list, &p->event_hooks->list);
 
-- 
2.51.0



