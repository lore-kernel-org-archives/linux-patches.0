Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B068325393E;
	Sat, 12 Sep 2026 07:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199125; cv=none; b=HctUiegzombmf6PpVB6+Ilueedf2l4l/i0zWp8p/N15w1+ThhkX/S6fbPLjLwYYkx0vF55YOkf3fzdGlz9r+9nrGO8GN132Y3aO6M9N3erxOdHmxVwbWNVi+n11AvGt3z+tPhMm1JzB2qIdn18RBlAnbS3ZleYczBAWSsj8owlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199125; c=relaxed/simple;
	bh=vAUKHdhb0sRirWZeuPzWSPdOyvZlO3xzEvh4aj7IGZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAHlzgieHe3+Cmck43VUPhnX2Mn1ZmfI5K65DkUcqb0cI7FoKDZYGsY6mm9EVzq/z27FozBWD54b8iYFmEeQCX+lbeixScrRmSrl3dLxWN5gBDIWQLmLNFP9J+ULRKxcA0lLJXr5UNZs5iQmP2dagu9w4CumcCceLZjXOOW8nMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RoxOpu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RoxOpu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CE61F000FF;
	Sat, 12 Sep 2026 07:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199124;
	bh=25H+cCDtlUw7rEzKSZsDpj6aSU/jDjE6B8qNRZ/jujM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RoxOpu4BjO0/zMAxOQ+71OwjpA4LiZLzh5TAZ/VfDCLyt9IrNxteQw/Fh2+Is/my
	 QXcgPqY47jdKnQoCA97TcSS0tmfHPgvzeKp7f+Ymn+GJq/z+VykqckoZrrLncwc9W7
	 bkAKQIE07+fwwaQy/5QoDEOnuFn5FW4akPDXYANM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ewan D. Milne" <emilne@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0521/1815] drivers: base: Remove statistics group if encryption group not created
Date: Sat, 12 Sep 2026 08:37:51 +0200
Message-ID: <20260912065701.121908320@linuxfoundation.org>
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

From: Ewan D. Milne <emilne@redhat.com>

[ Upstream commit 6e328b4a208f7a06df3c1df18d7645c74c90f5f3 ]

If transport_add_class_device() gets an error from sysfs_create_group() when
creating the encryption group, it does not remove the statistics group in
the error path.  Adjust the error path to do this properly.

v2: Only remove statistics group if tcont->statistics is non-NULL

Fixes: bd2bc528691e ("scsi: scsi_transport_fc: Introduce encryption group")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Link: https://patch.msgid.link/20260713173318.3060047-1-emilne@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/transport_class.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index 416e9f819df51..351c3d3ce6a08 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -168,11 +168,14 @@ static int transport_add_class_device(struct attribute_container *cont,
 	if (tcont->encryption) {
 		error = sysfs_create_group(&classdev->kobj, tcont->encryption);
 		if (error)
-			goto err_del;
+			goto err_del_statistics;
 	}
 
 	return 0;
 
+err_del_statistics:
+	if (tcont->statistics)
+		sysfs_remove_group(&classdev->kobj, tcont->statistics);
 err_del:
 	attribute_container_class_device_del(classdev);
 err_remove:
-- 
2.53.0



