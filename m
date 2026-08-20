Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE4040F754;
	Thu, 20 Aug 2026 16:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244250; cv=none; b=FvkJULU6jYyCM2oooqvAOjhYJsMCar4KX2T6Wp3gijoc7hWJCd3Qnc8ZYsLKwsc1+M05x+yCvE4sIlAZ9S3XGr1XpmQLxq4fhfEeYZ5tTGxJq7Ut8Ju3HhHzfZdBObaQCd2BPZlGkGKuyujppvJd7yybpANYY0LaO+K4Lqqrst4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244250; c=relaxed/simple;
	bh=F2KNJcshSzufMVxUGk//n3vBbec/Ng2x1ReudE2e5aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqXDsj4H+TNh9/msvA4+XkSnhsMFxdXQy3B0QGzwxIunGMSUQq+OYmAjuz0MAx/PWEITW/e+p4YASGT5ArEuBf2b7KRrPyqBtFpKR0eLLykEJOtO/8rODa4/e+FC01sreLLjC4v0Ydag6QXyJblgpzmfGimDzk7ojmsRMwsI8TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UImpyyMA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UImpyyMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150F11F000E9;
	Thu, 20 Aug 2026 16:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244248;
	bh=vQO6QFarN4ei7mLo0FTiNfuYDIMFZVU/iz9mXTrgGc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UImpyyMALmFuq19CqM3WqUHhQbPzVWY4ppMRsh82uvfPUrk3hlEgEbFryxaUYwE4c
	 QFWaQ8FVDOSAaUsXY6mxRVxjcQJyEMhEJjyUPIUFJn7I34oEBAS9lodBGBKiwdbmSZ
	 eMcvl+qhhe7oVaZTOXskAOotrGUjdfHwIxejZ3Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/235] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 20 Aug 2026 16:55:40 +0200
Message-ID: <20260820145219.606724012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -784,6 +784,7 @@ static void tb_service_release(struct de
 	ida_simple_remove(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 struct device_type tb_service_type = {
@@ -892,7 +893,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		if (device_register(&svc->dev)) {


