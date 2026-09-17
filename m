Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4184D1798;
	Thu, 17 Sep 2026 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671348; cv=none; b=ZkB5R+Jtn3ynkCN567REeDJWz8ctTcKxgIBsqqJOltap0WNsY3civVzEBZZdvTOCKNDIXurArawVuQj+J0tnNfGc513dLrJpQWGUXfKZqhV/giiqOT2X7dRsdEKCxzM040UK5oLSiH774LI9f2ZYxVfnkZaKM42AfW0OcsHg+1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671348; c=relaxed/simple;
	bh=D29xyfgHM/0RcNKvgLI8Nk8yM5CVy8SIVorjda0S0dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBhNsrG8uTPgmuvrLTdR+qHOXB/MS0cJbjX5cj/QIbsFOCR5BdhaaG84e20hoT+/laOWbc230v60+C+CV9Wncq/mTgI+aevu1DLdmCMXiQYj06p+d3dE37gRaInYAfOPMAVHgT2y59NKNT+Z+cTZQTU0rPOryoecb9hbV5KyYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unGCcwOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unGCcwOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3373F1F000FF;
	Thu, 17 Sep 2026 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671346;
	bh=0+p+S4d+2/Tvc3Yxgl1OxzJf0ZxcVuu3U0iWR4XyLok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unGCcwOL2KRTBxZfeXYB21+PY2NtGlhobZKlEYrU0Ids1HSn9c/AKLyMa7DWbU4dg
	 nQCQYI8TOIFRVLbu+cgoCedpMhlNUDTKJyzCJxqXPdDYkh+gMCzpJBEuwUqHRGwwcB
	 AXlg/rzZjQT9mffmrw14Exj7nC5DzXIM+3co5gA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Ebner <manuelebner@mailbox.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0946/1102] usb: serial: spcp8x5: dont store usb_device_id
Date: Thu, 17 Sep 2026 16:14:49 +0100
Message-ID: <20260917151604.401741573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit 934e1322f18c1b58bca431c0d5d01e002060c990 ]

USB probe functions should not keep usb_device_id for longer than probe due
to presence of dynamic ID removal. USB serial does not support ID removal,
however in this case only driver_data is ever needed, there is no reason
keeping the usb_device_id in the first place, so convert it as well.

Reviewed-by: Manuel Ebner <manuelebner@mailbox.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-3-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/spcp8x5.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index aa8fe0dcb680e..8418d812eb3cd 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -135,14 +135,14 @@ struct spcp8x5_private {
 static int spcp8x5_probe(struct usb_serial *serial,
 						const struct usb_device_id *id)
 {
-	usb_set_serial_data(serial, (void *)id);
+	usb_set_serial_data(serial, (void *)id->driver_info);
 
 	return 0;
 }
 
 static int spcp8x5_port_probe(struct usb_serial_port *port)
 {
-	const struct usb_device_id *id = usb_get_serial_data(port->serial);
+	unsigned int quirks = (unsigned int)(unsigned long)usb_get_serial_data(port->serial);
 	struct spcp8x5_private *priv;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -150,7 +150,7 @@ static int spcp8x5_port_probe(struct usb_serial_port *port)
 		return -ENOMEM;
 
 	spin_lock_init(&priv->lock);
-	priv->quirks = id->driver_info;
+	priv->quirks = quirks;
 
 	usb_set_serial_port_data(port, priv);
 
-- 
2.53.0



