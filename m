Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AB378D8C;
	Mon,  4 May 2026 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903655; cv=none; b=idM4lAMntt6QaQK2QX2yXT/Ms4P9XP8JrJx6lJWxyFe80B2Z0o2pz5YiL5mHZxS33RU2tMphGcoCQ83+oeNUT44Xjt9wVQvf1uf6Z2JjeSgWz9jd/CZsNJx7kImywOaM4dRSIXX3sebj76jTdG7mfWLsJtOscLy8CzLfpbvCKEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903655; c=relaxed/simple;
	bh=keQ1hEtgWFdr5nKhlKcCLDT+M2ivk7stleKrxDeEhdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXigbCpbjplM1dk7w8+xNTVtKVlLJEaPaYqgv0BZxGpgq2RbjpB3gVuNEBL0tf/R17MtHrELo/iOgIqevChwG1YQsBCnrSpGNe9g/2O61O2vTN2M18g0CxjIPEbQs41yNG5Rv5Le8qx65UuPHKqIiaOlUSFWBNwdrV+/Hp3nNgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hK1ivCy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hK1ivCy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952A5C2BCB8;
	Mon,  4 May 2026 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903654;
	bh=keQ1hEtgWFdr5nKhlKcCLDT+M2ivk7stleKrxDeEhdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hK1ivCy1DDzq2ISIlXWbqibZOmT7TcCb57mAUKcRkZyZyRY1DG/BZugd2YXyANoaC
	 c3GJWt73Z7F7zNtn9kZ3tsZMTLSpKsp5c/YeOSh9CHdTU0MBMnr6S5WnkaXdZgpg6X
	 sfxjKEP0ddwGwD+9VVlVDdGiTb4gS2R2xAKtRaPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH 6.18 011/275] greybus: gb-beagleplay: bound bootloader receive buffering
Date: Mon,  4 May 2026 15:49:11 +0200
Message-ID: <20260504135143.359578802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 1214bf28965ceaf584fb20d357731264dd2e10e1 upstream.

cc1352_bootloader_rx() appends each serdev chunk into the fixed
rx_buffer before parsing bootloader packets. The helper can keep
leftover bytes between callbacks and may receive multiple packets in one
callback, so a single count value is not constrained by one packet
length.

Check that the incoming chunk fits in the remaining receive buffer space
before memcpy(). If it does not, drop the staged data and consume the
bytes instead of overflowing rx_buffer.

Fixes: 0cf7befa3ea2 ("greybus: gb-beagleplay: Add firmware upload API")
Cc: stable <stable@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260402054016.38587-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/greybus/gb-beagleplay.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -535,6 +535,13 @@ static size_t cc1352_bootloader_rx(struc
 	int ret;
 	size_t off = 0;
 
+	if (count > sizeof(bg->rx_buffer) - bg->rx_buffer_len) {
+		dev_warn(&bg->sd->dev,
+			 "dropping oversized bootloader receive chunk");
+		bg->rx_buffer_len = 0;
+		return count;
+	}
+
 	memcpy(bg->rx_buffer + bg->rx_buffer_len, data, count);
 	bg->rx_buffer_len += count;
 


