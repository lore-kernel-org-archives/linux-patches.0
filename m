Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D013D0D1;
	Tue, 14 May 2024 11:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687471; cv=none; b=KyJuTSleVnJ94oJ7L0l+uTQqxKP++oTlXIJKO+6eMjuOiWciJNpwyJnUnLfJrYgt5/lFYmFN5Mx7M6JkQYPopPxFtN6OPdyM78MxM9Ew7mz54M2ePdtOuUOOTcGVL8MpyecVVEoWuwCdVM3UshMu/oXiMQuU5zx3RKQv22JqNnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687471; c=relaxed/simple;
	bh=Tpd3nBOmJQIWFGTBLZcNo1NESOMoOosClUVL4Bhfs1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X09Hag5OIHH5XqczpPsy/ZM1WCxiq2duKFSI83RvQ/341DNgNmZcwoHQt3pHf5jyc3Hc9cz6zqaaSrMPekYZH0TsasHmE8Rl1tAkTg++YIPILR4vlvHf0+txpm8N7XTUKuDh95x6Q8IxnyQS3CpPU6om4PdNzEwnCSyMwtgarSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a36HVJcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a36HVJcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0960C2BD10;
	Tue, 14 May 2024 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687471;
	bh=Tpd3nBOmJQIWFGTBLZcNo1NESOMoOosClUVL4Bhfs1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a36HVJcjYZ3AWtknXzAroRwOc1V6iaXW9DIpQoQ3Q5NFB+6drVzz4WqENUbxrfhop
	 KbwS58yVqHKzIwBK1AUmRNoY08DGXwaxSN+uhkvkccZuQbOLP1K5WA6hEu6MUFZsV0
	 AMff1EUJrzPU4B303tUa7OTo7sKwNuGoumDthYU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thanassis Avgerinos <thanassis.avgerinos@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.10 090/111] firewire: nosy: ensure user_length is taken into account when fetching packet contents
Date: Tue, 14 May 2024 12:20:28 +0200
Message-ID: <20240514101000.550113904@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thanassis Avgerinos <thanassis.avgerinos@gmail.com>

commit 38762a0763c10c24a4915feee722d7aa6e73eb98 upstream.

Ensure that packet_buffer_get respects the user_length provided. If
the length of the head packet exceeds the user_length, packet_buffer_get
will now return 0 to signify to the user that no data were read
and a larger buffer size is required. Helps prevent user space overflows.

Signed-off-by: Thanassis Avgerinos <thanassis.avgerinos@gmail.com>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/nosy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -148,10 +148,12 @@ packet_buffer_get(struct client *client,
 	if (atomic_read(&buffer->size) == 0)
 		return -ENODEV;
 
-	/* FIXME: Check length <= user_length. */
+	length = buffer->head->length;
+
+	if (length > user_length)
+		return 0;
 
 	end = buffer->data + buffer->capacity;
-	length = buffer->head->length;
 
 	if (&buffer->head->data[length] < end) {
 		if (copy_to_user(data, buffer->head->data, length))


