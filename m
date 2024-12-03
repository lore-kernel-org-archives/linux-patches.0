Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD9C1F8AC1;
	Tue,  3 Dec 2024 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239867; cv=none; b=bnxVJ4XyMd2lDKovJEtYzzZmgY54U00GiSipxh5yuxdtrx8oEnjN29vSeZ8OGfHI2c4LPOuJSWwyjiwyQYIY7cOUKqtTn8XBDe7uOG7kSErxJMiL+9vHNQfsk4aWSb4LadoemQ0RmD00RwykAFk23SKP21l7xhL63xkzR5jb5f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239867; c=relaxed/simple;
	bh=1/PF+ZX4fcflZlugDnz3ATpYV6rXdaPX/Rir10aa8dQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ugx2eGSfjgy74d/UHHZsDW1f5uIGpIgDa1XlQ6oXtjPiWrjylihn+J8z84vZn1Y6DeU/XTRuG6een0QXqgt69mxXG10cOX3dC+TTeZCx4Bjopdzm2zdtFBkc9UIiJYQd4UzQ9kOqFS3PGlR+VJl2w81tpwfDGsvf39n3YZpeFfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WI5er7a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WI5er7a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE587C4CEE4;
	Tue,  3 Dec 2024 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239867;
	bh=1/PF+ZX4fcflZlugDnz3ATpYV6rXdaPX/Rir10aa8dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WI5er7a4hCRp4bBs8OJ4ocQUfC79UglF/EK5J8m7I51WTc8N/tseZAJ+WDt3b6XBV
	 N6VxddjPi3KwejqNzkymukOvoRblYVe4rhB33vsUtOGPho4sr5L9t3qYvJmkrHthYT
	 7ZX+5r2tymNg0siXQpsmUlAjBgyPlpoXThsriNEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	James Ogletree <jogletre@opensource.cirrus.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.11 762/817] Input: cs40l50 - fix wrong usage of INIT_WORK()
Date: Tue,  3 Dec 2024 15:45:34 +0100
Message-ID: <20241203144025.739181389@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit 5c822c0ce5cc83ed4cd8394f3dc46dae8d9a681d upstream.

In cs40l50_add(), the work_data is a local variable and the work_data.work
should initialize with INIT_WORK_ONSTACK() instead of INIT_WORK().
Small error in cs40l50_erase() also fixed in this commit.

Fixes: c38fe1bb5d21 ("Input: cs40l50 - Add support for the CS40L50 haptic driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: James Ogletree <jogletre@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20241106013549.78142-1-yuancan@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/cs40l50-vibra.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/cs40l50-vibra.c b/drivers/input/misc/cs40l50-vibra.c
index 03bdb7c26ec0..dce3b0ec8cf3 100644
--- a/drivers/input/misc/cs40l50-vibra.c
+++ b/drivers/input/misc/cs40l50-vibra.c
@@ -334,11 +334,12 @@ static int cs40l50_add(struct input_dev *dev, struct ff_effect *effect,
 	work_data.custom_len = effect->u.periodic.custom_len;
 	work_data.vib = vib;
 	work_data.effect = effect;
-	INIT_WORK(&work_data.work, cs40l50_add_worker);
+	INIT_WORK_ONSTACK(&work_data.work, cs40l50_add_worker);
 
 	/* Push to the workqueue to serialize with playbacks */
 	queue_work(vib->vib_wq, &work_data.work);
 	flush_work(&work_data.work);
+	destroy_work_on_stack(&work_data.work);
 
 	kfree(work_data.custom_data);
 
@@ -467,11 +468,12 @@ static int cs40l50_erase(struct input_dev *dev, int effect_id)
 	work_data.vib = vib;
 	work_data.effect = &dev->ff->effects[effect_id];
 
-	INIT_WORK(&work_data.work, cs40l50_erase_worker);
+	INIT_WORK_ONSTACK(&work_data.work, cs40l50_erase_worker);
 
 	/* Push to workqueue to serialize with playbacks */
 	queue_work(vib->vib_wq, &work_data.work);
 	flush_work(&work_data.work);
+	destroy_work_on_stack(&work_data.work);
 
 	return work_data.error;
 }
-- 
2.47.1



