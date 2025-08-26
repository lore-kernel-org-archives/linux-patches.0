Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD558770FE;
	Tue, 26 Aug 2025 12:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212832; cv=none; b=my9oe2+bYULohmlxebXJNV6NSAlW5gMv63WWmKjnzQbY+m241lNJDtfUqpxT8WuMNRrUuKGFCRgYdA2dpNwj6bN+vN6GdGbeD3+vaEIohxF/Q3U3YTVKSDa/50D357Q34+PtvH9AB7Y8zsc/lqex7nQ0MB5UWilN9VR1PNWirZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212832; c=relaxed/simple;
	bh=vSQnlyJ/fH3c/YAWOagU3YUr+X2uFhu9pK5D4XQd67w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlbTWu+yX1zsavDniLmxa4ly9ElOcfFhErGKi34I0ynWKgCW2q0IKMPx4tK15A/xEDaPzZ0xOocRZt4EzxD3EI876jtfB4KWVk6qonbmICMEf7Ez3gh842USQcZH5iND8tHnu0/TV+UaSKaPjJFfrATrE/7YvFZCouoeWOCVpWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAIcaRlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAIcaRlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF57CC4CEF1;
	Tue, 26 Aug 2025 12:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212832;
	bh=vSQnlyJ/fH3c/YAWOagU3YUr+X2uFhu9pK5D4XQd67w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAIcaRlLFoFs56uuUBe6grATi9o9ZKY1Y+BurJw72IuMqQ2H87SWYHVpGRpoOqosJ
	 fGadS6kxa/mQgV/c1F5hTKXTWNeTY7sX8NJm+nq4lx15baRWzfiFfmiEbf/J/LVSfu
	 49L6omUWIjEc4bppv3fjf1EbnMpN3x19NdqnZObE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/587] mei: bus: Check for still connected devices in mei_cl_bus_dev_release()
Date: Tue, 26 Aug 2025 13:04:27 +0200
Message-ID: <20250826110955.967047072@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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
index 2e65ce6bdec7..b94cf7393fad 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -1269,10 +1269,16 @@ static void mei_dev_bus_put(struct mei_device *bus)
 static void mei_cl_bus_dev_release(struct device *dev)
 {
 	struct mei_cl_device *cldev = to_mei_cl_device(dev);
+	struct mei_device *mdev = cldev->cl->dev;
+	struct mei_cl *cl;
 
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



