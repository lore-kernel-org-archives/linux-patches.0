Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704141;
	b=Y9SpQ7lQOMN2zwvtalsR4vtIMRjj3GcMeF0/DFgRrojrGO/pZglCa17a1iaJL58l8J0w
	 1MgCQDoL0eg8okDlcFBF4dLqxmlZcxsDufF7fEQlyTImmXTcr3HLQUP7RJHAxlNbubdRW
	 ZIWMMWJ95/soumFaqlQyZxFV00/YXRe12c9jr5agrjO4HyZ/4FO0mMSvptwWBBPitkGIi
	 J+xjRgNBN0+r4RKvgRA+mKkFikZ0sZgJ+UJf2b3zyjwaHESg2//+mmHbreCMrH5M3hw0m
	 49uLaV/k+FU8GloFxp0l/faNoAO+fs5iquX3xNfT1n79AvomGxMk/sEZdmyMO7pYRBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PqIjKC3kJaOVaTzE7aQXFH0A49PQVXp/St42fD/Dsq8=;
	b=SjjFSbc6/+Ba1wCz8pFDL7tDLZHF379nQmqH0xFaa9nlm5zSRUqQOCx/4ZRQBOu5gU23
	 S10eKvL+ZzDQkWkogw9tdLwBkOdZFtfjWamqG025c8p26rD73NieEJ8yYINnNkGMp3wRD
	 4f2K5GICanNcbCY77Ik9lJOFDjL+ioI+vYw0Zavtn4pdppGE0d79XEWBB8eTgGyyjqpBf
	 57kjzBVqLCLMxzpChUNUYVXinBedBYBBRrVR17EDPU4AJ37GpFs6olBXjdQux25cSP9eh
	 HOsb35lrLCSWwnCditDTL6AFJZ+JdpKBC6CaECZ5d3KUVthN76EvkPvNJcEI9QOdSYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7fvRJoZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB8606A31C;
	Thu, 26 Nov 2026 14:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W7fvRJoZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AB71F000C0;
	Thu, 26 Nov 2026 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704141;
	bh=PqIjKC3kJaOVaTzE7aQXFH0A49PQVXp/St42fD/Dsq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W7fvRJoZZGb5MZ/u+ARHjcyLlG3halgBrpSbyf0bd0mK+AFEI9zB+xVLWGaQASiVk
	 m2KYFrcSMOTbNJlh+yPckoalkub5k8cGwl3Pqj8rAEyvIxg2aOiEDfMKoT8B0zJqVz
	 Wg5N5FklZQSlhGDeKkdVLWlngttA9hm3cGTRwL04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gideon Heinz <gideonheinz02@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/265] Input: destroy force-feedback device on input unregistration
Date: Thu, 26 Nov 2026 15:35:50 +0100
Message-ID: <20261126143606.473110695@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2ae35f090d029d2d8491b0a7f98a04c5c05d0a44 ]

When an input device is unregistered while userspace holds an open file
descriptor to its event node, input_dev_release() is deferred until the
last file descriptor is closed. Because input_ff_destroy() was only
called from input_dev_release(), force-feedback teardown (ff->destroy
and freeing ff->private) could run after the parent driver had already
unbound, freed its device state, or even been unloaded via rmmod,
causing use-after-free errors or page faults in unmapped module text.

Commit ef166ce08801 ("Input: stop force-feedback timer when
unregistering input devices") added a separate ff->stop callback for
ff-memless, but left ff->destroy invoked from input_dev_release().

Once __input_unregister_device() has disconnected all input handlers
(which flushes effects, closes the device, and marks evdev dead) and
deleted the device from sysfs, nothing accesses dev->ff anymore. Call
input_ff_destroy() directly in __input_unregister_device() so that
ff->destroy() always runs synchronously while the driver and its module
are still active, and remove the now-redundant ff->stop callback. Keep
input_ff_destroy() in input_dev_release() (where it is a no-op once
dev->ff is NULL) to handle input_free_device() on devices that were
never registered.

Fixes: 509ca1a93836 ("Input: implement new force feedback interface")
Reported-by: Gideon Heinz <gideonheinz02@gmail.com>
Closes: https://lore.kernel.org/r/CAPb1+K2BxnfQ7VUQ15td5f9pVhn-ARSM9EjfOU8WuW72o+cvPg@mail.gmail.com
Tested-by: Gideon Heinz <gideonheinz02@gmail.com>
Link: https://patch.msgid.link/2f722967b6db0692d4dd4164aff39b62@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Dropped the ff->stop removal hunks (ff-memless.c, input.h, input.c) since that callback doesn't exist here, keeping only the input_ff_destroy() call after device_del() and the comment fix. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/ff-core.c | 2 +-
 drivers/input/input.c   | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index a765e185c7a12..41609fd328b18 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -361,7 +361,7 @@ EXPORT_SYMBOL_GPL(input_ff_create);
  *
  * This function is only needed in error path as input core will
  * automatically free force feedback structures when device is
- * destroyed.
+ * unregistered or destroyed.
  */
 void input_ff_destroy(struct input_dev *dev)
 {
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 9190aa18263e8..c648b31a0b2d1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2193,6 +2193,8 @@ static void __input_unregister_device(struct input_dev *dev)
 	mutex_unlock(&input_mutex);
 
 	device_del(&dev->dev);
+
+	input_ff_destroy(dev);
 }
 
 static void devm_input_device_unregister(struct device *dev, void *res)
-- 
2.53.0



