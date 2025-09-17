Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D821EB1AA;
	Wed, 17 Sep 2025 13:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114087; cv=none; b=K+AZlJfvWJbcaUhu8M+JceT6lwugZMJdrTOQ7XQeQE827gWu5eZlU0YmWpFtnmjwr4zTRvlIKS30qQ3NUwebDdT4rB6uifsD8u11HaqASSEF94ZzvFDa85ieZ8DjKu10LSWjnUmgosqWErMDC9SXkc9Rv7dYGU+Bq+G3o4yK5y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114087; c=relaxed/simple;
	bh=kmZMHegWoOdSKsyanf13qJpSFSaicZHr4B4JubP5lyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I223IM3NpDSsw5Q9/w8VDn8NyPdCx6hTV0eABaihQqNot96uo5t2xUeXvGNNUxNFaBoLNNcuHBb6X4tlWNV6YZcrlBNvcx8z0jAab+xRsMMPSgdwq9nY7QGIFeDgfgsRs6x+rbz442bujCIWmUuXW244hHS2WZSwxH2uv+m5BRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKI93X1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKI93X1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CABAFC4CEF0;
	Wed, 17 Sep 2025 13:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114087;
	bh=kmZMHegWoOdSKsyanf13qJpSFSaicZHr4B4JubP5lyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKI93X1hAWYw1eFkI5TDet4G+ZuPsGofI4uAbiWpdKZhi6qBl8WRWXd9jqYQqP3FD
	 9KDy2FOmW7pCyKcitL2wLcfZCjVbmfchrASYn4HXY1anMG4Wt3blB8+4X15Cei8Ili
	 QdE1OYpHe42PuOL3eW+V5IrAvbusUtfgikOBnJUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff LaBundy <jeff@labundy.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 43/78] Input: iqs7222 - avoid enabling unused interrupts
Date: Wed, 17 Sep 2025 14:35:04 +0200
Message-ID: <20250917123330.617569957@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff LaBundy <jeff@labundy.com>

commit c9ddc41cdd522f2db5d492eda3df8994d928be34 upstream.

If a proximity event node is defined so as to specify the wake-up
properties of the touch surface, the proximity event interrupt is
enabled unconditionally. This may result in unwanted interrupts.

Solve this problem by enabling the interrupt only if the event is
mapped to a key or switch code.

Signed-off-by: Jeff LaBundy <jeff@labundy.com>
Link: https://lore.kernel.org/r/aKJxxgEWpNaNcUaW@nixie71
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/iqs7222.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/misc/iqs7222.c
+++ b/drivers/input/misc/iqs7222.c
@@ -2038,6 +2038,9 @@ static int iqs7222_parse_chan(struct iqs
 		if (error)
 			return error;
 
+		if (!iqs7222->kp_type[chan_index][i])
+			continue;
+
 		if (!dev_desc->event_offset)
 			continue;
 


