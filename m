Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7EB3DC4D5;
	Mon,  4 May 2026 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902860; cv=none; b=ueglCRr2cPUr0QZ3s5enFM7rqMvtOd6fqEIseC1qSFJywTGqjJX3wCJk9bHORlumG2uPKii7m3SLqX/sfOsdocbhaX93Qc/e26z8fQy7MV2Mn3iLRnwYwKnU5Gz6u9j+Rfyvq3zb0mii2/cuFwrOMGWWANuhcmk/guvQYAUGaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902860; c=relaxed/simple;
	bh=DjlOx6qAlleHF/VnBGOeKkohQUC3iQvP6hKqO7igyW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwduSWHmU+2XG0SQZgpqEY8sgJMuw3Pkyv7pHH+XzdUIdKgGLGg/ORCRaGDqHFPa8QaKX6Zrq6hCQcgZm6vBKaPZ0/8vIUoROJ9gFOiMUPQdN15+zaxJJHwpCQxTzo5Ie8nd+lqs4PR2vOq4u7IxdIQgrlr33j+mB1CY4rKhVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdGWRYhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdGWRYhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CF1C2BCB8;
	Mon,  4 May 2026 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902860;
	bh=DjlOx6qAlleHF/VnBGOeKkohQUC3iQvP6hKqO7igyW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdGWRYhEx0nT9HwMXbIz9GPhw+yXKGY+9RsuxgWikOEZ8thZB7e6drsk7+SANMPs5
	 zosElLW+tZxpIN41vVbypYCfE76CTDv/nTkGQ8Z7ys5iycg0y8vouOj39Tu7+Lgqh7
	 uuRn2lT9zDFnKC98MnUH/MDir62/swCFMRqeYigY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH 7.0 011/307] greybus: gb-beagleplay: bound bootloader receive buffering
Date: Mon,  4 May 2026 15:48:16 +0200
Message-ID: <20260504135143.252383121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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
 


