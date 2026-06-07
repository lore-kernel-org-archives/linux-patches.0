Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3E94071DD;
	Sun,  7 Jun 2026 10:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829500; cv=none; b=cpHwmicBM1v140WmtwfOA1u/zuabrukyqffkTjxs2TqDwdPK8ZFAjEWg6ynSH7wKsCKz1YYjCVtiGhUSkAOkUgovcG5bKc2PuIXXzDmDi7v5gEeBu72WHgtzNqEqjaFbvnb9bsISWaHLoHC9Iewfkv/PvjlPaL3fQRk6+W81szI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829500; c=relaxed/simple;
	bh=NOLqIINH3Q1S3eIqSvOt/ybjqmNTXgWvnEHUmpB7XVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kuu7sNTSIlN1lY8e8+DzL7QRe3n770NAUpdablDy5yFbWYM04rLcxR1Zi1t29mOCraVURWqCgxEtxhYOvx3rX5aIJ4Oy0wcwczjHA0n6BM3ZaJt4tEh1kYGNWK/EF7a60ajAcfnh3OHLi+OPSb2kA7vzx5LZMHr3AL9KFZ4bWqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usJWR3N2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usJWR3N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003691F00898;
	Sun,  7 Jun 2026 10:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829499;
	bh=sYsomLQ6ZICr7krSg7tCJIbwAF0VwN4oa7J0LjY07QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usJWR3N2JJAAyVQSulJ+mk70vuBsDwsCP3/AdS1WmtPV8sbT8hFc1r16/TGGi4JN4
	 cBFIcL5WWW0hdgFoIFzgBJZccBZXMM8+oXCKGVOvi/Yk+OZO9kO8zuvr3eMb7f5gRp
	 ZIGCNUPG2MW1gdbJYrKn9ZuhRSfRzgt/eRW7ozvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 269/332] USB: serial: keyspan: fix missing indat transfer sanity check
Date: Sun,  7 Jun 2026 12:00:38 +0200
Message-ID: <20260607095737.916479576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ab8336a7e414f018430aa1af3a46944032f7ff96 upstream.

Add the missing sanity check on the size of usa49wg indat transfers to
avoid parsing stale or uninitialised slab data.

Fixes: 0ca1268e109a ("USB Serial Keyspan: add support for USA-49WG & USA-28XG")
Cc: stable@vger.kernel.org	# 2.6.23
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1187,6 +1187,10 @@ static void usa49wg_indat_callback(struc
 	len = 0;
 
 	while (i < urb->actual_length) {
+		if (urb->actual_length - i < 3) {
+			dev_warn_ratelimited(&urb->dev->dev, "malformed indat packet\n");
+			break;
+		}
 
 		/* Check port number from message */
 		if (data[i] >= serial->num_ports) {


