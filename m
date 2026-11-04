Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829198;
	b=KFGkbBUdh/TJpq4gMOLd1BQ/cU4YRW1Z5Q1qgPVMZqMzj8oar5HiScyIo+CuImOruJk7
	 k0tpcnfeBpuTYFNdCkm1yDLGyW4o6bsdP79g2DLQglLJ+aJprbqHXUClC2v0TE45MhXYy
	 1nmbL27bQQ/yywvEwYFjnCyG8mNLHZEPGDzSLCgGmF1iaJgIWmkoL74bNdVXMxf6QRVRy
	 trJn/kYL+a9aFc7fDbBpE08jhEpCI7MKInWUc43JaO5/ntyUdrjxe2s6hMZBUhApUnpIy
	 PyDsQ0hi0maERlyjZRLdfR26W9g5lO7iafLGY9Byg85hsdl8tE1NPhKqGwq0mFUCEkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Djnfzho3wIGR9MBAuAzmJghXNGmFo9ARxka81cANV2w=;
	b=ksfx0nbADTX/4oqcp6NPJq7lliIoLU8qMt9+82x0XX8Ga/jRf2kTfBfKpgas3u0Yv1cT
	 RsQHdzDmJj1BgmG3rGhEPOtFRFiaoIcnye85bbE4t77u+pg3HnuW5paHZgDvANwxLZtFB
	 LQQjUWBGlB6dZ7eSYMOLXujHKSgNcKOtuxh82rh0Wmrj+WPeH3afx/3G/eN0TF+PLwovW
	 6lMOp6/UPp/5nSfFZaHuccOih011SjVIbRw+35lG6v0Bh6ymegtrcXueOIMMmrU4XtUd1
	 G63wUKP8OUDXtVWtWseCskFJIDHF0DmqXpXo0KjZ1Fgy6rAVqsAtWZppMJKHE8+X+wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GPx/sKTO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAE960A2602;
	Wed,  4 Nov 2026 21:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GPx/sKTO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CB11F0093A;
	Wed,  4 Nov 2026 21:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829197;
	bh=Djnfzho3wIGR9MBAuAzmJghXNGmFo9ARxka81cANV2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPx/sKTOioZAK7oAyu2i2hWbEwl22sDYf6fzxd7GuwXv/66nL3puDyduWBytKOidq
	 7F6xYa7NogDLHogSjRPH9ezxcEe3fUCkQj7Gp+uKWkSFE8p4fgDrEQPWYqVczpgTVs
	 NWw3dDXmrMFOHxsyrv3Zhx8y0/Xv8bzRuf59XZNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 507/547] HID: hid-lenovo-go-s: Prevent deadlock if device removed during setup
Date: Wed,  4 Nov 2026 16:11:31 -0500
Message-ID: <20261104211052.794238862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Derek J. Clark <derekjohn.clark@gmail.com>

commit 0ef3036c68979194fdee77a3a825fb94ef307a54 upstream.

hid_gos_cfg_remove() calls a mutex before canceling delayed work. That
delayed work function calls mcu_property_out(), which holds the same mutex.
Prevent deadlock my removing the mutex prior to stopping the work.
Additionally, since cancel_delayed_work has the potential to re-arm,
switch to disable_delayed_work.

Fixes: a23f3497bf208c59ad ("HID: hid-lenovo-go-s: Add Lenovo Legion Go S Series HID Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Derek J. Clark <derekjohn.clark@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lenovo-go-s.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hid/hid-lenovo-go-s.c
+++ b/drivers/hid/hid-lenovo-go-s.c
@@ -1425,8 +1425,7 @@ static int hid_gos_cfg_probe(struct hid_
 
 static void hid_gos_cfg_remove(struct hid_device *hdev)
 {
-	guard(mutex)(&drvdata.cfg_mutex);
-	cancel_delayed_work_sync(&drvdata.gos_cfg_setup);
+	disable_delayed_work_sync(&drvdata.gos_cfg_setup);
 	sysfs_remove_groups(&hdev->dev.kobj, top_level_attr_groups);
 	hid_hw_close(hdev);
 	hid_hw_stop(hdev);


