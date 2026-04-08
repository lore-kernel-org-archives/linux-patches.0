Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25A7355F30;
	Wed,  8 Apr 2026 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673973; cv=none; b=VhoeP2lXkZOH2g4ubXu/yJ/b9G+OnmWbkaaMY1jYbsSxG1bNpV21ley+j5TTdxOu7VoFPN/Q4Z2zcPqob++QC1cEIo8NI2SASixLn57KSWrh1rZfnbT/biCB3Hzdz28nur78bwEou/6Gokk/3PhHagInDqoVIz6gTlAs0E8g9uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673973; c=relaxed/simple;
	bh=cPq1VJwQJo223LVGVMNcGT5giIbuayXxT1SdtFcnjGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhPGW0/tA7c7ZhhCiecLVT9fp7ELZXYOb/oBkKNYRQlRUTZtWTl2Na1H4GzbTlANSUS1rJx14SdiktJlyUJIkSZIR52kKIv+PGg51QVnlQL1Caig+E4Ri4aGj8dwiS49ZGmIcpVM7SWnoACh51NfKnrfCyYHoKfqK505jRKsdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2omwCnbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2omwCnbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F17C19421;
	Wed,  8 Apr 2026 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673973;
	bh=cPq1VJwQJo223LVGVMNcGT5giIbuayXxT1SdtFcnjGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2omwCnbNmrwb45z5MF3diY60VLWR6V/to1yB7l1XTuliGP6twfphHg61WSHq7emwJ
	 CnregSyH6M3Jw0GKvW8OuvJXBpeUEMUux1X2qQ/Jvqzw0oq1JRPtPq01Snf21AXT6n
	 MsSTTMOSrdXS5H0UMSC/wajeHTKpgCaPQww6Wd9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 160/242] usb: ulpi: fix double free in ulpi_register_interface() error path
Date: Wed,  8 Apr 2026 20:03:20 +0200
Message-ID: <20260408175933.077452452@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 01af542392b5d41fd659d487015a71f627accce3 upstream.

When device_register() fails, ulpi_register() calls put_device() on
ulpi->dev.

The device release callback ulpi_dev_release() drops the OF node
reference and frees ulpi, but the current error path in
ulpi_register_interface() then calls kfree(ulpi) again, causing a
double free.

Let put_device() handle the cleanup through ulpi_dev_release() and
avoid freeing ulpi again in ulpi_register_interface().

Fixes: 289fcff4bcdb1 ("usb: add bus type for USB ULPI")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260401025142.1398996-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -331,10 +331,9 @@ struct ulpi *ulpi_register_interface(str
 	ulpi->ops = ops;
 
 	ret = ulpi_register(dev, ulpi);
-	if (ret) {
-		kfree(ulpi);
+	if (ret)
 		return ERR_PTR(ret);
-	}
+
 
 	return ulpi;
 }


