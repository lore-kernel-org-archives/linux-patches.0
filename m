Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B342EB0B;
	Mon,  1 Apr 2024 16:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990505; cv=none; b=Bt37FlxmcusOM0GF+m5DFQihsCkUrlQUqJrfD2Ku31uQN/WMkFfsWXHI8LlZOp2lcs4ZI3sLAqQHMptceZu5AS0wiYUm7fe8oegJyJUK8u9SztCwQ9B0+Vy3laOGMngRq97bt1q/yzygxOihd/mgYcpHOLXbTj36N8Dj0CvUHFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990505; c=relaxed/simple;
	bh=Vm3UKEXSKE5mg7PG/MlhPhP5ELcjXaFVO1ZQAszMdzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQodE6pCSk+5U3DbyypAboN4LJ3eCSzXutOo6Ox/kJnemk9K5mTdFKdoAVD5wtP+UUgSW2851aAzzgQOOlLw/ukRQuZl584D0N4JchgFOTqbkqYMXhO6+aAFCx8+HcXR3HPCigJQvfZkfYbQ7CAwHCF9vh6H8i2ggtPyTDXRMM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfG/eDKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfG/eDKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F78EC43390;
	Mon,  1 Apr 2024 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990504;
	bh=Vm3UKEXSKE5mg7PG/MlhPhP5ELcjXaFVO1ZQAszMdzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfG/eDKbN1A8B4dpVs54yIwj7T05KpBtaNWIPkw93USoqwRM0uvI1oibdyclN2aR6
	 tMdnaeUG1ZLstY0QGUkASjgbC3rKuVtfLqmhHBOxGLHrsBstIXOQPKQvp0YEqNsFVZ
	 FElj0eNWE8e2pnLB3JH4ENW9PejW9lAdU2mj7+UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 375/396] usb: typec: ucsi: Ack unsupported commands
Date: Mon,  1 Apr 2024 17:47:04 +0200
Message-ID: <20240401152559.093928634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


