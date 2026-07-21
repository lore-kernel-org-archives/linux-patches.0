Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F79D407CDA;
	Tue, 21 Jul 2026 22:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672527; cv=none; b=A2+MvnupjlyrF3JwC87BGnqeHtgLvV8CG0b1ljKIKv0mxdbpmPGsyzvVe3r7IN4vkv3vrx/UzppRCIw7LeoVW01PNbTxah9LyPAw3xVwA/1aUNbmchcK60rxK01Zr5RBD937NMwMLdDtepW6mfIbdwKob5Roz17vhStqVfX/fTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672527; c=relaxed/simple;
	bh=HeneCPq+LI7z257+eOtyHbKkMMZjLD5H/OyU6T+Z/oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvAscorMbBa6g/V5UF9BxIdQ5xqxm9hUROMWdT2fSY9C3iAimyt+wWDJEro5pKhPlDbxW1UHsFi40SGwpOTFlUl7A6iqUSqmqnamSr5h8KBsfjU+nmI0xBbcIvcZbcTYp1aR5bmR+8vuFMzi04XfHSWXz8sXqPhNrdNZwe1Sr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW7XmUSt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW7XmUSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F981F000E9;
	Tue, 21 Jul 2026 22:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672526;
	bh=chBLMO1ER9QIRafxBaTfnVonwXt9XXHxEIa2metxnAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iW7XmUStnpFD6CGBnMGQF7ZUlfh7ZvEUn8+E0ujIM3QP8EVc9gAHKY0K3zY10Gcf+
	 H+BfJE6f+ylmCZp7/CNm1ojxkIHSnywxNcMkthaCSHt2VmfFgSHBFNGzCumYN+miH2
	 Jr8Sc/MACJf2vrwVfzW7xw7LhLwMHADcNPhCqQ5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 658/843] dm_early_create: fix freeing used table on dm_resume failure
Date: Tue, 21 Jul 2026 17:24:53 +0200
Message-ID: <20260721152420.868028591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 366665416f20527ff7cad548a32d1ddf23195740 upstream.

If dm_resume fails, the kernel attempts to free table with
dm_table_destroy, but the table was already instantiated with
dm_swap_table. This commit skips the call to dm_table_destroy in this
case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 6bbc923dfcf5 ("dm: add support to directly boot to a mapped device")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -2257,7 +2257,7 @@ int __init dm_early_create(struct dm_ioc
 	/* resume device */
 	r = dm_resume(md);
 	if (r)
-		goto err_destroy_table;
+		goto err_hash_remove;
 
 	DMINFO("%s (%s) is ready", md->disk->disk_name, dmi->name);
 	dm_put(md);


