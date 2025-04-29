Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38902AE96;
	Tue, 29 Apr 2025 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949330; cv=none; b=BZnA6QGkvXoRgt1sh2exSF5o6SGT7dBB2pLo+Q3Acr8LeUblxW5vFlurFqVk63l67Bm2lUd6o6Kv9RZpQWbyWraa7kLgg2ZT8c9KaIpMTP9756ImxMdiLZ1oxGyw4XmkiOYVIEID9Yz9Hr6SDZwIk6yHit8ASMZlIXBlNVSMQEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949330; c=relaxed/simple;
	bh=J1kmEAyVryKTkyv4XIya37qGLs/PvqVEhLRx7dWhskk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXuaUT5JfCEVfGCX4cuUN3/p1+6Ec8v1OuOROto0R/opBh75w/Ph6a3SVf/pEOdvHN4h9BYE2fR0AijqW1U3oMTtEtJtOZ9jEJJZ5h86+s5UCJK/ch/RzJCXqbXGWXJHHG/X6fh2vEexnVKKqY5lLR/2py5FTW+vGEWfzO4SVj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCSqjkHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCSqjkHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774EFC4CEE3;
	Tue, 29 Apr 2025 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949329;
	bh=J1kmEAyVryKTkyv4XIya37qGLs/PvqVEhLRx7dWhskk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCSqjkHpLIdiJIH9sTXV3JRywrctmUsSVWB5lvq7UPJxXTmvrLl7ysVvRG53vm8D/
	 a4wJTPRPQtOE0XKD4/F8J50ZSKUpFF0Dxv/NqCrMnFQWuRu1yUo1Vllt6rFv4xZG8K
	 /t6lv4TrRjCcWrU8vjrW8Uwe1bRLLbSyNKj3izVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/373] media: streamzap: remove unnecessary ir_raw_event_reset and handle
Date: Tue, 29 Apr 2025 18:42:12 +0200
Message-ID: <20250429161133.613655239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 4bed9306050497f49cbe77b842f0d812f4f27593 ]

There is no reason to have a reset after an IR timeout.
Calling ir_raw_event_handle() twice for the same interrupt has no
affect.

Fixes: 56b0ec30c4bc ("[media] rc/streamzap: fix reporting response times")
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f656cfbc7a29 ("media: streamzap: fix race between device disconnection and urb callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 3b25b1780f249..938fbc569f505 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -215,8 +215,6 @@ static void sz_process_ir_data(struct streamzap_ir *sz, int len)
 				sz->idle = true;
 				if (sz->timeout_enabled)
 					sz_push(sz, rawir);
-				ir_raw_event_handle(sz->rdev);
-				ir_raw_event_reset(sz->rdev);
 			} else {
 				sz_push_full_space(sz, sz->buf_in[i]);
 			}
-- 
2.39.5



