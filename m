Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA91515E5BB;
	Sat, 30 May 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166976; cv=none; b=oaBfibekZ/uo2rlMo5g6THPF0/hfmifIc2Kusa1fyLln3HyfDLqfJ04OK9x1Hl1ICSlT0X2jBs5Pdrw9yH9aGqVAX6sINiTjHXHFEZgkEshbzReTvV/zTAC6wXJg7aClWoN9CD33ynHWdVZp7Iz2U5uR/522dPb6sELT9EzEYKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166976; c=relaxed/simple;
	bh=oiwnatGLF5wU84TGaU9ocr5t4//YEfrsZPap+A54WW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvXybVFfjn4PKSzkOSHmMnLFkogOYde8NTKAlWDCx2UecLlrBmbB/rrl5XFDbavrUULiZG6py1ULOeI3mDcdbQd0Sth8Wxtwj/Kn4oX0V7cWD23HRq/41akRXtFX+2vmSvPJJrXDVm0TxpV4vaSWwXvIZAgW6RY7LdNIvZaKMDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/gfjdvf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/gfjdvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0C81F00893;
	Sat, 30 May 2026 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166975;
	bh=xLOC/k4nckMGR4ZZeaHyOLpZdg7eYp9XWI1hEngdo78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/gfjdvfCMY5uQ2ymPtVxHxm97//ZrD86YYRJqQdlzQSaw/R4QApmSjR332qszUIj
	 S8eCRRBBwIWNFwggZdP8atrSrePZnoj8AGBX2Ha6Yp8aX2zhcIhR65CEWxYSGwDaSX
	 f9aPXigkHFUaU8HiKNym/lnUK+Eutva+qicCffSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Jain <rajatja@google.com>,
	stable <stable@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 527/589] sysfs: dont remove existing directory on update failure
Date: Sat, 30 May 2026 18:06:48 +0200
Message-ID: <20260530160238.525518129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 237557b8a81ab948e8332f7c0058e758f081c0a3 upstream.

When sysfs_update_group() is called for a named group and create_files()
fails (e.g. -ENOMEM), internal_create_group() calls kernfs_remove(kn) on
the group directory.  In the update path, kn was obtained via
kernfs_find_and_get() and refers to a directory that already existed
before this call.  Removing it silently destroys a sysfs group that the
caller did not create.

Only remove the directory if we created it ourselves.  On update failure
the directory remains as it is left empty by remove_files() inside
create_files(), but can be repopulated by a retry.

Cc: Rajat Jain <rajatja@google.com>
Fixes: c855cf2759d2 ("sysfs: Fix internal_create_group() for named group updates")
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_t1000
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/2026052003-uniquely-hastily-c093@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -148,7 +148,7 @@ static int internal_create_group(struct
 	kernfs_get(kn);
 	error = create_files(kn, kobj, uid, gid, grp, update);
 	if (error) {
-		if (grp->name)
+		if (grp->name && !update)
 			kernfs_remove(kn);
 	}
 	kernfs_put(kn);


