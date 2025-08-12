Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216AD27703A;
	Tue, 12 Aug 2025 19:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026405; cv=none; b=o8ghZ4fkgxU7kM+b+Nbuowlt04M606MVR9Vbo6IKyjbP30kbuY2LLKB6Kwyc61SInTaqkugxDE08uXutsrvjZ5yy72f0fGwpwo4To67IVSp9i6hnsvU0W3i8MwtMI1RlFe+/FrSp4A6yoM/5NqZ/O0f8WSDXi3j3ov82tlPsiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026405; c=relaxed/simple;
	bh=EYh1IgdcA9Ev2/qGtAwViDzyQw8nWjhMb+GOfRJYbQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCV/mOInpaJEzYAxGiGezcX6nF5aCOPgqJjhxUmR8PvR/Cn5qNrNsx0QG8mf1KUytAIKQ83Hc+ITBw2QpcptlllZ5m8LP3xMfpKoD47MGo1Ny+7IKDGMHdTZI9/LZGALJrKw/f2deR3Br8/md8mJ36OesB1MguQkCZKF5peR2Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKaVoOG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKaVoOG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8E8C4CEF0;
	Tue, 12 Aug 2025 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026405;
	bh=EYh1IgdcA9Ev2/qGtAwViDzyQw8nWjhMb+GOfRJYbQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKaVoOG2yLWFFV3/Y9aq9rWAPMrkYE8y3CgvdzXb2QdD77L4aMHeDeCutXBpGC8jy
	 OBejXiNzdU/HHlJz5dqHk9dEJ6ZFHxYkBXBaCjD1ZYrKCvDFJGJb4tqm0JIf4ViO5g
	 jLJsn9wKvd07+GLTahYCqn/qj3h2Gu46VRYhF0RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 326/480] vhost-scsi: Fix check for inline_sg_cnt exceeding preallocated limit
Date: Tue, 12 Aug 2025 19:48:54 +0200
Message-ID: <20250812174410.894152479@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 400cad513c78f9af72c5a20f3611c1f1dc71d465 ]

The condition comparing ret to VHOST_SCSI_PREALLOC_SGLS was incorrect,
as ret holds the result of kstrtouint() (typically 0 on success),
not the parsed value. Update the check to use cnt, which contains the
actual user-provided value.

prevents silently accepting values exceeding the maximum inline_sg_cnt.

Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20250628183405.3979538-1-alok.a.tiwari@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 5b112de79f27..d3b8355f7953 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -71,7 +71,7 @@ static int vhost_scsi_set_inline_sg_cnt(const char *buf,
 	if (ret)
 		return ret;
 
-	if (ret > VHOST_SCSI_PREALLOC_SGLS) {
+	if (cnt > VHOST_SCSI_PREALLOC_SGLS) {
 		pr_err("Max inline_sg_cnt is %u\n", VHOST_SCSI_PREALLOC_SGLS);
 		return -EINVAL;
 	}
-- 
2.39.5



