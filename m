Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E86115CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7346CC4347C;
	Tue,  8 Nov 2022 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915243;
	bh=tyIC0wcs6zPNRtp6ePZpHvT/LTfKctnrsaUe1ftP+po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwrbOhAbaMaWfHqUbi7H87EQQdT1mED55TYvuh+R4OgCJRouccjdMtcyLppEfZYdD
	 f52WzKTWpnfEeFhTiMhhCY8zrnI/Kvt7YQ4DvhrR+BD/GQEN5kieg+6Ft/eEln0Rxg
	 66LUlmN3rTnxpkqgCjzt9ejTS2GInuX2z5aWphyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tam=C3=A1s=20Koczka?= <poprdi@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Tedd Ho-Jeong An <tedd.an@intel.com>
Subject: [PATCH 4.19 30/48] Bluetooth: L2CAP: Fix attempting to access uninitialized memory
Date: Tue,  8 Nov 2022 14:39:15 +0100
Message-Id: <20221108133330.588041675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
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


