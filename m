Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D61F893B;
	Tue,  3 Dec 2024 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242720; cv=none; b=qQAblhUrlqQKuR+rmREm4cARHUwBJQO05jY1cdzKLgl1V31hWOzDO68C6tCnUwUYFI3rN+RhVWkJXeaHqSTgCiGvzDk8m+S81NET9WbVDE8dyZV0g5NIgpcH3F1hG7pFMighTII2Om+CuyQQF0mDwQ+j8Us3CkYhyitS7tQtHdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242720; c=relaxed/simple;
	bh=4ykK0OD/Qagr0N8M1/KVxnhjHyqPVi2WlkEWRRhxpKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNrxB4kprdkZxmpjEEwaQsT3SF33m3rDwlaORggm0WhUCzqaZD0ff/u5t9myfBDSQANODKdsEkMQLgTX3a0cOnFUFyP52jp1O8Ud4IefmbqQUENBcJUwJsv7vN9xRDHTsbcwDjCgKMbeiF+m2jlKUoWzKBfT3bY8Oq7CPHUhucs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZaPB6Dz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZaPB6Dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B4EC4CECF;
	Tue,  3 Dec 2024 16:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242720;
	bh=4ykK0OD/Qagr0N8M1/KVxnhjHyqPVi2WlkEWRRhxpKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZaPB6DzVF1IGPznXQnjhUnoIZBJ3tx3imM5B1UnkC/LfFqeiRVyjd7o55k9CI+dZ
	 f7A/3ByJQexvMT2pbqmhT8/ixbHN0iWnbQbmHVQKgcQIdmL3HplNofIeOcBc2S1Bro
	 kwud3YndG8fQ5mOPfgA2MKXu/ueqxpuG7CeloGK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Subject: [PATCH 6.12 757/826] usb: misc: ljca: move usb_autopm_put_interface() after wait for response
Date: Tue,  3 Dec 2024 15:48:04 +0100
Message-ID: <20241203144813.294756968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

commit 5c5d8eb8af06df615e8b1dc88e5847196c846045 upstream.

Do not mark interface as ready to suspend when we are still waiting
for response messages from the device.

Fixes: acd6199f195d ("usb: Add support for Intel LJCA device")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com> # ThinkPad X1 Yoga Gen 8, ov2740
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://lore.kernel.org/r/20241112075514.680712-1-stanislaw.gruszka@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/usb-ljca.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/misc/usb-ljca.c
+++ b/drivers/usb/misc/usb-ljca.c
@@ -332,14 +332,11 @@ static int ljca_send(struct ljca_adapter
 
 	ret = usb_bulk_msg(adap->usb_dev, adap->tx_pipe, header,
 			   msg_len, &transferred, LJCA_WRITE_TIMEOUT_MS);
-
-	usb_autopm_put_interface(adap->intf);
-
 	if (ret < 0)
-		goto out;
+		goto out_put;
 	if (transferred != msg_len) {
 		ret = -EIO;
-		goto out;
+		goto out_put;
 	}
 
 	if (ack) {
@@ -347,11 +344,14 @@ static int ljca_send(struct ljca_adapter
 						  timeout);
 		if (!ret) {
 			ret = -ETIMEDOUT;
-			goto out;
+			goto out_put;
 		}
 	}
 	ret = adap->actual_length;
 
+out_put:
+	usb_autopm_put_interface(adap->intf);
+
 out:
 	spin_lock_irqsave(&adap->lock, flags);
 	adap->ex_buf = NULL;


