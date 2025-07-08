Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586C21773D;
	Tue,  8 Jul 2025 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992563; cv=none; b=OFBdqvq1bLnXOTz4fqaQ6lNmXwdRhwyUCKCRSP+k520TCGPTXsg5hVE1Bb/1oUL7eR12HpAW8/h7defnrZrU7dDTqwC8uc41URv8Y8VtelNsIW2bW74KQf8bOuXo0mo6K968nyBAL8cDmEYaKzpQQmaDO3XuJQqg6qp5G6haIL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992563; c=relaxed/simple;
	bh=z2vjuRg7xBR0Nt2yoNb95A0M//iwoHHhMt8h8TeoNoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uvn6JoPuadbClJOd6gvp+2GU0sJeasHmVbYI2PwVWOOYkV5L+LH/7nKLCiM5+RwqpmHJFAMKlECJcRK/2y+miffAlc4EIfX0IKfsRqRX0DXM4IuwZjApgBCDYOCEhD9ezTkiD4DqNf4Y7FMdkxR/xlD7DvWL9atjkaELuGFLZe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtB+otFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtB+otFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C4DC4CEED;
	Tue,  8 Jul 2025 16:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992563;
	bh=z2vjuRg7xBR0Nt2yoNb95A0M//iwoHHhMt8h8TeoNoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtB+otFS0LOL81p9pl1jhBfWhfG6P5L/3KcEWzU68ue3yqE5MdcRXjZVoWe4spvDX
	 VUNBKTMEEGgmFv6ATD55TGmTy2QN0k8qlnr+Z/PB6KcX9wBi2aTKhY/1FekJieBg59
	 1pmg8RePWFR9GZ3MvPxFbOZxgQgawyddlmgSr6M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.6 112/132] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue,  8 Jul 2025 18:23:43 +0200
Message-ID: <20250708162233.854211533@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -313,7 +313,8 @@ int xhci_plat_probe(struct platform_devi
 	}
 
 	usb3_hcd = xhci_get_usb3_hcd(xhci);
-	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		usb3_hcd->can_do_streams = 1;
 
 	if (xhci->shared_hcd) {


