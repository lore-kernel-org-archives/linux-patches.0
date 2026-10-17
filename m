Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC55E555;
	Sat, 17 Oct 2026 17:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258507; cv=none; b=FGsKe9MQ6Z3rFjlcbP/OtpJ9E5OD5WYnw7FP4eyTWjQ/tJzDbpthz94tDa3cTN8J02owByRB+2y18Y7G7rc5mrsui0E0PnXH8aLAOkIc75IBZL0e0VtL5iD2J6NTRF7hDvsL3Kn+UM0tHl8uC/y+gGlv5dHKpY+C4IXPAELN6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258507; c=relaxed/simple;
	bh=K2hDjZuniwFNq76bpSuU81EmeM3+rxh/EDODNNQdUVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RDJw7uMZwFZ0TMjA0iyWU7qQvbmkPfLC4EvFcLOkuqp1iBUtFkA9NSw12T5Z3lzz/gJgCB4h7X4bgJHEfe91rzb1GVuBYZreiO5rxvSw6m0nP1EoBdhTHNTYe+k79P+a47zRYxcJaX7mPwJDVPMarzBhwZSrCyJZ6Di0ENt4sf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+k38A8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+k38A8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC121F000C4;
	Sat, 17 Oct 2026 17:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258506;
	bh=2vua1Fcrt+YIgRymICAHtideQ3NaVFMXGw6xQlqWHRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+k38A8ZMaZ1M4jE2mzuYbzG83vllQv2Zfaq4PsVyc3pVQj9UDAklc1Bl9ItSqNLX
	 gtEKaij+7eBhvboFOsQFykdODB4Ri+d5DMgu5Q3StfeHJ+vLZvoRD03DGBgPezwdwd
	 AE+tmNP6mw4jEpasHeLTkSTKTkCvZsPZqhwt6p7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0907/1674] HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure
Date: Sat, 17 Oct 2026 17:52:59 +0200
Message-ID: <20261017160454.413213389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit f7a4c78bfeb320299c1b641500fe7761eadbd101 ]

Presently, if the force feedback initialisation fails when probing the
Logitech G920 Driving Force Racing Wheel for Xbox One, an error number
will be returned and propagated before the userspace infrastructure
(sysfs and /dev/input) has been torn down.  If userspace ignores the
errors and continues to use its references to these dangling entities, a
UAF will promptly follow.

We have 2 options; continue to return the error, but ensure that all of
the infrastructure is torn down accordingly or continue to treat this
condition as a warning by emitting the message but returning success.
It is thought that the original author's intention was to emit the
warning but keep the device functional, less the force feedback feature,
so let's go with that.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index d223d1fa33f32..2d902a328189e 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4539,10 +4539,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
 		ret = hidpp_ff_init(hidpp, &data);
-		if (ret)
+		if (ret) {
 			hid_warn(hidpp->hid_dev,
 		     "Unable to initialize force feedback support, errno %d\n",
 				 ret);
+			ret = 0;
+		}
 	}
 
 	/*
-- 
2.53.0



