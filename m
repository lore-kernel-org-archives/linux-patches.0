Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B677FFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04ECC433D2;
	Mon, 15 May 2023 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170648;
	bh=gfKhUyKw0CX2PeLVIE8ww3bHJUVtkPZriPj0BxQava8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7kIGSQXo3viZMaC3UysbInNKX0w6moQQIjPq+87/vQWcvK51B1NNEtKJhjsTDz3r
	 UGE+ZqJLr8UZ3P05Eq/BndYepe3VAfXuuAHe73K7qUtNKpfJEvkWu37eAkGDR6Qk1o
	 d4K7R3CQB/Vyhyd32/0wk0Dfc8nROP40zviWnulU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.1 180/239] HID: wacom: Set a default resolution for older tablets
Date: Mon, 15 May 2023 18:27:23 +0200
Message-Id: <20230515161727.065826484@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ping Cheng <pinglinux@gmail.com>

commit 08a46b4190d345544d04ce4fe2e1844b772b8535 upstream.

Some older tablets may not report physical maximum for X/Y
coordinates. Set a default to prevent undefined resolution.

Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Link: https://lore.kernel.org/r/20230409164229.29777-1-ping.cheng@wacom.com
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1895,6 +1895,7 @@ static void wacom_map_usage(struct input
 	int fmax = field->logical_maximum;
 	unsigned int equivalent_usage = wacom_equivalent_usage(usage->hid);
 	int resolution_code = code;
+	int resolution = hidinput_calc_abs_res(field, resolution_code);
 
 	if (equivalent_usage == HID_DG_TWIST) {
 		resolution_code = ABS_RZ;
@@ -1915,8 +1916,15 @@ static void wacom_map_usage(struct input
 	switch (type) {
 	case EV_ABS:
 		input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
-		input_abs_set_res(input, code,
-				  hidinput_calc_abs_res(field, resolution_code));
+
+		/* older tablet may miss physical usage */
+		if ((code == ABS_X || code == ABS_Y) && !resolution) {
+			resolution = WACOM_INTUOS_RES;
+			hid_warn(input,
+				 "Wacom usage (%d) missing resolution \n",
+				 code);
+		}
+		input_abs_set_res(input, code, resolution);
 		break;
 	case EV_KEY:
 	case EV_MSC:


