Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB791FE47B;
	Sun,  7 Jun 2026 10:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828387; cv=none; b=Zi6ydEObUh+TFMcBY4jdacWcHNFTQr17au9LP8CrumaJyExzq62051hlvJXn3xyCcKNVuVcTcVqg5N2/eU3y2ThZT/2nHHXyNoTzosBKhH7hjrPeLpiAAs7Dtl+weC3pEn+TK5snG3lJDfY+i2POIROga2k/Jnaf5BUUt5BQ++s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828387; c=relaxed/simple;
	bh=CPfO1YXpoarM/0o2YTRpEXLxpE6bu6+jkGOrlyrcRr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNpetE2b0cpuxg/H2nxFpPNGFRKr3aiXcQOn+A7lwV8+NX5xY9jb7gkxKMjgYzeqTc/UrAP9WizTc8OP5u1R3qB064xd6N7n6HWdi/wWjMZbCSW337qtP1Ggj6B8ySq/VBZkSnqxqXRnJZGDq9Q4SwaM7TsST5bTtVYHHWPQ6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qep0im1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qep0im1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51191F00893;
	Sun,  7 Jun 2026 10:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828386;
	bh=zg+nI6ySUPHw4ov00TZob81T+Ej+zav0Ec5Gmoh5USU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qep0im1GMLuE9DMtpe113VLZaD3WSLS/L9R93BDTTKxFl01fVOdNpKzqa8+Kvi4qZ
	 +oa6fU6T9yPFkoH//tXR/jbhL0+XhwTkM6biEqVKGk0UT7cOQFCwa8mPqPIpFRvMuX
	 G7pjSQtb99JNQYgRyUkZYB65cQdq0xeYP2IydXmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Nathan Rebello <nathan.c.rebello@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Pooja Katiyar <pooja.katiyar@intel.com>,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	Abel Vesa <abelvesa@kernel.org>,
	stable <stable@kernel.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>
Subject: [PATCH 6.12 134/307] usb: typec: ucsi: validate connector number in ucsi_connector_change()
Date: Sun,  7 Jun 2026 11:58:51 +0200
Message-ID: <20260607095732.670025908@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 288a81a8507052bcfbf884d39a463c44c42c5fd9 upstream.

The connector number in a UCSI CCI notification is a 7-bit field
supplied by the PPM.  ucsi_connector_change() uses it to index the
ucsi->connector[] array without checking it against the number of
connectors the PPM reported at init time, so a buggy or malicious PPM
(EC firmware, or an I2C-attached UCSI controller on the ccg / stm32g0 /
glink transports) can drive schedule_work() on memory past the end of
the array.

Reject connector numbers that are zero or exceed cap.num_connectors
before dereferencing the array.

Assisted-by: gkh_clanker_t1000
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Benson Leung <bleung@chromium.org>
Cc: Jameson Thies <jthies@google.com>
Cc: Nathan Rebello <nathan.c.rebello@gmail.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Pooja Katiyar <pooja.katiyar@intel.com>
Cc: Hsin-Te Yuan <yuanhsinte@chromium.org>
Cc: Abel Vesa <abelvesa@kernel.org>
Cc: stable <stable@kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/2026051351-truck-steadfast-df48@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1290,13 +1290,22 @@ out_unlock:
  */
 void ucsi_connector_change(struct ucsi *ucsi, u8 num)
 {
-	struct ucsi_connector *con = &ucsi->connector[num - 1];
+	struct ucsi_connector *con;
 
 	if (!(ucsi->ntfy & UCSI_ENABLE_NTFY_CONNECTOR_CHANGE)) {
 		dev_dbg(ucsi->dev, "Early connector change event\n");
 		return;
 	}
 
+	if (!num || num > ucsi->cap.num_connectors) {
+		dev_warn_ratelimited(ucsi->dev,
+				     "Bogus connector change on %u (max %u)\n",
+				     num, ucsi->cap.num_connectors);
+		return;
+	}
+
+	con = &ucsi->connector[num - 1];
+
 	if (!test_and_set_bit(EVENT_PENDING, &ucsi->flags))
 		schedule_work(&con->work);
 }


