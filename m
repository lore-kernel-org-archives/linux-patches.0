Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346D23BBFC5;
	Sat, 12 Sep 2026 07:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196829; cv=none; b=p/PlZ7z8xfiPd+uTIdpMUz2pQ0c+Y87Vd0m5GpCglA0U8tPmPgYhkTn3rovSm7BmB/TR1rKGCTFaoo3GszSh0bOKfEtGOo18GGr45poBm2YjxYospm2IRTfMWZQBLdZD+rVY9ge6SPI4q3bLwe+8FBK0dpqLgGWXyJUakC912iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196829; c=relaxed/simple;
	bh=XfuZR+0PIfaO1/GWg9quE0tFYLjIsIt6nseXhTsWIdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMJNt2QRMPBqxje6OX9j1Tf3nJ1ebA6JoWH9u8HtbyaFYqRshPAc9Lce8TqqGmmJKPGx9crg+L/PpeNaxKl9LE6vlP4xvWZc3lbQBSlaFYBg+ROP03iZzbaAZyaZF5zbHYcYlNwgq0QektQ5Mj0iXG3y6vd6BQ6zw0kZ1g5aniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBBXDL4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBBXDL4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC04E1F00893;
	Sat, 12 Sep 2026 07:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196826;
	bh=O7RgP8FCkvT6v7Fctpdng/o3HiJaTfjduh8l1ibzOjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBBXDL4+POBQFYpss6b1XssvSqXr08itESnLOUzflnbJ4uhQOq6PdrujEeb3egn/b
	 8ZYsz28Iy7615YitB1H+HEj4PFTywZzTu6MCMB4c50FXv95KpfRQip4ifzTUHm5a4A
	 Lw4tPfH4w3iM2xBFoaiUrEv8VQt8WW5f92ob6rq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0005/1815] i3c: master: Fix device_register() error path
Date: Sat, 12 Sep 2026 08:29:15 +0200
Message-ID: <20260912065649.134461677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 74be657d98a8d684c0475f3cbd450ef2a30ffc73 ]

When device_register() fails in i3c_master_register_new_i3c_devs(),
put_device() is called to drop the reference taken by
device_register().  That drops the last reference, so the device's
release callback i3c_device_release() runs and frees the i3c_device.

Two problems follow from that:

i3c_device_release() does WARN_ON(i3cdev->desc), so it warns because
desc->dev->desc still points back at the descriptor.  Clear it before
calling put_device().

After put_device() frees the i3c_device, desc->dev is left pointing at
freed memory, so clear desc->dev as well.  That prevents, for example,
i3c_master_unregister_i3c_devs() seeing desc->dev as non-NULL and
dereferencing it.

Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/linux-i3c/20260701203053.8F3971F000E9@smtp.kernel.org/
Fixes: cab63f6488761 ("i3c: Fix potential refcount leak in i3c_master_register_new_i3c_devs")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260702183644.60827-1-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 456f832e5fc2 ("i3c: master: Fix recursive locking during device registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1928,7 +1928,9 @@ i3c_master_register_new_i3c_devs(struct
 		if (ret) {
 			dev_err(&master->dev,
 				"Failed to add I3C device (err = %d)\n", ret);
+			desc->dev->desc = NULL;
 			put_device(&desc->dev->dev);
+			desc->dev = NULL;
 		}
 	}
 }


