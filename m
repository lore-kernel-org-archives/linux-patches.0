Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB641A547;
	Fri,  4 Sep 2026 05:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500764; cv=none; b=WiaBv/SkZoHUa8Lkhe00YcS3cDMCGSMEX/5KD1u8U1yhh+MWm+/RYHO7cHDRF8solIivYNRtb0X+Y7xz8sFyG7W8FTmuPcpb9sWko4XaByzHL6ffMVqdDpj7PqOq1EVbkcGVsVRw3nut9+87VvEa+CoHLRKNNvSqmDNMVxQAYbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500764; c=relaxed/simple;
	bh=+PH6jkouoB6kKyDYVkobvUixuL74i55ElygkX8WC1Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2lljmjPteWnGFEJgMZRCVZ18+IDzitlMD1i00vU7+WafsXZIMZPTGy9i9+exYlKTmrtuj6lSLAWflmWO4SC57A2+U5HDwQrkpIURCxo6hgqiWhokfET0fTbwUmgOCkFQgH8uIsOrNdpynudeh1l1i2P8kiCHPrIPTWr1m+wYRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3t0WEtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3t0WEtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80991F00A3D;
	Fri,  4 Sep 2026 05:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500762;
	bh=I+/9wimgmPNc6Jr8zXTobalZS1VzESfuanoekzzq1cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3t0WEtRosTF7l1Q4tLkpoi/0B5DttpZDQkdVjG2BuvFMzL32JW5/InTr32hPtCQp
	 6weHWFMrJRW9yMCjQwr5wUcf0SUJTalEoGMQxvhyLd/4J7DcHAKPlvwkhcsJA00EHk
	 /zNOsK7mxSWdYhN7AEGNXfK34K/gmJn/Tk/Ce/cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.18 172/552] smb: client: fix copy-paste error in WSL EA length accounting for $LXDEV
Date: Fri,  4 Sep 2026 06:55:29 +0200
Message-ID: <20260904045752.923583030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -727,7 +727,7 @@ static int cifs_query_path_info(const un
 			ea->ea_value_length = cpu_to_le16(SMB2_WSL_XATTR_DEV_SIZE);
 			memcpy(&ea->ea_data[0], SMB2_WSL_XATTR_DEV, SMB2_WSL_XATTR_NAME_LEN + 1);
 			data->wsl.eas_len += ALIGN(sizeof(*ea) + SMB2_WSL_XATTR_NAME_LEN + 1 +
-						   SMB2_WSL_XATTR_MODE_SIZE, 4);
+						   SMB2_WSL_XATTR_DEV_SIZE, 4);
 			rc = 0;
 		} else if (rc >= 0) {
 			/* It is an error if EA $LXDEV has wrong size. */


