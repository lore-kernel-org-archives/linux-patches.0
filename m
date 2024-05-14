Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E4E5A0F9;
	Tue, 14 May 2024 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686923; cv=none; b=iN7kcJD6EZd266ogV710ie2rWHRftO1QbjeKRQ9/Y3JqZzagduMB9WB1MMshZl3kCtecVhgL+Vn24OfGx2CVytPqkAqhFyPXRP8We1zmJtVW+WIqL2St0tcw5dtWMhGNv+3oe+8nWFl0VQ1HfGyB57r8XTRqX61zh3kWuFPShw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686923; c=relaxed/simple;
	bh=DQ6xT2qkcZAKmu9LLbFoht+V90FZElWfusgruxzK2Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQpm8yPelugyYjHrmFUYp8bpKylE3CM3dFCij6k0mi6LmKpb3mmYPKmC/VGmH+y7IIzoDs+XRDzMrsN80VfgSSRwxEd45CfbBizypW3oxIguhQuoq+rr+qzmf6RU/yr7dvFV+TpYbpQeArRk/8n0UKNrTpBHXNXLUC0IKadQ740=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jh4/8R7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jh4/8R7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF53C2BD10;
	Tue, 14 May 2024 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686923;
	bh=DQ6xT2qkcZAKmu9LLbFoht+V90FZElWfusgruxzK2Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jh4/8R7Ti7qaspP77Lc8L2wU2oiAtDcSaMnpmkHOLx4WiGYLqdSzfXO8ORs1SDrgU
	 lFzPhJUHFoqgewAql29nAHbTOt9lNRHfyQoXUXAnwvH1JZPQCDDUDcS/zIlPkvxC4Q
	 fvzlMTno0NPTGRUs45+JxZF8wq2prNpUHaPEuZqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thanassis Avgerinos <thanassis.avgerinos@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 4.19 56/63] firewire: nosy: ensure user_length is taken into account when fetching packet contents
Date: Tue, 14 May 2024 12:20:17 +0200
Message-ID: <20240514100950.126567112@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,10 +161,12 @@ packet_buffer_get(struct client *client,
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


