Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127D71A76A5;
	Tue, 30 Jul 2024 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359526; cv=none; b=NA2qLt1Zp7S81txMBXqzBfH5bBJ3V1Do900pb+N8yopZtGhMakb9RXWCK9JC2Z0tMC64B2k3RHtY3GnbIkI0mZXIVjw7e3NuubK4BScth2MciPvtxqQhCJZc4UlUbVVZKJ3aedzfmJAljRq+6ATLHJR6AhjtdsHp9lhS0iO0zXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359526; c=relaxed/simple;
	bh=/Im5cuDeGUNSsybPAsCAGnSsi2AVBuz7KeCbTJFvcAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONJDMxDTtOaYR+pfGg8KHtZNBDwWPblyEaA+93gwbaWYcL6TlrsQj0Kk4hLYq87aqVc+InwI8sNbsYzJ72rxX4nSLdh0awFWaprBJSsLke3OB5wRXjvcTk8oJX7sdJYBgqxEltCJZDaiIYdngHkchgFhrDnIeU+cuX7PxncxiCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HPafSS8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HPafSS8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35583C32782;
	Tue, 30 Jul 2024 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359525;
	bh=/Im5cuDeGUNSsybPAsCAGnSsi2AVBuz7KeCbTJFvcAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPafSS8CFoWJtzAoyFKev2YeFy90s+0f+zBXvyvIhSit+y87mpzzlY+Od80mAvWTf
	 yHlThg+1AQA0HB+RdqN430+ucwHQoAa49M1t9BKV8H+3YzPk0ELzfY23z3HpTNa1Qo
	 1FwnhYHrEYrMaWtf5dan97kbFbOyL7LOLo+n3khM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Kees Cook <keescook@chromium.org>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 488/568] dm-verity: fix dm_is_verity_target() when dm-verity is builtin
Date: Tue, 30 Jul 2024 17:49:55 +0200
Message-ID: <20240730151659.104869418@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 3708c7269593b836b1d684214cd9f5d83e4ed3fd upstream.

When CONFIG_DM_VERITY=y, dm_is_verity_target() returned true for any
builtin dm target, not just dm-verity.  Fix this by checking for
verity_target instead of THIS_MODULE (which is NULL for builtin code).

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Cc: stable@vger.kernel.org
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1512,14 +1512,6 @@ bad:
 }
 
 /*
- * Check whether a DM target is a verity target.
- */
-bool dm_is_verity_target(struct dm_target *ti)
-{
-	return ti->type->module == THIS_MODULE;
-}
-
-/*
  * Get the verity mode (error behavior) of a verity target.
  *
  * Returns the verity mode of the target, or -EINVAL if 'ti' is not a verity
@@ -1572,6 +1564,14 @@ static struct target_type verity_target
 };
 module_dm(verity);
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type == &verity_target;
+}
+
 MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 MODULE_AUTHOR("Mandeep Baines <msb@chromium.org>");
 MODULE_AUTHOR("Will Drewry <wad@chromium.org>");


