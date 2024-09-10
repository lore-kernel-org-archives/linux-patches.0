Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0118C913;
	Tue, 10 Sep 2024 10:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963623; cv=none; b=dE+jwiBlhZTMwqJ277DXypPUNwan9o3wKmxIv6hd5c8SYOMc6L0BDbmMiTL9XY0NtDmbDI6f/1gxFPW1v65yxDBK5wHb6eH+f9ACYCFzfzrQ6MR9gm1Nrd4LdVE7vo5UVl/NbC12lWKqHt5qYy3TVGKYPOAEGHpv7lYjAaIJ+WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963623; c=relaxed/simple;
	bh=OgLYA1SxCFDceKFGDAeztagqXh3mCueKTjL04Jvv4os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwlTLaiTwz4f1YwNNkngCyY1LGhAvNxca0xA9dXpBqxD2WYf+qgqTxy2XCUpDTL20hkPjudYHMY2fe9TGPZcGfUOM9TV5lgDwQWktcsdQ2JSYJ4GKgfeiLkWY1WJotftYBEiq6kk+lxwGGEeCpkDnRnofZC0hwoukPcb/sHvXVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBJ+kyZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBJ+kyZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2861C4CEC3;
	Tue, 10 Sep 2024 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963623;
	bh=OgLYA1SxCFDceKFGDAeztagqXh3mCueKTjL04Jvv4os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBJ+kyZkQGrRnNyqofv5XSAyNIkoTU8AgQ+q27wu6BSFzzQ4TeXuGjy7XCy74WkAS
	 GbKVAqp1w3EZTDAFtgSVzMetlNXdcCe0BNNUQLD99wdL6Cc4a1MQao3Rfd+npraFZ1
	 50WLg93axylA/BO5Z7dUNbKHAj1TvwiVIg+0Lj4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shantanu Goel <sgoel01@yahoo.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/214] usb: uas: set host status byte on data completion error
Date: Tue, 10 Sep 2024 11:32:15 +0200
Message-ID: <20240910092603.420441149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Shantanu Goel <sgoel01@yahoo.com>

[ Upstream commit 9d32685a251a754f1823d287df233716aa23bcb9 ]

Set the host status byte when a data completion error is encountered
otherwise the upper layer may end up using the invalid zero'ed data.
The following output was observed from scsi/sd.c prior to this fix.

[   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
[   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/87msnx4ec6.fsf@yahoo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 11a551a9cd05..aa61b1041028 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -422,6 +422,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0



