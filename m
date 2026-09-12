Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F847124F;
	Sat, 12 Sep 2026 15:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228492; cv=none; b=pjGeo4HW3YQZfhNFrrQGpyzqqZ2E9n+vbCWkNihq0d+HCSQ3iKWWtJgNvYHGl5TQmbSvSSBZ6lmEVxKNoq76zjaobZsvRDgczO9qjF2kw5sebn9NqoW7IEj/n74bQeZT9kyoQASeQ09uuA6FR4xrfsp9VUH2Xu1HDMLXUMPU2LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228492; c=relaxed/simple;
	bh=M1BH8sGkgoU623LIovStZ8V4RLgvBTjSf2eep+0ZlxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7zWBm+nIinwLM5HF2WaPQFm7lFN6hUmiQTSg9GKmrtWrI9kkog9x/hp8d4LPLDp0SGFSwVgp2eEEKaY2RpZYW0W7CRJocqbI/IzIz97oP4Y5xROTDMkmHUKIXB2nqTgTARTtSEMXPgLKBsVf6OqbAyKJTEmAiGziLlKv4eUABs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPaLvRz3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPaLvRz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1388C1F000FF;
	Sat, 12 Sep 2026 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228491;
	bh=vgIg0lT7ENq/4sJ5MvnAHzAWdX4A2WrNrX2bk+NwOpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPaLvRz34ja85X/0TvFGZ9b+yYrtkLi0tRdQET5MuQOe/XNzLyD8QFGYDDJbpjKBx
	 hGmTBcaty2LOWEHc61aGkpFfheT/6hRrd+BfsWZbCEeJ6FhnA/EPj/Jm+TnsquI4Wl
	 h6qFN2jKQwofkNF3ag5i2a1NdG5+ceRZgwwLUehM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0396/1191] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Sat, 12 Sep 2026 08:52:04 +0200
Message-ID: <20260912065557.133078653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


