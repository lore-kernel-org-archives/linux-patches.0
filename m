Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A111471264;
	Tue, 21 Jul 2026 18:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660209; cv=none; b=dm3wTp2VDoYMmK3uzAZrNc93VwDVsAygrMTcajMpKXiED9tECxSYtGieVIDkrHDVaC2Ij/1WhIog30QUurgx4qy7IraMbINw/zzSkCb3pg8kvUoT2LVcjTk+cUvV6YtlscjPAWeLN16N+QjkRNy9ZzggVCRN7rwvZwbA3nBAFz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660209; c=relaxed/simple;
	bh=esNDYQ0tAm3UhUaUOx1QjOQeiq2bgv59yUEN8wPMqpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+xvsRea1ECT06u5tqioeJ/O1KHNaXfSLz3dDhzY5V0CTqAi2tLmqD1qcTuyPQWd94cdZx3jmO6VxEwml/qFgWegcvGv7WzyC1BA9lsZtz+TiGiaIOlFIraUqmgcpmq4aiMhw2EI7qdP31dmfvgm4WlUnIPy+PbZk+zuiEgjwIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm9N7Sv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm9N7Sv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19CC1F000E9;
	Tue, 21 Jul 2026 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660208;
	bh=8Dh46DyuLrD135+W3xQEGJRm+ePaIRbguLl7VznULEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gm9N7Sv2T0qqxTXm3cze0mWctMsSv6SvdFkpdH+ZI5px6uz9b+3dfujvg+WwWhoz+
	 /s65/5JI1zNGzOdo3nSHiNEcJ5s0LhxFHnXBl22BZH1Ra9bgqeLwnTjQ8kqohF2s1+
	 gronALNGK/LH2b8xkrcO9oVwg0L0/lelTSQiBnxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0893/2077] gpib: Fix inappropriate ioctl error return
Date: Tue, 21 Jul 2026 17:09:26 +0200
Message-ID: <20260721152613.879842338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 70ea440324e8c1a10837f721352f5bd469c85007 ]

The driver was returning -ENOTTY in the case the ioctl command
was not recognised. Change it to -EBADRQC.

Fixes: 9dde4559e939 ("staging: gpib: Add GPIB common core driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://patch.msgid.link/20260411102025.2000-3-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/common/gpib_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpib/common/gpib_os.c b/drivers/gpib/common/gpib_os.c
index 5909274ddc1226..7dca60488872f3 100644
--- a/drivers/gpib/common/gpib_os.c
+++ b/drivers/gpib/common/gpib_os.c
@@ -613,7 +613,7 @@ long ibioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	unsigned int minor = iminor(file_inode(filep));
 	struct gpib_board *board;
 	struct gpib_file_private *file_priv = filep->private_data;
-	long retval = -ENOTTY;
+	long retval = -EBADRQC;
 
 	if (minor >= GPIB_MAX_NUM_BOARDS) {
 		pr_err("gpib: invalid minor number of device file\n");
@@ -806,7 +806,6 @@ long ibioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		mutex_unlock(&board->big_gpib_mutex);
 		return write_ioctl(file_priv, board, arg);
 	default:
-		retval = -ENOTTY;
 		goto done;
 	}
 
-- 
2.53.0



