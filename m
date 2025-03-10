Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0422ACDC;
	Mon, 10 Mar 2025 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629519; cv=none; b=ns6dX+4POv1ZuTbHnxE04pt2+JjOG1vOe7P7fSYA9r1UrBTUiuIDRwWeNPVnVtNgcVH2TB6eyn/h1HIO08AGdmBg1Z07W1hzD5ix2bwUTOjXgOpc46SF2s91xEn2TDg3kUQStTnx6t7SJkI4qTeVeC5amE7qd9O/nl588W73XFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629519; c=relaxed/simple;
	bh=xeROoyAD/dPNP3BLHg3zgPqcCZlahC3H5VqXVaZ2Gn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnNQIe4yqhyGXKwPsZ7NFEGVVuI8XI5dNLeX3cW7yD7OOgTflileovftfWYBgM5I9S0jz3d5Nw53LhpkZKrynnV8Gg03P42lRitGD2lrEenhYv1Giat2KJ4U4Y41mxzPhbTnMF2espm81hp2SNqTIsL4ASIKckj2hAf3H75UksU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0kODoH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0kODoH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2212C4CEE5;
	Mon, 10 Mar 2025 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629519;
	bh=xeROoyAD/dPNP3BLHg3zgPqcCZlahC3H5VqXVaZ2Gn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0kODoH1muZu69Q/2DRGp9sovXU66rmQCn/DNnPsx0MN+Bk1PSxxHVnCPxP7Bm81g
	 VFY6xEnH3VmcMBGlSiPnukI/W/QSd6QDk7cU7y11ZAD40NmzkXpg9gPgMn5hRvZD2+
	 62k+GxMS2MH0RrLqclHKedlsDNHiMNOKiIUcVE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 5.15 281/620] usb: gadget: f_tcm: Decrement command ref count on cleanup
Date: Mon, 10 Mar 2025 18:02:07 +0100
Message-ID: <20250310170556.706046221@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 3b2a52e88ab0c9469eaadd4d4c8f57d072477820 upstream.

We submitted the command with TARGET_SCF_ACK_KREF, which requires
acknowledgment of command completion. If the command fails, make sure to
decrement the ref count.

Fixes: cff834c16d23 ("usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs")
Cc: stable@vger.kernel.org
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/3c667b4d9c8b0b580346a69ff53616b6a74cfea2.1733876548.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_tcm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -973,6 +973,7 @@ static void usbg_data_write_cmpl(struct
 	return;
 
 cleanup:
+	target_put_sess_cmd(se_cmd);
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 


