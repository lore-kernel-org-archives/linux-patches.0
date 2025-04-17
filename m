Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645E1264619;
	Thu, 17 Apr 2025 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914854; cv=none; b=mG9cRkcsKTdDANVmW6r24aRrT/xnxBd9fcdQC2iXaiJ5MdqQ3nmOVwOSakeKZjsj6aJ0V0k3taleOJMfogBM8Hx5SIdBqH3osohg/1RNj7glRRQQzbcJkDJgsZgdgT9ffxfMG9vayyUXBbd+Nuv/1M/nNxfEGoX0jqUikzujSn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914854; c=relaxed/simple;
	bh=Djm6KdNi3yKxJEv/VSxoZVH1dP1DdIsNDgPQqkrBqQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEDTTObxny6tr82Z6NcbzFWXnknMXz/HmfgcvtDP+A5ORlPWePYK+fmbazpyMzemnkEZIADa5py/5WT8oaOZI/zbJ2SSKrSY2yBLWb7mxJHJ8YUoNU1g4uihni9J0+9gut78tQUsIiUuYb81pXNzYuq2UrGFmfnGYhHi9dxEEcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3Dfd3ih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3Dfd3ih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD518C4CEE4;
	Thu, 17 Apr 2025 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914854;
	bh=Djm6KdNi3yKxJEv/VSxoZVH1dP1DdIsNDgPQqkrBqQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3Dfd3ih4x7pf6ZzzhfDCLv7D4U/hJ5GWtXqXPqymhQk4I0wPi0xhSfwT3ilkCjys
	 wYqfy6VHHLmLBD1N0chXRCfssSQ27/qD3mAMBo/p0a00nObrdp8az5XYq6qWFAWh0S
	 GGGN2eYXvYDiThkQ7a6iHXYJPy//bWyzs/SdfRtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 353/414] dm-ebs: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:51:51 +0200
Message-ID: <20250417175125.646663468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


