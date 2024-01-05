Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA9618EB7;
	Fri,  5 Jan 2024 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykx42Hpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B53C433C7;
	Fri,  5 Jan 2024 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465849;
	bh=AAdHMIbYi9v0BWaWKn/2OhHaBDFPftvWCyEQSe4fAdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykx42Hpdj/2QsGSWvJVI2Pz2qo+O9PDC2iEtaqIqYC75bBBdpkZJ7I6oLidPOIG5h
	 gGCAENykIa2fa5uRKSGGy9HRsm8dT7S3fnSQhn4TnrTsisLeEb67EkVHmcjTZCZSWy
	 /MhT4V6Yy3wQXo4/aBFqtmu+8iCTFo1icvWabPso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 38/47] Bluetooth: hci_event: Fix not checking if HCI_OP_INQUIRY has been sent
Date: Fri,  5 Jan 2024 15:39:25 +0100
Message-ID: <20240105143817.083242186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1785,7 +1785,8 @@ static void hci_cs_inquiry(struct hci_de
 		return;
 	}
 
-	set_bit(HCI_INQUIRY, &hdev->flags);
+	if (hci_sent_cmd_data(hdev, HCI_OP_INQUIRY))
+		set_bit(HCI_INQUIRY, &hdev->flags);
 }
 
 static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)


