Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1CAF9D4;
	Tue, 14 May 2024 11:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687887; cv=none; b=ofYU6DkD0I8T9DcksgKO2Soq1j5Kio5RYDHOxfyBCBLkueXL5MyzDpQed/HlI0b4ckbwNWz3AfIBCEK2uOKGikmIsKund21WhFtwgMs29mD7QUhQmD/QTe8qNBDRCCs94tnWW5R4WVpUaABYQBaxm68nxSjF9XsCMRiZX71gVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687887; c=relaxed/simple;
	bh=9IqtrEDNg5itWrIQhBXD9hfar02JjeWXEk699hAiDrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCkgDeaHMVU3Sb3+w1QpMkI35rF5jBd2r6jG6y67MOs0vi9cilZgu5ulz171spKrwrNjdLpMTpdN6/Kg5Psk0B95/alq+09RDwiL65gtlqXK9lKLub8HMUsFKsr/YTYfJQdwXocXgF7L+b9fGWRhxUgbXVPC1+amXlNGZp3giXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ06pmaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ06pmaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47237C2BD10;
	Tue, 14 May 2024 11:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687887;
	bh=9IqtrEDNg5itWrIQhBXD9hfar02JjeWXEk699hAiDrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ06pmaj7NZgtIwo3D5n+tbY8bugbb9luUgIAxC7UHte4ruEl7zJUwTrdu+8rv+Rg
	 wCFdKeuswNuTDqDU1/tNpnYukEnZPikIlzLG87WBn6BjnyhjloLJFJxphNvhbHtOqG
	 Cnt1FreY6wGaeUPUEPafB8xJWlJGWdb6jEm0A3wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thanassis Avgerinos <thanassis.avgerinos@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.15 138/168] firewire: nosy: ensure user_length is taken into account when fetching packet contents
Date: Tue, 14 May 2024 12:20:36 +0200
Message-ID: <20240514101011.896796111@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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


