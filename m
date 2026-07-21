Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D4366816;
	Tue, 21 Jul 2026 20:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667329; cv=none; b=SKD4MXB+rnYARYjNmkGlrtMUl0ykouj0I9Iu2NQPXnDXoaqkUdjmczFN/ksOV3w6YfKhj33lFX7t9vuWn1ryxfjK94K5xPUWsWKwE3QnS8beRXGOB2aXBpvDSRapTFuZSSvA2V/bqx6y5FA3d6jpZ0DbUCzRFHruslacPee1g6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667329; c=relaxed/simple;
	bh=KgwD8dvfIODANlKQXO2LKuiZr2QywM6nOTpE+BwmRww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDU06mPmvfG3JQYNYIgzQAAZQa0rMVpnreHCRVc8Kp96lyUJQvFkw2ukpIvzv3Fm0EjWaVu3GH32SHf+dNsbxzA8vVcjNeUIMlI/VEDSppETPABC73qV+zWuWV8AN3PYYPImyEpjoZak/40mdj1sD6v9r403MTw47bLG4ZaPQcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQQLCEa+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQQLCEa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACBB1F00A3A;
	Tue, 21 Jul 2026 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667328;
	bh=FHcA8D8bJAG3PWhUOeV6IqY2ZudCQU8WZcc5kPfMkzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQQLCEa+LbTRfIW634tEmWXJEDNIcb9QsQ1B6UOau8bJTWncw0ehMtIluFPqSvrbJ
	 UPQQ1ofnLE1A43NhdqWhQA67uxuIAety2RbOiz9emyPCrmB27B6lbMTJTMqBY3pCiZ
	 uGy5xa4uPTgEWUR8tPt7sbbLE/A3mHzcGroBg2Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 1013/1266] mtd: maps: vmu-flash: fix NULL pointer dereference in initialization
Date: Tue, 21 Jul 2026 17:24:10 +0200
Message-ID: <20260721152504.495565102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

commit 357e3b8e3a8769ba36eb8ec5e053e4825f1a9329 upstream.

The mtd_info contains a struct device, which must be linked to its
parent. Without this, the initialization of the MTD fails with a NULL
pointer dereference.

Fixes: 47a72688fae7 ("mtd: flash mapping support for Dreamcast VMU.")
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/maps/vmu-flash.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/maps/vmu-flash.c
+++ b/drivers/mtd/maps/vmu-flash.c
@@ -547,6 +547,7 @@ static void vmu_queryblocks(struct maple
 	mpart->partition = card->partition;
 	mtd_cur->priv = mpart;
 	mtd_cur->owner = THIS_MODULE;
+	mtd_cur->dev.parent = &mdev->dev;
 
 	pcache = kzalloc(sizeof(struct vmu_cache), GFP_KERNEL);
 	if (!pcache)


