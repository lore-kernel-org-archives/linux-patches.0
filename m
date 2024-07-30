Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271C58BE8;
	Tue, 30 Jul 2024 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357165; cv=none; b=mUgtYZR/YkKOceNd3U39F01sB2f3GOsZM9kDK8E7Ygou60d/PF61mV8NcktRd40C4Z19BWcSUZHxmYsEK1IEchycT3YX3zPhnvsYcw5Qf7F2Uxfo+M/n3+eXp4yKqQEo0L3nmBfYhxmSNef67i8b4+0skTo/cKnDKa3b+qypA7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357165; c=relaxed/simple;
	bh=UTxYB8KIecEcOueIKsAF9qrYyWOamen8DAUxKaMi+RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cTcauhd+mktxJPpWCySIldIK42l5Uf/kGFZkoHvQPGvlhHMMmw+5saepXlVxuL2xXsOjQanmR8jpfeo49Oxg+WLSXUrgLzSm48PyGBCNal/qB8e2x3gaE6C09mSuUYYleib7WXSv8R/GjJnbpfRlla6nbFdGh9oAuZbYW+WYX/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HerHzkTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HerHzkTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D69C32782;
	Tue, 30 Jul 2024 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357165;
	bh=UTxYB8KIecEcOueIKsAF9qrYyWOamen8DAUxKaMi+RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HerHzkTd8BhnKDPpKt8o0LJu5K99nXeTlZRiZH1t6FleEoOGfjaHAZ2p6QUav4ryR
	 uO2pIDuH/423geFuP4bxu1K9z5GCKUiIXMpL/KJwpdIuLYI/Dc/FtiGXkoRFsYS9vI
	 lOEYZvHtDjZHfsNWhyXkAlxLULFXX+PMhoGaQU/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/440] s390/dasd: fix error checks in dasd_copy_pair_store()
Date: Tue, 30 Jul 2024 17:48:18 +0200
Message-ID: <20240730151626.191087202@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit 8e64d2356cbc800b4cd0e3e614797f76bcf0cdb8 ]

dasd_add_busid() can return an error via ERR_PTR() if an allocation
fails. However, two callsites in dasd_copy_pair_store() do not check
the result, potentially resulting in a NULL pointer dereference. Fix
this by checking the result with IS_ERR() and returning the error up
the stack.

Fixes: a91ff09d39f9b ("s390/dasd: add copy pair setup")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20240715112434.2111291-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_devmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index b2a4c34330573..1129f6ae98b57 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -2135,13 +2135,19 @@ static ssize_t dasd_copy_pair_store(struct device *dev,
 
 	/* allocate primary devmap if needed */
 	prim_devmap = dasd_find_busid(prim_busid);
-	if (IS_ERR(prim_devmap))
+	if (IS_ERR(prim_devmap)) {
 		prim_devmap = dasd_add_busid(prim_busid, DASD_FEATURE_DEFAULT);
+		if (IS_ERR(prim_devmap))
+			return PTR_ERR(prim_devmap);
+	}
 
 	/* allocate secondary devmap if needed */
 	sec_devmap = dasd_find_busid(sec_busid);
-	if (IS_ERR(sec_devmap))
+	if (IS_ERR(sec_devmap)) {
 		sec_devmap = dasd_add_busid(sec_busid, DASD_FEATURE_DEFAULT);
+		if (IS_ERR(sec_devmap))
+			return PTR_ERR(sec_devmap);
+	}
 
 	/* setting copy relation is only allowed for offline secondary */
 	if (sec_devmap->device)
-- 
2.43.0



