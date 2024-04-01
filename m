Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30C71CA8F;
	Mon,  1 Apr 2024 16:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987729; cv=none; b=gTgX552bbl3G7fGsv2WuDbBfAXgyfh6OXwAMHAY+38ZBJ1uYiWw9xv4O10ufdBUYagHX4wVrjzpuOEcm4K9rrqNL8wVnHMWH+qZkKyplcfhEOhUVxitWOsD2B1WAIdvvK09M1buCn9WNU5D/y1ZQ9yZokRapZb1obQiz6ef8LdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987729; c=relaxed/simple;
	bh=Ny/gUgl22oRPBQrE6gVVevWb1aLLeF5pDuy0DlHebB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/waNag7OmgHGydABqW0kF0KdutbrWdofOFQcf6BSBBFq6Fe1W/4kptxz29Oil6SUPQ9iZ+fi8XG56qBoLxgSbRL1+AEpGt1qOXnDJZrz4+4M7SCdM9daAhq1UGs9sBZNFrjcGwvmRfSlSmjudL/Ie2fWQsXbvqm6U6W81a1GXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1AN62Sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1AN62Sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FD7C433F1;
	Mon,  1 Apr 2024 16:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987729;
	bh=Ny/gUgl22oRPBQrE6gVVevWb1aLLeF5pDuy0DlHebB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1AN62SfRHfHlyrrjhNRTIAmK6SJlzzv/BaVEcGerWygYElj3bLhiE8T2AtgtJmpp
	 nj9w81iHdRagqS9ym0t3YUSRzrXJzZMrqyxv6Zryadv2vRCpagBNW3c90kRaGaMGiz
	 i3nDuWL9VC5K7tbOdPq1raNAv41jKlDUbeMxAOek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.8 374/399] usb: typec: ucsi: Ack unsupported commands
Date: Mon,  1 Apr 2024 17:45:40 +0200
Message-ID: <20240401152600.343309330@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


