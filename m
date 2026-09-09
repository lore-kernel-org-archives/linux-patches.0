Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAD7354AEB;
	Wed,  9 Sep 2026 14:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964174; cv=none; b=uot4iXPUSnJ8y8bRnQJk67l+DO/h+iealDoe+HgjNyv3hbXg66T4DhxncF7TgeKIkNPmDOMlV4HOwEtcj4VcL8AvO9LqEKrpjHoUJJG7Ui4FqTBlK8P1ELppnRKcFZYNvz4u3esBsOKznQKLuawMtzvP+XvXgtBCz2QEch7M+Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964174; c=relaxed/simple;
	bh=XGeTpw+QfqbB//Wd5DkIu34Q3+zwC1ZY2dlTBMKJuqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuxlOPxsazcVKNrgsjPUGNfkDpZNAwNAP4gMznbyVbU9Szx33gJMW//bx5eCkY3vzCysA8ilP0qJldfW79vl1D8wz0N+U+jc9BuVRxlsXDerdr9+iFrjJ0HuINMsxAVPzSMxid9nytF24Y37zTXPAAQqgVrBe3IDjWshoQNJ+1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFZjBl/u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFZjBl/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9051F00A3A;
	Wed,  9 Sep 2026 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964173;
	bh=2QnDrp6+NBEJKhwh3PsEzvxQo2UF/Rn9+F/6j08FeLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFZjBl/uxeGRrUM1K4rkyIi3oh66Q/N+YX73mqQUapoSZvUStkoY/XLdqUoUIMnds
	 Lfep0/z4YA7uTbY0hkPAOGQvlKyBvKOLcOcJUwVYAz9mkqRN6fOmpAFr9dkLeEQxAE
	 BA0Z9ngncjmkojS4+5d5S9Aq2jpQLsCq8GW2qJtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 333/583] scsi: qla2xxx: Serialize flash version read in reset handler
Date: Wed,  9 Sep 2026 15:40:18 +0200
Message-ID: <20260909134249.537846983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


