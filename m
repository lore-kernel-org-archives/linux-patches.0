Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9001F3176E4;
	Wed,  8 Apr 2026 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674229; cv=none; b=XmsymOJP+RKflQuTu94fldtuCrFpdIZZTMXb0S8cCtPSRnj0PF1cK1iNg7VzdjXvn3Ao6aOQQUwn+250zyjE7rbnJJlYdMlvEaYjQIR3rZmISWTD1Nweilzx7CXWmU5EnJX5YZm5z7765vPWEzGc6pafcu3iih30CA1Hu4xJ8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674229; c=relaxed/simple;
	bh=icRDIPltj4zGc6ZG4wHJwCdlvTOm+z6B7Uk+d1rZw0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n21mszTGrK1uFYgaga3T8VijVTPUhjILwoM7RfyYDHxcqMIpaYyJdalfhYMElvWnhu+wu62H19Rc31Hml3dn2K7wbpYuTrbG6PJGOWt9vj0el2e/YjYXghkAUy2L94bxTP0e2Zm1SdFt16BJQTk1kU5+UArsXxFmxcx7wRxNkQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAvzJcwb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAvzJcwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9C3C19421;
	Wed,  8 Apr 2026 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674229;
	bh=icRDIPltj4zGc6ZG4wHJwCdlvTOm+z6B7Uk+d1rZw0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAvzJcwbwdvOHzD2dnOi5W5JlfrGtKLf5a+LXHM1L8ROm7cCaFL4PZjn1ip8LPI1X
	 jSdBO+5qbRVI30zl9RhcDsgxxLlVBmk+79hnh66lH0K0IzKCrG0dhwI/unGDNxXjId
	 3V6UCl/x1Wi+KrisSQ9VyYctBUknumGufDyggnSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 017/311] HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure
Date: Wed,  8 Apr 2026 20:00:17 +0200
Message-ID: <20260408175940.055733291@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index c3d53250a7604..65bfad405ac5b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4487,10 +4487,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		if (!ret)
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



