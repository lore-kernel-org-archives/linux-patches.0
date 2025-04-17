Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC411B4153;
	Thu, 17 Apr 2025 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916063; cv=none; b=pJXeDtOWy0mBvTbyCpOWDArhaZhsImdxaNtf40AjtaGT+ezMewQlTSdm6LXXm599Q3r9d42ONzwZsL0nOW4LDVGaqcYEmIwT5/7qCRyPTFUk9H71h0fpY5wF/uZ/xxsRY6esnStjO8FY/+Wwx7iJL6e66PVJxsJP5NS6q1bzhfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916063; c=relaxed/simple;
	bh=0s/89xE/A+bf4Tqx0GpMQwdjFy40qvvwmPcGJ1f50Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph50e/tMLvIEa1jwj8i5NTS2bMX1RzyQx5zmrQaduGzucW0M0QReVJdlAbYdxwlUMrx1XitNgN7rQST9DI2CFIEmkj0UvzsF6mov4nk/L3pp71h1zD60oi6Ds6VTSBdcZ6TVQ2dJEBkky4Q/rJ8eoaWzwuwQiHcbwawlAKvFXEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2X6KHdrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2X6KHdrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F7FC4CEE4;
	Thu, 17 Apr 2025 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916062;
	bh=0s/89xE/A+bf4Tqx0GpMQwdjFy40qvvwmPcGJ1f50Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2X6KHdrGnll+RXQzgkMi/8iEoULo4Kl1cQzV6yRmhen4pwRJLBSvmoihu1iI70H7h
	 RJrzTHKEyhfY8+wFEVplPXivunVguwFp+gMsvki2n/6UD4KRmfniKOZOZgGnCq8DRW
	 5nSm+1QiPWtY0VYxnb13hosD1KlYZJH9YOeEbi9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 331/393] dm-ebs: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:52:20 +0200
Message-ID: <20250417175120.920217468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


