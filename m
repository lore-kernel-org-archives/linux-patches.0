Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018104;
	b=g98xK2XmOJ8G7UKwFSSbkpZmmAMIngML6fw9Ozuqoa/TplRaxdbFCiL+oFJrxx4lLhz8
	 FYsts7PdO++cauoP6YnpDIqWlWNKzg6oa03r+5Lo0zCvCClS4xg+oIPS6Hn2Zpw25XZgY
	 A0Yu9wG9zdRdBDu1t70Won3+aLJM7NMTiuWfBe8RtZFJfwHXwJO2AAKgBgidjgMkBqgpK
	 9x4jBc3HmgNtuXpPy8eI1FuFJTOjeNUbrB1ULXXZTFs7a/Yovq5IS+l+uY1Z9wDt4wXW7
	 dAsUh9JfnAZ1h/VeIXN5/L0v3aLQUGtUEHFKJXSRohLVy8Dujs9M4hOsnCr3K6krf0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8btEFjSPs5Hmb7KErxB8Eog3AtjmnZaBtmavonSJr7s=;
	b=2LJ840FFfH3HscLu9RfDYJVtN9798ZvBZo591XDOIr6PsDUnJVDmvgsefLMTw/j2mpTY
	 eX81OvcVwQQrCTiOt6YWXkDhprU3X0420PRW3DS6krNYLXOt49KrK1KrkiwUBXWFC/NvJ
	 9DuTHEGgQSfYW9P09VnaRfCjt1U7kchYc7vi1I8n+relduRm9czVp525MetAla6WUyPAx
	 J8P0lNZ1LGKj2VG3O+1S2tz9p/eBQ6XPEt9D6bG6BE1VAPWUUxWAJFb8ut0GDFjmKdDc0
	 xHidugi+Yt1I7WEdb213FK7rLIS9oP37FikL0VnutM0L+BVbgVhWIMtQfFtIQhpjgqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIdloTo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CDE60A2601;
	Wed, 18 Nov 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VIdloTo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBAB1F000C4;
	Wed, 18 Nov 2026 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018103;
	bh=8btEFjSPs5Hmb7KErxB8Eog3AtjmnZaBtmavonSJr7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VIdloTo2V+DcWwM2rBBZlvDHEwPSbZpeFblHDJSajCYKZZIu7mZTOrWYgh5NY3/uT
	 IJz60knTWFmsQrbMzvGaqveTX27r5y5y6FFzCfzw6ElA1IwRuAuw3+E1oSwdnAz9u2
	 vGALMzWeFEZo1bhzChLF0q8dEZfO4RwewNQmk6d8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodolfo Giometti <giometti@enneenne.com>,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1122/2651] pps: generators: wake up PPS_GEN_FETCHEVENT readers on unregister
Date: Wed, 18 Nov 2026 15:39:22 +0100
Message-ID: <20261118150328.402056134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 5b864f8db0bd33216895f3fe0bb1ec245c596c8e ]

A reader sleeping in PPS_GEN_FETCHEVENT waits for the next event, but
no event comes after pps_gen_unregister_source(), so the reader sleeps
until it gets a signal. A PPS_GEN_FETCHEVENT issued after the
unregister sleeps the same way.

Wake up the readers on unregister, and make PPS_GEN_FETCHEVENT fail
with -ENODEV once the generator is gone, like the other ioctls. The
wait checks info without info_lock, so clear it with WRITE_ONCE().

Fixes: 86b525bed275 ("drivers pps: add PPS generators support")
Suggested-by: Rodolfo Giometti <giometti@enneenne.com>
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://patch.msgid.link/20260929124937.51114-5-danishkhateeb03@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/generators/pps_gen.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/generators/pps_gen.c b/drivers/pps/generators/pps_gen.c
index 452cc12a96f27..474e17c36458d 100644
--- a/drivers/pps/generators/pps_gen.c
+++ b/drivers/pps/generators/pps_gen.c
@@ -103,11 +103,14 @@ static long pps_gen_cdev_ioctl(struct file *file,
 		dev_dbg(&pps_gen->dev, "PPS_GEN_FETCHEVENT\n");
 
 		ret = wait_event_interruptible(pps_gen->queue,
-				ev != pps_gen->last_ev);
+				ev != pps_gen->last_ev ||
+				!READ_ONCE(pps_gen->info));
 		if (ret == -ERESTARTSYS) {
 			dev_dbg(&pps_gen->dev, "pending signal caught\n");
 			return -EINTR;
 		}
+		if (!READ_ONCE(pps_gen->info))
+			return -ENODEV;
 
 		spin_lock_irq(&pps_gen->lock);
 		info.sequence = pps_gen->sequence;
@@ -238,9 +241,12 @@ static void pps_gen_unregister_cdev(struct pps_gen_device *pps_gen)
 			pps_gen->info->enable(pps_gen, false);
 			pps_gen->enabled = false;
 		}
-		pps_gen->info = NULL;
+		WRITE_ONCE(pps_gen->info, NULL);
 	}
 
+	/* Wake up the readers in PPS_GEN_FETCHEVENT, they fail now as well */
+	wake_up_interruptible_all(&pps_gen->queue);
+
 	put_device(&pps_gen->dev);
 }
 
-- 
2.53.0



