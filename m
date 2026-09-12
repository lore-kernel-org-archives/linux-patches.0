Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CCB4825A1;
	Sat, 12 Sep 2026 18:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237851; cv=none; b=ClpsKo4jJgeO+9wZ6yPlug4JzIfaenPjwUzTswrxGugjfEkoundaJEWPN7J3h29E3B7njYNTK4R+TZu6bJ384kS99gdwUCqIjcK5sz2Wrvzyu2JpjAFVWbyUlcF/fYHX6EEXFbEslesXfqOEl+++OaLTnbyrzhNamcXTDz1rNaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237851; c=relaxed/simple;
	bh=4CzkZCUU2dDIHX0x6D9Xj7EgvQz5fmj8AbXFFbQfT6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAUax0waEGasm7kfArKCfkqREtsjz+9H8inBgivOx4zQEv5iZiiu/G8buzd24GwU4KjOmtwfndUOgX0o6Duvwd0weY1o6+PIQidncbg0kkbhMlMUDDpc3/ixiGK1b3ca3hFalOJprGLoxr1FOWP7piByvmwc+MlZqOqqhiET4tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBzcICLq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBzcICLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A365F1F000FF;
	Sat, 12 Sep 2026 18:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237849;
	bh=vBHYRKxQx8lKh9fOTkT0olN7XB4EzHgqXbyact1M5n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBzcICLqkjiJGK7AXoHGSmgtDywZpH0NoKmyzkpxHjgrjTcwrUmIDNQSXxgqhUrpZ
	 W6frLnPcld3Eza6lW9EdZ5Ufp5MD29JRAeD/gUQjUCjmoETUyniyCqQk5m0xtqFVPN
	 0pjZ5nBH4gEP9MD0uuqcvZCZRsd41ZhiuCinR350=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 341/935] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Sat, 12 Sep 2026 08:56:11 +0200
Message-ID: <20260912065534.626499409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit f606ed93de0c4f1e7e3618779e9fad731455314a upstream.

The "update cache versions without reset" sysfs reset operation (0x20261)
calls get_flash_version(), which reads hardware flash registers, without
holding ha->optrom_mutex. The VPD update path serializes the same call
under optrom_mutex, so this reset path can interleave its flash register
accesses with a concurrent VPD or optrom flash operation and corrupt the
reads.

Hold ha->optrom_mutex across the get_flash_version() call to match the
VPD update path.

Fixes: 8c2cf7d4e387 ("[SCSI] qla2xxx: Add a new interface to update versions.")
Reported-by: Sashiko <sashiko-dev@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-4-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -816,7 +816,9 @@ qla2x00_sysfs_write_reset(struct file *f
 			    "Unable to allocate memory for VPD information update.\n");
 			return -ENOMEM;
 		}
+		mutex_lock(&ha->optrom_mutex);
 		ha->isp_ops->get_flash_version(vha, tmp_data);
+		mutex_unlock(&ha->optrom_mutex);
 		vfree(tmp_data);
 		break;
 	}


