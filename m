Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E1441684A;
	Fri,  4 Sep 2026 06:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502201; cv=none; b=dpuY+MaES4h7zExDEqPSUkzeYeuBR+xRvGmgpEI7mF1CNXs0gMSMV4IUEhbBuLCsg9LFNHL7yjGzbQVr2LEzt9QZqnIALDztU4OtkrgHul8D7N3L+04nrURF1Z0WP/clrZGswlhKukEgmbGhz3xfC5sZPQUdHLsGmU8uSJdi7io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502201; c=relaxed/simple;
	bh=PvmqbbTA4lcTCkkSEtxER59JZSJ0/lxyolLI3mqLzio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHjpVVS7TUwFWM9cZZliACJThsFkvq+kTYUYnyYx8DQBxqxITWzuoQc7gclIQp6imndRdVvOk3qfM8Cgdvj42Pl+M0Kb/DOkDCHFspF1j/ZJKKsXcRiOQNw72T/+zCSFTKPbTyRVNBoOEHP7BSaFtWaUKRki2d6qoU08f/DZkaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xro5zihi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xro5zihi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD931F00A3D;
	Fri,  4 Sep 2026 06:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502200;
	bh=FUzOIkbA/lLQ3BTJbpzWgbpOWYCVSdX2ysGzlcxZsBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xro5zihiXgtguIRQYJd8NrYMvjMiTyrazKH1BxOpLBwOSxThW/W7YIiEIgiaVTKkV
	 NrxHkB7cpYFw1MJDsuov4+PLvRi4ipVsObaEsxqIvZ0tosZSAjWArXKz3tgZ7+nHo4
	 Huz0PyvBBpA5nziid0hhqR8rNC8tZOcjGM4dMqCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 123/403] smb: client: fix copy-paste error in WSL EA length accounting for $LXDEV
Date: Fri,  4 Sep 2026 06:58:46 +0200
Message-ID: <20260904045737.635076929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 5d14030b46af1a958fd104b020fbb93631c98822 upstream.

The LXDEV block in cifs_query_path_info() uses SMB2_WSL_XATTR_MODE_SIZE
(4) instead of SMB2_WSL_XATTR_DEV_SIZE (8), undercounting eas_len by 4
bytes per $LXDEV EA.

eas_len is used only as a zero/non-zero presence flag so there is no
current functional impact, but the value is incorrect and misleading.

Fixes: 97db41604555 ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb1ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -747,7 +747,7 @@ static int cifs_query_path_info(const un
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
 			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+						   SMB2_WSL_XATTR_DEV_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */


