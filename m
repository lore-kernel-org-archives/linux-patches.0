Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19C1155389;
	Tue,  6 Jan 2026 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720652; cv=none; b=C50UxEpSoqYPhPpFUK8AqWovcunrXZaZwuAu8jXBFwWTRD0Ha32VnnUfeYQ6D8QUggsPQRMv1oOAqOc5ysGjv/O/hPuxIkLGX/LhMGw87RvgWxgmZt9dRzuxjnNxPBaquoRGoIBsulNDYb+nbqY4vCPry/7p5hM1Lg1HZLEX5Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720652; c=relaxed/simple;
	bh=i2GW2IuTj0+UzuG+V8KkSch3qnEn8ipOQRpuDG4DW/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bllL255fauvyqoZ+UmapM65w8+nUZLmisl7vfiOrb3WjpEOJGgp3+X9eso/w6BiDF5T1+LdFPyOYZ06Vaz0k8TDM9FLjgTgLnY0YF4G9u5sjzdzJgTP+bMq5iAwgrYjWz7Tfl9sfrkW4Iqdcql5a3W1lfq7kH3zRvMS84BA177o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD6TqYyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD6TqYyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41520C116C6;
	Tue,  6 Jan 2026 17:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720652;
	bh=i2GW2IuTj0+UzuG+V8KkSch3qnEn8ipOQRpuDG4DW/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AD6TqYyX4AUgUlhs2xGFIxTakxoioEEuJ8y9DwUQXsSrCvySllN6oDCPsqJhTDFaT
	 3qNJAPEomNc3/ZV5UWuBOWYi40ZySq0ZB0gKqIs0yKQLqmrE1a6SLAHsvQZ2cwAm1h
	 KfyQQKeysjaWxA65uTb9R0RivcqVeaxheE1zZ5s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Vazquez <brianvv@google.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 301/567] idpf: reduce mbx_task schedule delay to 300us
Date: Tue,  6 Jan 2026 18:01:23 +0100
Message-ID: <20260106170502.467532142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit b3d6bbae1d6d5638a4ab702ab195476787cde857 ]

During the IDPF init phase, the mailbox runs in poll mode until it is
configured to properly handle interrupts. The previous delay of 300ms is
excessively long for the mailbox polling mechanism, which causes a slow
initialization of ~2s:

echo 0000:06:12.4 > /sys/bus/pci/drivers/idpf/bind

[   52.444239] idpf 0000:06:12.4: enabling device (0000 -> 0002)
[   52.485005] idpf 0000:06:12.4: Device HW Reset initiated
[   54.177181] idpf 0000:06:12.4: PTP init failed, err=-EOPNOTSUPP
[   54.206177] idpf 0000:06:12.4: Minimum RX descriptor support not provided, using the default
[   54.206182] idpf 0000:06:12.4: Minimum TX descriptor support not provided, using the default

Changing the delay to 300us avoids the delays during the initial mailbox
transactions, making the init phase much faster:

[   83.342590] idpf 0000:06:12.4: enabling device (0000 -> 0002)
[   83.384402] idpf 0000:06:12.4: Device HW Reset initiated
[   83.518323] idpf 0000:06:12.4: PTP init failed, err=-EOPNOTSUPP
[   83.547430] idpf 0000:06:12.4: Minimum RX descriptor support not provided, using the default
[   83.547435] idpf 0000:06:12.4: Minimum TX descriptor support not provided, using the default

Fixes: 4930fbf419a7 ("idpf: add core init and interrupt request")
Signed-off-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 371fc5052420..173ddc248867 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1214,7 +1214,7 @@ void idpf_mbx_task(struct work_struct *work)
 		idpf_mb_irq_enable(adapter);
 	else
 		queue_delayed_work(adapter->mbx_wq, &adapter->mbx_task,
-				   msecs_to_jiffies(300));
+				   usecs_to_jiffies(300));
 
 	idpf_recv_mb_msg(adapter);
 }
-- 
2.51.0



