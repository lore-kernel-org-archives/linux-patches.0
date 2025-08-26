Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EEA1DAC95;
	Tue, 26 Aug 2025 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214321; cv=none; b=RUeQIgiAhZBFLH9yESrD4nkKWh773NIuo6PSBLGZZqfRA+AETWujPZ8XkQTxjEyNuUHECnsnYLnOp5kVU99S0utE3ZNXGu93RsKdMl/LcqyXtpHmNvnAdkUfUo2ZiBi1+dPj2HwyTAoD8hd7Krxk7/gkmC4N1seiAd7M/YJ7yEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214321; c=relaxed/simple;
	bh=SWcs0lHyY51YybWPTf1hAdQWLlv2OCTHoQep6nPo1BQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQ3PC5Jq2lEIOJaHYkY4UNgL92pG2QzsTzuAdA2ER8VSvtnaoRNh5W3e0BPoCf1Oi4+QD8MH++Xb8rBWBq0BtrJ6whf42Mp5R1EZU0iiWTcXRhcy4dYJtu/gKiQnJJi2FZdC92U+uF88ojl6N4stIKMFhXCi/N7o+LAlsI2ARUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YBSOiZMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YBSOiZMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26B6C113CF;
	Tue, 26 Aug 2025 13:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214321;
	bh=SWcs0lHyY51YybWPTf1hAdQWLlv2OCTHoQep6nPo1BQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBSOiZMo06thYBb7/c/LCic+/qAJijzPxGM3UtaoVhCAQgSr3lRFI+aYzHQmGvbNT
	 cAR7RISHFIfFfLNxdKVKRLSZZD/xFiOj5Z4IG3qjFPNhjNTBFXQYQ+/od4zCA4xpSQ
	 EEulVEXM2LuG6GWRJY2J8UnoOdigPB2MN9yo0rQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/482] mei: bus: Check for still connected devices in mei_cl_bus_dev_release()
Date: Tue, 26 Aug 2025 13:05:48 +0200
Message-ID: <20250826110933.175579424@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 35e8a426b16adbecae7a4e0e3c00fc8d0273db53 ]

mei_cl_bus_dev_release() also frees the mei-client (struct mei_cl)
belonging to the device being released.

If there are bugs like the just fixed bug in the ACE/CSI2 mei drivers,
the mei-client being freed might still be part of the mei_device's
file_list and iterating over this list after the freeing will then trigger
a use-afer-free bug.

Add a check to mei_cl_bus_dev_release() to make sure that the to-be-freed
mei-client is not on the mei_device's file_list.

Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-11-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 7b7f4190cd02..19bc1e9eeb7f 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -1113,6 +1113,8 @@ static void mei_dev_bus_put(struct mei_device *bus)
 static void mei_cl_bus_dev_release(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
+	struct mei_device *mdev = cldev->cl->dev;
+	struct mei_cl *cl;
 
 	if (!cldev)
 		return;
@@ -1120,6 +1122,10 @@ static void mei_cl_bus_dev_release(struct device *dev)
 	mei_cl_flush_queues(cldev->cl, NULL);
 	mei_me_cl_put(cldev->me_cl);
 	mei_dev_bus_put(cldev->bus);
+
+	list_for_each_entry(cl, &mdev->file_list, link)
+		WARN_ON(cl == cldev->cl);
+
 	kfree(cldev->cl);
 	kfree(cldev);
 }
-- 
2.39.5



