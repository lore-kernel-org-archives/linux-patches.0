Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3392BCF57;
	Wed, 23 Apr 2025 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421487; cv=none; b=gX2eXRZq1cR1/I/5gH54vfLP0AsAwjfBuZEE6v0K8e7P8SLCOf9NtKJQf0ps8meHrsrxn660GUyiFZOTNtkPyfCH3Ul3YudjViE+kwQ2EUSOFcK9Y0WwlblJPliLKcO1mGooLXxu18U3oVGO16yZckL2wTIuH9NJbejNImpvcug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421487; c=relaxed/simple;
	bh=K4+SROoZcWpXPl8XrC8R+xwAD/Yl8i8DgV4uWc2Gvys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgsKmXJ4MW07iAAErApp/ZyWVHBXm3lhw3MUkV/QxSs4PfmJOsol0CVKwKdNLPiMkwxh2N5lhCZvF9G4DA04/4jc/psJHcEWQsNQ2p7MrhlfbCycsFWCFmljBhF8KPfh6oq/5POp/Ef+jI7qxf3klnaoKl3legV2K5V8QQIKwIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYPkOk2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYPkOk2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D537C4CEE2;
	Wed, 23 Apr 2025 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421486;
	bh=K4+SROoZcWpXPl8XrC8R+xwAD/Yl8i8DgV4uWc2Gvys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYPkOk2Co9x4uRz856YO7GwojqGZcTqfk6zG7kw9xZ0M9wtYZLYneDXevdnBDKWj9
	 VW/SgQoihTIRM/B9xUBpVXBZB9vDn8yt/RB435KC5HNkxA5M6jRD0SMIG9jhwH63ZH
	 dGauz+M0emnMYIeDNRSBEF1mAr6ndArLgfIqU4R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 142/291] dm-ebs: fix prefetch-vs-suspend race
Date: Wed, 23 Apr 2025 16:42:11 +0200
Message-ID: <20250423142630.211696876@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -389,6 +389,12 @@ static int ebs_map(struct dm_target *ti,
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
@@ -446,6 +452,7 @@ static struct target_type ebs_target = {
 	.ctr		 = ebs_ctr,
 	.dtr		 = ebs_dtr,
 	.map		 = ebs_map,
+	.postsuspend	 = ebs_postsuspend,
 	.status		 = ebs_status,
 	.io_hints	 = ebs_io_hints,
 	.prepare_ioctl	 = ebs_prepare_ioctl,


