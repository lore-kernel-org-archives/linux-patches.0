Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDE93DEAD6;
	Mon,  4 May 2026 14:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904365; cv=none; b=T4vyqkxsWQhcKEaxc2htlMCKvJZRLat71Hk6Ei2VjjDN9xmvvqHi7KWdK6pscr/uz/8Nn3f59IfUr9EEu3XA30S3KhS5IHfWeTJt4ob8CjMwJAotRURTQIR1mO664AOpA6mrUva79p/AlMvNLmkCULxSwQnGpLltNDSS2Bin60I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904365; c=relaxed/simple;
	bh=EOR71yMzeUCyC6KwmRJIk48dF1yUljzs5P8M+Kcnj3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGZm5KNHS1JiKSuXvv3Ts8uL7oR1OAngxRzpRMAol3z/3SQi8HdakH6/muuhYEd4F3OLiFlS1kr0t8kul5ftAqqjCVqINbPhQkYld5jqPb654iry6eTYSKUkG58Vn01aaVxZlMhLHLdpPMIZ5fRZpx7gRpXn8ntBiqhMOwFsmek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYT12ifb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYT12ifb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EB6C2BCB8;
	Mon,  4 May 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904365;
	bh=EOR71yMzeUCyC6KwmRJIk48dF1yUljzs5P8M+Kcnj3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RYT12ifbgN+8+vN/s3kcbUmLpri2yt3EDeWyEh58XrGfguh6QSOJWcYdH/4zRVLjV
	 JsrlWf3Yi+GHfht4Syfzw0+d8mE0A7+pF/PgU6dYgPeUk+Amo8KMWWutI2iaZdGK7A
	 CVO7PPk+aMlgmemai9fl/1ugVXaYZJX/EE0zBq/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH 6.12 011/215] greybus: gb-beagleplay: bound bootloader receive buffering
Date: Mon,  4 May 2026 15:50:30 +0200
Message-ID: <20260504135130.587383883@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
 


