Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650693431F8;
	Fri,  9 Oct 2026 14:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556640; cv=none; b=eSpNH7AUl6+C4HnxEJWJJq2pfQ/39sxHD2AJSm0st1uubBZrsbJjlb+pFnf6ElaO8t2IZfoKQScp0jsto4kQ4ocCgTN/yLux1nmyv+J4r3EvJZAH89gkcxiFY0De/ltVVFls45e8pmG5jrknBZtYdStfac/3Hg/v7FoDljH292Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556640; c=relaxed/simple;
	bh=2JxYUxJSSc0O5ch9EvpOAozlQFfb+EnaVZp1YgrqQNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZUxFWSXYiIqL+T9waMw9LUXoJUqarmk+P3OzbbIWXuGvJDKtJAPcBurbgi2bVfDmocZS3/IHn2zFWx831Dws1JVoFqGgMf4hikURbOWdBmcKQwMU+XxcRNHqYewEko8Kug7O4YSutW0Li6KCJNy4g+zrdbmQmmRBOjPgcEnLVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aepykHfO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aepykHfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1C61F000FF;
	Fri,  9 Oct 2026 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556639;
	bh=Fa+EygRws6XZrdEZLwKGzrbCXlXP2XUZ4TOOkL4IEns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aepykHfOc4XXgxgvk2SmLHhf2LLKil38wiDowRdHL72fw0QeVB2vdNngwvfcaNoDd
	 akSPafZP3yL1Rk5YUyG5uwRfpKpObLYT5kWPm2fbnyUsbUBpXIEevdTe89kHhGoUii
	 PO//wrHVKhgFnFPYXbWmkBYFpNsVydR0GazmmVKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7.2 213/428] usb: ohci-spear: disable controller wakeup on removal
Date: Fri,  9 Oct 2026 16:09:10 +0200
Message-ID: <20261009140950.805555061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit b1b0f8bdbbc891a4ee7f3b1a878c633e02b7bbeb upstream.

Probe enables controller wakeup after the OHCI core marks controllers with
RemoteWakeupConnected as wakeup-capable. Removal does not undo this, so the
wakeup source can remain attached after driver unbind.

Disable controller wakeup after removing the HCD.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-4-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-spear.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -103,6 +103,7 @@ static void spear_ohci_hcd_drv_remove(st
 	struct spear_ohci *sohci_p = to_spear_ohci(hcd);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	clk_disable_unprepare(sohci_p->clk);
 
 	usb_put_hcd(hcd);


