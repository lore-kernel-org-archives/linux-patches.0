Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E6879CD;
	Sat, 30 Dec 2023 12:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W00fvipq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44203C433C7;
	Sat, 30 Dec 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938217;
	bh=U8V6nVSjq+PcGPbumoRHKvKoiUuUa898r6VPJgjjzjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W00fvipqO+tAOmjytqmwtOvxE95/2ovwwS9Z1eBj1afEp4uX/su+G/SebN8Eux7ui
	 Nyij5dTu6XEFdhDH+xlERjiQRziID1H1Y0OKIif91CsCtQqKAAFi4S0oqf65e/KcDV
	 3BnNbatZ9O2elMsaR+/eie7hH2a5WLjHhwjf7EXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 071/112] Bluetooth: hci_event: Fix not checking if HCI_OP_INQUIRY has been sent
Date: Sat, 30 Dec 2023 11:59:44 +0000
Message-ID: <20231230115809.010897050@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 99e67d46e5ff3c7c901af6009edec72d3d363be8 upstream.

Before setting HCI_INQUIRY bit check if HCI_OP_INQUIRY was really sent
otherwise the controller maybe be generating invalid events or, more
likely, it is a result of fuzzing tools attempting to test the right
behavior of the stack when unexpected events are generated.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218151
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2301,7 +2301,8 @@ static void hci_cs_inquiry(struct hci_de
 		return;
 	}
 
-	set_bit(HCI_INQUIRY, &hdev->flags);
+	if (hci_sent_cmd_data(hdev, HCI_OP_INQUIRY))
+		set_bit(HCI_INQUIRY, &hdev->flags);
 }
 
 static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)


