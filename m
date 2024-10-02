Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3CC1D0173;
	Wed,  2 Oct 2024 13:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876366; cv=none; b=Y31fX4YIts0lNf5KK5xifDooI7Qj5F9qg1DNAGLsuCenwAYES3V7wIa+iJIXD+vQf2vS2HHnJQzJfXsENv98WLDlgoKQchusNjssCPaQ4gQUlcj3zb/iN5v+X+y2EatmYgyjjYY5oGQF3W0F3/0x2T5YE1BHJNoODMr/WcjRqI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876366; c=relaxed/simple;
	bh=tn47egmipOJOLAwOUUVRFAhyjxb6LpHuUxEPY4g3cfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG3pKEn3BBCMPDHNbw0DK2x3ZgceAnCBeKmcDWfSYqp1xTqlEHdCtaJZ84NofMxU0s3nhh8gfwWDbH56Kl24t1Kvf/Pl6h0ju4m7DFIAwosVkVPaC/lMsKzpIzOlfSAkcWoQYnXHiWTEFdi8iX8Y09ygZA25gbgmzcs7kqspyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiRTioVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiRTioVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705B2C4CEC5;
	Wed,  2 Oct 2024 13:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876365;
	bh=tn47egmipOJOLAwOUUVRFAhyjxb6LpHuUxEPY4g3cfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiRTioVqJMIE8htXx6/YD7ObzKta7lJAF9OU1gJwLYZ9+UUsXh4evcBy7Wj/AcqrE
	 7WZ7tcRcunkhJrUMb8eJwuFLRFiuBEbxtpJImcfX4EL7tg32D5nJmoqF1I8d38quyO
	 PR0BDlkoDW005EiEmxrzZGd+wmvuvBzpI2rXDIPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 418/695] Input: ims-pcu - fix calling interruptible mutex
Date: Wed,  2 Oct 2024 14:56:56 +0200
Message-ID: <20241002125839.141809293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 82abef590eb31d373e632743262ee7c42f49c289 ]

Fix calling scoped_cond_guard() with mutex instead of mutex_intr.

scoped_cond_guard(mutex, ...) will call mutex_lock() instead of
mutex_lock_interruptible().

Fixes: 703f12672e1f ("Input: ims-pcu - switch to using cleanup functions")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240910-input-misc-ims-pcu-fix-mutex-intr-v1-1-bdd983685c43@baylibre.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/ims-pcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index c086dadb45e3a..058f3470b7ae2 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1067,7 +1067,7 @@ static ssize_t ims_pcu_attribute_store(struct device *dev,
 	if (data_len > attr->field_length)
 		return -EINVAL;
 
-	scoped_cond_guard(mutex, return -EINTR, &pcu->cmd_mutex) {
+	scoped_cond_guard(mutex_intr, return -EINTR, &pcu->cmd_mutex) {
 		memset(field, 0, attr->field_length);
 		memcpy(field, buf, data_len);
 
-- 
2.43.0



