Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1809183CA3;
	Sun,  1 Sep 2024 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208168; cv=none; b=rs/5JLy8HN7huhkRO9AAJCDirUHzFjlVPgvpcRYsXYOdIeUC5Pqf8yCwuv7Krpw0un7EpPX3glBXZqsZxodburn1ECWPDMh2YNqV6qoSKsD2vFRsFJSZdDk6byO9CzZFd8j5kozQOfKf1KlufhDl7gwuhMCMEl8ksY/0Xy7f+sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208168; c=relaxed/simple;
	bh=9u76tWUmoU1ef9JuhG5TjcgRbW0/wwTIx+nFmNqQcWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9dGVq/e0TdqGuzF/SX1EY7MeQfSViz2oZKGSKrKlRQ9dxTGSyZTeKIJyYOSVSNAQ7E6EzSHsZZzGfCUZ+c18J6S50vPOQR0RG9lZo6x9JiV2TXHYK3/VJ6OZa29DPKoUZDlqTsq7H33gNVDKv/th9hQ9LJFlYFKVz1yD1jrQ/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMUQdVcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMUQdVcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61893C4CEC3;
	Sun,  1 Sep 2024 16:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208167;
	bh=9u76tWUmoU1ef9JuhG5TjcgRbW0/wwTIx+nFmNqQcWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMUQdVcLDCDBRuC86bD9bKmUs0JKyF0OHD8+EeZhyrbJBtwzC7n0YG11bd9S+bA9Z
	 o3MGW6XmFUB0lKajhBCe9qakdw+OgGvH4pAeX1PvIUl6dZbogAd/zhxjUtuR97PYgo
	 pqjFIgyaJJo9UZoHoF0NAuKbUgMZbXNuH8iDsKhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Gordon <m.gordon.zelenoborsky@gmail.com>,
	Ben Hutchings <benh@debian.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 92/93] scsi: aacraid: Fix double-free on probe failure
Date: Sun,  1 Sep 2024 18:17:19 +0200
Message-ID: <20240901160811.195776580@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Ben Hutchings <benh@debian.org>

[ Upstream commit 919ddf8336f0b84c0453bac583808c9f165a85c2 ]

aac_probe_one() calls hardware-specific init functions through the
aac_driver_ident::init pointer, all of which eventually call down to
aac_init_adapter().

If aac_init_adapter() fails after allocating memory for aac_dev::queues,
it frees the memory but does not clear that member.

After the hardware-specific init function returns an error,
aac_probe_one() goes down an error path that frees the memory pointed to
by aac_dev::queues, resulting.in a double-free.

Reported-by: Michael Gordon <m.gordon.zelenoborsky@gmail.com>
Link: https://bugs.debian.org/1075855
Fixes: 8e0c5ebde82b ("[SCSI] aacraid: Newer adapter communication iterface support")
Signed-off-by: Ben Hutchings <benh@debian.org>
Link: https://lore.kernel.org/r/ZsZvfqlQMveoL5KQ@decadent.org.uk
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/comminit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index bd99c5492b7d4..0f64b02443037 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -642,6 +642,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 
 	if (aac_comm_init(dev)<0){
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 	/*
@@ -649,6 +650,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	 */
 	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
+		dev->queues = NULL;
 		return NULL;
 	}
 		
-- 
2.43.0



