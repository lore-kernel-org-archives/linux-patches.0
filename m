Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB5D226D0F;
	Mon, 18 Aug 2025 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523409; cv=none; b=IzQmqRhKYlCV0AvtXEVXD+uJ/m8aXfd09f8I0hRHzDUcU5j9xjLcfWAoK9jtUYZcDhsqsR5TN9+6yq11Ur6OP/YjfIHbI8p2sgF97mk1e46EUQ3uLLEA0mqGhNBG528amw7BFVYqKpdEnKSEoyCA5Of69spN8T2UQ5h6SeAt6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523409; c=relaxed/simple;
	bh=zAaeIzqESXGl0H/7BvN7T8FpyXJ29iTWup050jOypVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiPb5vBesLBWjX/26DqsZWVciDYb4HEiqBLqMXNDT36VzdiSF35Km0mgC+ELXDaWTEkl7BCJsyT0NdJbAiElei88YhEZbmMFURI2DO7I8EmZpXpLaUWFrNBDhMnR+SprCEOUI5AYWG4yoBw9r2LhG35bCLlo6XZNsGnziKWxVs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcAVdmnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcAVdmnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2A9C4CEEB;
	Mon, 18 Aug 2025 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523409;
	bh=zAaeIzqESXGl0H/7BvN7T8FpyXJ29iTWup050jOypVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcAVdmnUWCsUX90AzcQuYTnO/nuvlxZFOO3NEHRPgoA+q9jmiZaOaR3V4gN6UGEzz
	 ixnfS0RpGSj9xJOKz7/1I2Iqri8pVfYm6a0wDBZLNy48percfeIey/PfkCVbMVTGbS
	 /8O4zLX3kpsvM+uEfzqeBf35i4HiChY0dQSCioIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 163/515] mei: bus: Check for still connected devices in mei_cl_bus_dev_release()
Date: Mon, 18 Aug 2025 14:42:29 +0200
Message-ID: <20250818124504.655461566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 67176caf5416..1958c043ac14 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -1301,10 +1301,16 @@ static void mei_dev_bus_put(struct mei_device *bus)
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



