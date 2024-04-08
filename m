Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2229745D6;
	Mon,  8 Apr 2024 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584889; cv=none; b=UgYATvVkW8wDAnHJgOyFRPjG7W1/I0qhytSLSkYUPXG4MJoevZ8g3vgYM4ynDK37PZJU5fEIIldqURMQqLxCUh3D77nSiW27PAwkitqaa8OM++kHObrbYQ6Ti4UiRTcxBdKh4LM8Jr+1dINUG82eIlPlrUo1iIsGk9+JPjVFAnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584889; c=relaxed/simple;
	bh=jbyJmQQRvfKC9YTa9aQ3t/LbVDPl9wqB0COth/jJ42E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mE3EchJuL5OeBrTrGPh+DZOqpAIEfFv6KeW1oR0eVpquJq2Ae00yXMvQozVuLUntupxCvtImLLdFVKdwSecWoducKAFb+c0up6QYREO+RcgVSt6LAwsdodvHgziG16ACuG5e/dNAkNufU7+9yMHdtQZXL0DbN8/86GGYX/++sZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+a+hsVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+a+hsVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6192CC433F1;
	Mon,  8 Apr 2024 14:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584888;
	bh=jbyJmQQRvfKC9YTa9aQ3t/LbVDPl9wqB0COth/jJ42E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+a+hsVOvidUFt7GLr7CyG7VjKtXiNrdkc47poQCkCNKJg+e1wZGkiT5Otxux8lbi
	 TBTdMsI4cmCmRLrw+fo/iaZptPeYrjvU2oL70wFxVywK8ASU399BL5XLB5Z1SNb4gr
	 z9IfSfD1/u9fpp2qyyOg0R7CcE0n/SKG9Xj3eMjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 592/690] usb: typec: ucsi: Ack unsupported commands
Date: Mon,  8 Apr 2024 14:57:38 +0200
Message-ID: <20240408125421.032129766@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


