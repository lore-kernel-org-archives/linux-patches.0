Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E508657EDB2;
	Wed,  9 Sep 2026 14:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962858; cv=none; b=tHlzhgROP0T3VZVab8KfvGCZQeSy6//QuGiUAxdL5CRSwZY3+kqTyTqyU41UgvsZh0XtfSSrampVUTHiqEiRH0wcn0ViTcFymDpdGs5StdtvXANHkbMzg39CFqznww8W50jIq/5KefRakmEZNX8OEJQ8wzLHmDhx4dWENWITyQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962858; c=relaxed/simple;
	bh=/qs88rDcIKDMaHfOFQSkt3HmKfpdGkv0ISIyt1z7PTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttrBtdWch/K+VIivt/YRxsaBohcvjYOS2eO3Xw7YxtCouzKTZIGCzypHofduYGHKj4SW5O55NqBbrwjGribkML6DXJddnZhW2Q1i9fzJ04y+SCsWW1TsunedB3riljXXRimDNmSHmwc2s60c2TIVXNLnF2e6D/741Yoozg2KuQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJjndpXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJjndpXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5B21F00A3A;
	Wed,  9 Sep 2026 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962856;
	bh=cyEL3vGR+0PeaSPSEIod6aOa6sxvDHvERSOeRq+eogU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJjndpXoQDv+udD2FEUxFdAHu2hEv5MPKf9M0oS3xRSe2d8C4H2rWZtM1XgNG1lDB
	 wIRlDwszNTJDm1SNWfmSJF+fU5v0WL+/MjdKmXFZvjQE/aAF4QrGHOS9P/yVjLuu0p
	 lhAkK6BPcbwzL7oZD4I8nyLFu0Dij+Tyayp4G108=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 428/556] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Wed,  9 Sep 2026 15:41:48 +0200
Message-ID: <20260909134245.657970102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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


