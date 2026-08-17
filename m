Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978C143D50C;
	Mon, 17 Aug 2026 14:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977106; cv=none; b=EugSshbY7fwTPHGFg31tKQrycp+9R7r1n8GjxIiYJ24LhH7ufoZ4RbAiKlrNjqzUQQ0migXseW2dBso/0VX3h//F2Z24GPx3J/DdVCVJDfp/EQ0SMSrD2G1t21wKgq9q21bcfX7zNIKHcaznrPczUhUf1MGyRLKCL/2avIr/JGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977106; c=relaxed/simple;
	bh=gMtGZqKybEd+HKxpdy9pfSV5E5jwnuWGI6NwgLF51C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PopiAsgZAeEnNH/DUsvHMDIJOXjQGm7vWvOuomZmUJEWPc97WBPLSb6bEegpCN8yGUEtWNnaS+frG8P8Eash93JuONZC+Ds1UoTykxAYKlKxqlwq8S3+ZjVyeF1eaQGkMoOkHvxXh2TsCV7CDau4YEJ370glnTowdVPdqwIbDPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TJpNmR/8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TJpNmR/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB41F000E9;
	Mon, 17 Aug 2026 14:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977105;
	bh=Y3LqRMpJ/jvTTwy/To8mnMkTb7U5cUvxC2OK/S/013Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TJpNmR/8BzcObRJfjHiO2wdYS0MNCy1Ga/RKaMYLWbVf+pwk/1SpKSe8kDzlzRBNy
	 iXpElNpRjN5XiQ4w/+bQ0mS471GS67bXt0rndV4VTTJyKqfTL9u0w9OzeNVCHhSDoZ
	 IE4BaMDKPoI2Wk5HxEYCp1E2XNUBigBTUah2gmeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Phillip Potter <phil@philpotter.co.uk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 187/456] cdrom: fix stack out-of-bounds read in CDROMVOLCTRL
Date: Mon, 17 Aug 2026 15:29:37 +0200
Message-ID: <20260817132547.438740148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

commit b27e195d4db8dea263050bdbeb11881b2999c9c6 upstream.

mmc_ioctl_cdrom_volume() first reads the audio control mode page into a
32-byte stack buffer with cgc->buflen set to 24.  If the device reports a
block descriptor, the function increases cgc->buflen to include that
descriptor and reads the page again.

For CDROMVOLCTRL, the function then builds a MODE SELECT parameter list
by moving cgc->buffer forward by offset - 8 bytes.  This drops the block
descriptor from the outgoing payload and leaves a new 8-byte mode
parameter header in front of the audio control page.  However, cgc->buflen
is left unchanged.

With a standard 8-byte block descriptor, cgc->buffer points at buffer + 8
but cgc->buflen remains 32.  cdrom_mode_select() therefore asks the low
level packet path to write 32 bytes from that adjusted pointer, reading 8
bytes past the end of the 32-byte stack buffer.

This is not hit by CDROMVOLREAD, and CDROMVOLCTRL only triggers it on
drives that return a non-zero block descriptor length, which helps explain
why it has gone unnoticed.  The overread is also sent to the device as
extra MODE SELECT payload, so it may not produce an obvious local failure.

Reduce cgc->buflen by the same amount as the buffer pointer adjustment so
the MODE SELECT transfer covers only the intended parameter list.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://patch.msgid.link/20260720194421.1497-2-phil@philpotter.co.uk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/cdrom.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3165,6 +3165,7 @@ static noinline int mmc_ioctl_cdrom_volu
 
 	/* set volume */
 	cgc->buffer = buffer + offset - 8;
+	cgc->buflen -= offset - 8;
 	memset(cgc->buffer, 0, 8);
 	return cdrom_mode_select(cdi, cgc);
 }


