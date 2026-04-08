Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1426B3DA7DA;
	Wed,  8 Apr 2026 19:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674944; cv=none; b=ubQunaT8t7knxzSlmyw180SX4Dogz0TE+MlOYkImqbfTYye5S23Ubmvbl+DggD83ThrdvSYrySZ/PijAf6IGjksn77MY1kz38yvMKscjHNz/iekfVCfqgA3ovX5fxiEshJfvnXKsuTd7VRE1G/7HghAznOA1P101N4uEBZzzbjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674944; c=relaxed/simple;
	bh=sLh7Z2hVTA/lC7vPsSCcPNpwSHE3VOQU+xdF0zatF/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rU/ePB+xtYvFmwnCSMIAMAV4/8yBUKU3t/M5drvEeJpQfm+GZ1OL8sPRw9sYHU6Ke4NJOtZ6K+DvKwCxME0W34d5SoHOf+XqQu8FY7vd2ol5qUwNLxBLaPuZCILgX+zfWetPVc1CKs3zurgVgcRRY7PrBfq5rCZMeD1swiRQNRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOVLEujK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOVLEujK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3188CC2BC87;
	Wed,  8 Apr 2026 19:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674943;
	bh=sLh7Z2hVTA/lC7vPsSCcPNpwSHE3VOQU+xdF0zatF/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HOVLEujKezRgbsJMkRfppwEAYmkPqMFVImKcOWzNKhE33wiUehZOeock730SBeR97
	 GjJaGKzADQ+YDFdY6Zdv1lfBCvOPrZmtPHhZhdM9CyUgS3Q41mVYfqw53w1exlVW+l
	 SDxZ8582niReTL+c7na77UG/3VLbvBU+4VXPJa4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Nathan Rebello <nathan.c.rebello@gmail.com>
Subject: [PATCH 6.19 294/311] usb: typec: ucsi: validate connector number in ucsi_notify_common()
Date: Wed,  8 Apr 2026 20:04:54 +0200
Message-ID: <20260408175950.354119499@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Rebello <nathan.c.rebello@gmail.com>

commit d2d8c17ac01a1b1f638ea5d340a884ccc5015186 upstream.

The connector number extracted from CCI via UCSI_CCI_CONNECTOR() is a
7-bit field (0-127) that is used to index into the connector array in
ucsi_connector_change(). However, the array is only allocated for the
number of connectors reported by the device (typically 2-4 entries).

A malicious or malfunctioning device could report an out-of-range
connector number in the CCI, causing an out-of-bounds array access in
ucsi_connector_change().

Add a bounds check in ucsi_notify_common(), the central point where CCI
is parsed after arriving from hardware, so that bogus connector numbers
are rejected before they propagate further.

Fixes: bdc62f2bae8f ("usb: typec: ucsi: Simplified registration and I/O API")
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Nathan Rebello <nathan.c.rebello@gmail.com>
Link: https://patch.msgid.link/20260313222453.123-1-nathan.c.rebello@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -42,8 +42,13 @@ void ucsi_notify_common(struct ucsi *ucs
 	if (cci & UCSI_CCI_BUSY)
 		return;
 
-	if (UCSI_CCI_CONNECTOR(cci))
-		ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
+	if (UCSI_CCI_CONNECTOR(cci)) {
+		if (UCSI_CCI_CONNECTOR(cci) <= ucsi->cap.num_connectors)
+			ucsi_connector_change(ucsi, UCSI_CCI_CONNECTOR(cci));
+		else
+			dev_err(ucsi->dev, "bogus connector number in CCI: %lu\n",
+				UCSI_CCI_CONNECTOR(cci));
+	}
 
 	if (cci & UCSI_CCI_ACK_COMPLETE &&
 	    test_and_clear_bit(ACK_PENDING, &ucsi->flags))


