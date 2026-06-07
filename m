Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C50326951;
	Sun,  7 Jun 2026 10:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828105; cv=none; b=D0Scd1XL76wtLFN9n2BAn2KZW/d06xEX1X89qC82/yeXlxPDF94C6dk8YyrvVv9Jzyi8SzRfscMLnRL50lhJvRGjvPdM1o7+fNzxYOIL5iGANkNKQDVbvE5uS3py8AbvfqYQawuHkmX+m08VGY6+PdqDPMc29YY4Z3hFQx+Tk7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828105; c=relaxed/simple;
	bh=huti1QZD89hj1hQa7IxrLPqMaQ/CJAhiCklRDRaThZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iECP91k63Ubi23C4QvqctEMr5QJkIcrJGJ5wTQPAB4D5+DUnVqiRZVk8xhxEoAOd3kB1y2uWfbv9dIPrpBrYJvscyWMpVg7TcHNMW6pF5BHF37A2GtzJU2DFWSOCCY5DfJD8HtdRAbE/+Ya4hYyeUIaCAnBwbq3HBM8xHWZiHOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRHYKNMn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRHYKNMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683501F00893;
	Sun,  7 Jun 2026 10:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828102;
	bh=kUSn16U5wZARb3aBQILXnkIFOKKoVzgvz1UxVcL5ZBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRHYKNMnZLKUZ4XU2d0gGc9eQDlWmKo4knP8JMbIi7L17vpBGTqZkH88k8UfRRUpO
	 JHxs7OFktNmYyAYE4GJlnB87NiVZHT9uJT5unHZ0FyijCmc6W1lvqqisLL0gjCOwle
	 335QhVfUrj9BZFOLn6Hrp3KyXqtbCSAbPxt9re0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/307] media: rc: ttusbir: fix inverted error logic
Date: Sun,  7 Jun 2026 11:58:28 +0200
Message-ID: <20260607095731.851973823@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 646ebdd3105809d84ed04aa9e92e47e89cc44502 ]

We have to report ENOMEM if no buffer is allocated.
Typo dropped a "!". Restore it.

Fixes: 50acaad3d202 ("media: rc: ttusbir: respect DMA coherency rules")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ttusbir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index a670d4b008cb0d..3452b5aefd2848 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -191,7 +191,7 @@ static int ttusbir_probe(struct usb_interface *intf,
 	tt = kzalloc(sizeof(*tt), GFP_KERNEL);
 	buffer = kzalloc(5, GFP_KERNEL);
 	rc = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!tt || !rc || buffer) {
+	if (!tt || !rc || !buffer) {
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



