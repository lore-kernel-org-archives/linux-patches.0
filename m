Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE861E525;
	Mon,  1 Apr 2024 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989194; cv=none; b=TDtx5L5CnyY1RjP4MWMT352NPsPt3XlCQYK3NtI4hd3xUVbAnXmxVDFEE+LzT8/K9Z3gFep+hkLEJtuhzXhrC8MA9pyGHiVixMXA5zrEMxp/w9odyarmEyGF4Z7q5H3tkSLsRIEkaKkLI+ExTYGM7ClLLRUWRysvSMlGDvo1Qo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989194; c=relaxed/simple;
	bh=aYOT7aaKDngBiO3B34/RNDjIb7+hsh3jbFpKs/m3f94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB7Yuo7coO5kfMbct0NUTAwpuu6+At5+EsLDiaBvIkqFGw+0s3f6xuY7JYGQEbwK2rdJy9QOcpw1vYabn+v2otuCO7znluC7rEoxOOzx0pqb4GiT50OpxFsu5FIePEP900mX+RDCpNBn6ZbP93XS6ajJVpIUjHlBH5DjA4+BXHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hy2u0KUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hy2u0KUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5D6C433C7;
	Mon,  1 Apr 2024 16:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989193;
	bh=aYOT7aaKDngBiO3B34/RNDjIb7+hsh3jbFpKs/m3f94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hy2u0KUp0HZkOkluzepdHKbtSjmSm7z6HZhWfK9Fdpo0706Y4UrZX96l1UXenhMMb
	 o8RmiquorqsnLLdoP2nu2NhLmY8pirrYyIWT2PDsMDIbicZNYZxj0WrwenWQsr15Wz
	 iaRoq9XP3eaQ9IbaaJ6PtYsC8P/V2AX+kFeviD10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.7 409/432] usb: typec: ucsi: Ack unsupported commands
Date: Mon,  1 Apr 2024 17:46:36 +0200
Message-ID: <20240401152605.585538835@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 6b5c85ddeea77d18c4b69e3bda60e9374a20c304 upstream.

If a command completes the OPM must send an ack. This applies
to unsupported commands, too.

Send the required ACK for unsupported commands.

Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-4-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -138,8 +138,12 @@ static int ucsi_exec_command(struct ucsi
 	if (!(cci & UCSI_CCI_COMMAND_COMPLETE))
 		return -EIO;
 
-	if (cci & UCSI_CCI_NOT_SUPPORTED)
+	if (cci & UCSI_CCI_NOT_SUPPORTED) {
+		if (ucsi_acknowledge_command(ucsi) < 0)
+			dev_err(ucsi->dev,
+				"ACK of unsupported command failed\n");
 		return -EOPNOTSUPP;
+	}
 
 	if (cci & UCSI_CCI_ERROR) {
 		if (cmd == UCSI_GET_ERROR_STATUS)


