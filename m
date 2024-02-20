Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D8914A4E2;
	Tue, 20 Feb 2024 21:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462836; cv=none; b=X9lQQKjK3Ccm9fMx6ThPhfonrCRzgzvTWCEekfcqbNdkRO5k7eCIxFHX6ViWD9WF1uQtEOc7YBtP2zA+agTX8s2lLUmrElrBGG0Bko1tyzA2CzGta9TbqB6Z4JCoRkHMW/yXrzD7kApKDQ/z9X2gP/HyNVnEEdcP9HXkzjaVdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462836; c=relaxed/simple;
	bh=bDJvdAlQ+++xJ5D2HQ2dF05zhzE78hPO6YtHH6KGuoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaRCD2GsyVSiaGX6Dm1WF8DrcDUmhqzXZE0zro5YXvAKunwYEprxBKPDSGXCWjuzKOX4tE8q1jq3cFNLnsuHwF/TVXxioyQxl+56cE0WhEP/iPm05AcDxrIB1xHnb/DrscEdscO2+NEry03868M52R0a3is/BimP29vahfvdjtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Oam2SED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Oam2SED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DDFC433F1;
	Tue, 20 Feb 2024 21:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462835;
	bh=bDJvdAlQ+++xJ5D2HQ2dF05zhzE78hPO6YtHH6KGuoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Oam2SEDNX8QxNIaj997JvWPIvkvSC3FpZsJQ58LDkRtake6SQVef/waa4UzD1bxb
	 yUB8SHrs8TulNcNUXG0uhYSyvrYK7Uei/m+bvSMldZMptA5l7/UDjm77TBKeNzaafY
	 OhgvczMwVUrjYTQIbIIqwjDP4PGOvGcbnLP7CXXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	yuan linyu <yuanlinyu@hihonor.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 052/197] usb: f_mass_storage: forbid async queue when shutdown happen
Date: Tue, 20 Feb 2024 21:50:11 +0100
Message-ID: <20240220204842.637628694@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yuan linyu <yuanlinyu@hihonor.com>

commit b2d2d7ea0dd09802cf5a0545bf54d8ad8987d20c upstream.

When write UDC to empty and unbind gadget driver from gadget device, it is
possible that there are many queue failures for mass storage function.

The root cause is mass storage main thread alaways try to queue request to
receive a command from host if running flag is on, on platform like dwc3,
if pull down called, it will not queue request again and return
-ESHUTDOWN, but it not affect running flag of mass storage function.

Check return code from mass storage function and clear running flag if it
is -ESHUTDOWN, also indicate start in/out transfer failure to break loops.

Cc: stable <stable@kernel.org>
Signed-off-by: yuan linyu <yuanlinyu@hihonor.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20240123034829.3848409-1-yuanlinyu@hihonor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_mass_storage.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -544,21 +544,37 @@ static int start_transfer(struct fsg_dev
 
 static bool start_in_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
 {
+	int rc;
+
 	if (!fsg_is_set(common))
 		return false;
 	bh->state = BUF_STATE_SENDING;
-	if (start_transfer(common->fsg, common->fsg->bulk_in, bh->inreq))
+	rc = start_transfer(common->fsg, common->fsg->bulk_in, bh->inreq);
+	if (rc) {
 		bh->state = BUF_STATE_EMPTY;
+		if (rc == -ESHUTDOWN) {
+			common->running = 0;
+			return false;
+		}
+	}
 	return true;
 }
 
 static bool start_out_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
 {
+	int rc;
+
 	if (!fsg_is_set(common))
 		return false;
 	bh->state = BUF_STATE_RECEIVING;
-	if (start_transfer(common->fsg, common->fsg->bulk_out, bh->outreq))
+	rc = start_transfer(common->fsg, common->fsg->bulk_out, bh->outreq);
+	if (rc) {
 		bh->state = BUF_STATE_FULL;
+		if (rc == -ESHUTDOWN) {
+			common->running = 0;
+			return false;
+		}
+	}
 	return true;
 }
 


