Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FC415CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370A8C433C1;
	Tue,  8 Nov 2022 13:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915006;
	bh=tyIC0wcs6zPNRtp6ePZpHvT/LTfKctnrsaUe1ftP+po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FF1CFhli7bGdFXGIukZsWnmDR0xIZHvLjif52D8TEO/du5vFUUNKupJ9SpdWm0peR
	 XAPbe9GNtlQ1QnMYL7Nbqw/rmYpPcuMYW8RxSQqjNPRzcKAtt7rmtEge0spTTOY2be
	 dkb5lPuu7Dnc+RhTJhJPnJRbhXaKPpDYRRwBmYTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tam=C3=A1s=20Koczka?= <poprdi@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>
Subject: [PATCH 4.14 23/40] Bluetooth: L2CAP: Fix attempting to access uninitialized memory
Date: Tue,  8 Nov 2022 14:39:08 +0100
Message-Id: <20221108133329.262281478@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit b1a2cd50c0357f243b7435a732b4e62ba3157a2e upstream.

On l2cap_parse_conf_req the variable efs is only initialized if
remote_efs has been set.

CVE: CVE-2022-42895
CC: stable@vger.kernel.org
Reported-by: Tamás Koczka <poprdi@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Reviewed-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -3551,7 +3551,8 @@ done:
 			l2cap_add_conf_opt(&ptr, L2CAP_CONF_RFC,
 					   sizeof(rfc), (unsigned long) &rfc, endptr - ptr);
 
-			if (test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
+			if (remote_efs &&
+			    test_bit(FLAG_EFS_ENABLE, &chan->flags)) {
 				chan->remote_id = efs.id;
 				chan->remote_stype = efs.stype;
 				chan->remote_msdu = le16_to_cpu(efs.msdu);


