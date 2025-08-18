Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE73B1E51FE;
	Mon, 18 Aug 2025 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521838; cv=none; b=Z0tGyIdEne0rL52dmjdIdDQivXpuuvOkHs8lEOpU6LfXsCGo0yYa4P5s2FmutMtVMjHpYrYej2+PZap2YP3FZsUFoSijGezID1RFJ/OPwCfsm4ZH+RHypYZD5ECZdtowq0N5bkAW9QawmLwhbew9gBWMK0EU5VCCh3N26CwqjE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521838; c=relaxed/simple;
	bh=cXd8lGme1eUbCSA3binFW1ngvK9ARf4XI7O1Ulk9mVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfKjtHgzRWDbtGKj5exf/UpI14PuTY1PivZKZiJcBa2AZZIpan+tw57Y8vLKPgEKfDDVo7MKpchGGqsSJG/ATO1eIsQM4zACGqmurllMO/IljSbed+dFsqUXd3CSb+yRfSdGUBcPy0tCPoxqYo5U6h/SSkDv448NwdDHtQkAECM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTgAzYLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTgAzYLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE5BC4CEEB;
	Mon, 18 Aug 2025 12:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521838;
	bh=cXd8lGme1eUbCSA3binFW1ngvK9ARf4XI7O1Ulk9mVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTgAzYLqDOh7yAZ3tG1zIU1S8Sjod5lj73XDwbjOWD0gGi3+dfH9eqJ+3ogkEGYaZ
	 jfVRnmq+gov8qWyE//vX6o9C6/TAAbVznROqX7C72m+9uLg+Y9co+JZm6bR3DqPOM5
	 HLOsKoFKEIRXa7V6jCeKUeJOPGxAyqYUJNkV0BWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/444] mei: bus: Check for still connected devices in mei_cl_bus_dev_release()
Date: Mon, 18 Aug 2025 14:42:43 +0200
Message-ID: <20250818124454.044081027@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 5576146ab13b..04f9a4b79d85 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -1353,10 +1353,16 @@ static void mei_dev_bus_put(struct mei_device *bus)
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



