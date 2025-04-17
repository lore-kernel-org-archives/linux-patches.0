Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104361A3178;
	Thu, 17 Apr 2025 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913589; cv=none; b=IrmGtxYEnv7MTImoIEvx115Nw9zQ70j65PrNhetgDELFhFI5fOxKISNWVFLknWewskwaeNmYXas/kGRfrk3XgaO7z26KGDQPTzIXFb1LSPBZokk/OzRUiZSgD+WuVqTBZ1MAQkRewNbQauO9zlAg0C2flsDHRj/sUsutw8WppuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913589; c=relaxed/simple;
	bh=zd1OCTRbJtIPt0bva3hGARU+wDOl2uGqXPiU8HIsFEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TD4N5YQ3VR3BLBS5aOdD+trMvGi02mTSJ0Z/6unFXUHKTz+oteKAy8TxTU5fsgdtSUGU87o6N7mbGO8k0jJnlVaX1LhyLyCIwGEVnpk8bBKNEkUpd5ObagzTgbkoY3i0iiTXxdTwFcYH/8Fql8efiNvM3trE+EzNLvzYXZnxcO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0B4FRpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0B4FRpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951DDC4CEE4;
	Thu, 17 Apr 2025 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913588;
	bh=zd1OCTRbJtIPt0bva3hGARU+wDOl2uGqXPiU8HIsFEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0B4FRpIGQTu4Ba43ygimWEYXA/K1PEBjP0nDL1u5SzVl7DZEHySHLwPU9SRGV8j7
	 WkNlX0bAgR206iDD+d7SVd5XuRDz1pVKM5gjLmpR7NWw0y+UVLF7B7rd+mQQ6rAxUD
	 pEa9we7toxbbFBlBKf1d3mvZFy+IHImeUjPOm3RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 387/449] dm-ebs: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:51:15 +0200
Message-ID: <20250417175133.842413429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9c565428788fb9b49066f94ab7b10efc686a0a4c upstream.

There's a possible race condition in dm-ebs - dm bufio prefetch may be in
progress while the device is suspended. Fix this by calling
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ebs-target.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -390,6 +390,12 @@ static int ebs_map(struct dm_target *ti,
 	return DM_MAPIO_REMAPPED;
 }
 
+static void ebs_postsuspend(struct dm_target *ti)
+{
+	struct ebs_c *ec = ti->private;
+	dm_bufio_client_reset(ec->bufio);
+}
+
 static void ebs_status(struct dm_target *ti, status_type_t type,
 		       unsigned int status_flags, char *result, unsigned int maxlen)
 {
@@ -447,6 +453,7 @@ static struct target_type ebs_target = {
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,
 	.map		 = ebs_map,
+	.postsuspend	 = ebs_postsuspend,
 	.status		 = ebs_status,
 	.io_hints	 = ebs_io_hints,
 	.prepare_ioctl	 = ebs_prepare_ioctl,


