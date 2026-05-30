Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90602E7390;
	Sat, 30 May 2026 18:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165273; cv=none; b=G4yv9y+BMUF4Qz5RFHEyCBVAKWa98yaWB2sSLTMzGdjIUq6AvrQJtK6ZqCQWnZdfxH1gioHy/0Gbr06tLp6jHYXrBXGEcZW9PQYDMV38TJQmLULkB0P0F3Yn4skKmnjqBp4ogScuSupJr9g28M5vDHmj4Y43JEL709cD3HyMUHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165273; c=relaxed/simple;
	bh=cSXtVR7HFPdXnoTBQy15TE3iSdXQFvDqKTHGyQVVm3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smRSOJ4guPiMemkMep1MI3vy8qbiGyBOCBe8oo1gR8C3WPIXksb5JpEVbJ2LQVApiOYolMV68ZODGs6+Y2klJv/au6l2jTrEyEpC8Okik79OsAEf4JuJr5Fq9DVNjWvfQoYaAROK0RJnoBaKCebyXB9n1vWcV/VV7mOI5LkcCLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/Nm9piQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/Nm9piQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014D11F00893;
	Sat, 30 May 2026 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165272;
	bh=1YBICrJ6QNwkXBBc7Ht3O9sMHLoorgAIKFgsCHztI4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/Nm9piQmHlNQ9Tz94221tpHoWbipK1txPm8Jg2QyJChRIhTstFYLsTR8ix14Igoa
	 kj+qr21ggIGgsO6UHcps8tOfwoHK5HPc9VIwA9U/b9DjsoCMokkNf++DYlv7BqAfYp
	 4qWSo8Dibgv4g2fhNJpRhzkRjSxiNYEPuDTx/I4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/589] HID: roccat: fix use-after-free in roccat_report_event
Date: Sat, 30 May 2026 17:58:11 +0200
Message-ID: <20260530160224.848951236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoît Sevens <bsevens@google.com>

[ Upstream commit d802d848308b35220f21a8025352f0c0aba15c12 ]

roccat_report_event() iterates over the device->readers list without
holding the readers_lock. This allows a concurrent roccat_release() to
remove and free a reader while it's still being accessed, leading to a
use-after-free.

Protect the readers list traversal with the readers_lock mutex.

Signed-off-by: Benoît Sevens <bsevens@google.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 6da80e442fdd1..420e4335c3e83 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -257,6 +257,7 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->readers_lock);
 	mutex_lock(&device->cbuf_lock);
 
 	report = &device->cbuf[device->cbuf_end];
@@ -279,6 +280,7 @@ int roccat_report_event(int minor, u8 const *data)
 	}
 
 	mutex_unlock(&device->cbuf_lock);
+	mutex_unlock(&device->readers_lock);
 
 	wake_up_interruptible(&device->wait);
 	return 0;
-- 
2.53.0



