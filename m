Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3382EAB97;
	Tue, 12 Aug 2025 18:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023518; cv=none; b=OGHZ+hM/FWU8DNvzWKizz5qQMHHYqL2arNN0awVMlDjyA5PjCGZpnIP7Kn/SHJrKgHhh83KO+IlAE3w/ZsYHHWXJDZLjpArZnAW1M52h/6Km+oWZUBVljF7PxwQs+ixXSNJtQTQce4ISApINwfVwFIuBnY208XN8w/bNqEwXe2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023518; c=relaxed/simple;
	bh=gbyHqXYMQXB0F3RmwIKV2vOeUshCo505OLySDWYp24o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2HpT2fYU/RaUka93ufVf+g781kDw72Uy4NBLiC8M93rTPizzTLK6NK1lIBqLZ9j//M/0G5xXRmDPCIchFOkfk76RoJtdup2wDytoRWUFmS8XqmuOwTpaGyzZeNVEiwwdbPJj/vKxbUnWYzVF9U55UPRiw0V8Wt23CG0oHYz5NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VskZpEw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VskZpEw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0CDC4CEF0;
	Tue, 12 Aug 2025 18:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023518;
	bh=gbyHqXYMQXB0F3RmwIKV2vOeUshCo505OLySDWYp24o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VskZpEw9htYfE+NFvK2cqQkSj5VlMSp0J0GujeHpD5V4XzEP9CAdzrVkTjA1nCyk1
	 V8Ef1bIAJ5agK6HfXCllZlSxQhoPM1Jo5NHeIpOBPJig3XADiOOr7DToqaM7C8GeKG
	 B4l6La38ASPm3tm6GwiEhYE/AvHNhd51+Awe3IUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 096/627] staging: gpib: Fix error handling paths in cb_gpib_probe()
Date: Tue, 12 Aug 2025 19:26:31 +0200
Message-ID: <20250812173422.971267975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 1b0ee85ee7967a4d7a68080c3f6a66af69e4e0b4 ]

If cb_gpib_config() fails, 'info' needs to be freed, as already done in the
remove function.

While at it, remove a pointless comment related to gpib_attach().

Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/bf89d6f2f8b8c680720d02061fc4ebdd805deca8.1751709098.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/cb7210/cb7210.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gpib/cb7210/cb7210.c b/drivers/staging/gpib/cb7210/cb7210.c
index 298ed306189d..3e2397898a9b 100644
--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1184,8 +1184,7 @@ struct local_info {
 static int cb_gpib_probe(struct pcmcia_device *link)
 {
 	struct local_info *info;
-
-//	int ret, i;
+	int ret;
 
 	/* Allocate space for private device-specific data */
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -1211,8 +1210,16 @@ static int cb_gpib_probe(struct pcmcia_device *link)
 
 	/* Register with Card Services */
 	curr_dev = link;
-	return cb_gpib_config(link);
-} /* gpib_attach */
+	ret = cb_gpib_config(link);
+	if (ret)
+		goto free_info;
+
+	return 0;
+
+free_info:
+	kfree(info);
+	return ret;
+}
 
 /*
  *   This deletes a driver "instance".  The device is de-registered
-- 
2.39.5



