Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826950;
	b=fwEWMonababjUHefb/uXlvsYLd6h1YrDGhxG+HI2xdpMu470dZ2/bB0bgmG9l5xuvR8z
	 OK8mzL2XPZsMRxtfZtlPHjofZYEKmvhXyN+SbodVCYbmbyA9TcA1II+OgWnbMtWoeVDca
	 VCompzGue0mulbr6EqTs2yoSoC2qLy2ADfIDsl/rEw+oEzkf91VpQ3W7O00NjU2CREROn
	 dF1A/pbReKRsBFOUqPDyPD1GVRfPqhe06E8HD1AdvfYzRIkWg/c/dyq06DFK806QUVPBN
	 yTJAdYsoDFFyTdoKVXvVBYLNEk23l+ZPY19J52abi0nsf4d/eB4NEYCpe9AjeU+b7lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y78gq3pkUc7IgS5VDfaXvI19sbwfG5cgO7HcKxrjDoI=;
	b=3cBsIholCL9BZZgTUSUdBHJrl2Xj7EUw1v+9g1qI7RC+NT9GeAuOBBjdd/OuuL17d/ql
	 LX6jmgLVfDJLC9Ie9ctlSuFjoz6sMlYl9WKS9uVkMlx/3PlPQyGRB61WAsw6F2Ldg4Z3d
	 De9CKeagcmvd5BWj2CMrgKmHnj+sJ7kYNlPSnt47ndP5D8SOnPcrcrJa7LiOiV7rEXgDb
	 0a48Dc8IcRrl/aom/FPi6oJj9rQv1eiYa9J9m5eWuN/AvkYZs4pepA17xKZ+cbst18VdB
	 Hm54tACK44xfN/RsgBGduI9Ne+VDLyPFqLX+Ux7Z35Bjnk7PSVgyXkAZAieHzRz5ZeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzcYAuFi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E1560B78F0;
	Wed,  4 Nov 2026 21:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LzcYAuFi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EA1F00A16;
	Wed,  4 Nov 2026 21:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826950;
	bh=y78gq3pkUc7IgS5VDfaXvI19sbwfG5cgO7HcKxrjDoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzcYAuFiS2Sh8tZ3uKeMUI1aOI4SYFR+bQhBEewBJwiDLbvwj5lLzE7OGAM3dZV8L
	 GRuyzPpasYtD2khOPJ1lAOlK47+8Ov40ADDJl92OlzPOSIhN+ODTmubPLMBF07yPNI
	 0iEiU94+s7kT0dz4jqX3nlDMrsEAGbJ25kIaGHcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 7.3 105/547] driver core: Limit the messages on a refused uevent
Date: Wed,  4 Nov 2026 16:04:49 -0500
Message-ID: <20261104211041.197526470@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit a01c8e5b1dff1ce489e6b339139e744db36b8bb3 upstream.

A write to a "uevent" file which is no valid action makes
kobject_synth_uevent() print a warning and uevent_store() an error every
time.  This is generally considered a bad thing so rate limit these
messages.

Fixes: b0e37c0d8a6a ("net-sysfs: make sure objects belong to container's owner")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/2026102718-conduit-glorious-a8dc@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c  |    4 +++-
 lib/kobject_uevent.c |    6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2847,7 +2847,9 @@ static ssize_t uevent_store(struct devic
 	rc = kobject_synth_uevent(&dev->kobj, buf, count);
 
 	if (rc) {
-		dev_err(dev, "uevent: failed to send synthetic uevent: %d\n", rc);
+		dev_err_ratelimited(dev,
+				    "uevent: failed to send synthetic uevent: %d\n",
+				    rc);
 		return rc;
 	}
 
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -223,9 +223,9 @@ int kobject_synth_uevent(struct kobject
 out:
 	if (r) {
 		devpath = kobject_get_path(kobj, GFP_KERNEL);
-		pr_warn("synth uevent: %s: %s\n",
-		       devpath ?: "unknown device",
-		       msg ?: "failed to send uevent");
+		pr_warn_ratelimited("synth uevent: %s: %s\n",
+				    devpath ?: "unknown device",
+				    msg ?: "failed to send uevent");
 		kfree(devpath);
 	}
 	return r;


