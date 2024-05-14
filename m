Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4640512D77B;
	Tue, 14 May 2024 11:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686665; cv=none; b=ONL6ssju2woXVzOC0Fyx7ur9eAlqu2JUjTCCEsBz3h48l7wYIWHDFzVC0qaz5tNLw12WRgp4gnm28u8yiq0T1nD+hujvrHxLMG4Eifzic1N4tvqWrcHPP5VBYn2x061ITUFfnTtrQqgeYWMAlVb4mnKR7NfjkquPfqrUaak17vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686665; c=relaxed/simple;
	bh=iCSPZZI7HOA9Srf5GiHCkgRag9VyjcJ/Fel2OdlJYAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ39MXfO3sGNQaaKlOfCBnbIy2jaocM9YZlEoyKIhTnIDBSabIg00nU3FE1IrRpavb6eh5GeVq3X8H4Kt+0xJ90JmaXlHGRmMTVyPUERU1gWZ1Vy97cssf0pawFSp4CEypOKnkU7gvWDMWyzYjs1nY0nNyEBTN2gWFgYdQvbWQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNX+HkLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNX+HkLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AFDC2BD10;
	Tue, 14 May 2024 11:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686665;
	bh=iCSPZZI7HOA9Srf5GiHCkgRag9VyjcJ/Fel2OdlJYAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNX+HkLeXky38PEaGYZPOESWdp7tCASq1vrBLyuTF58rl4OTTJPg6NCGW8EBmFpvM
	 F6RklqnDTOVj+7NAqgACyzTi6rAviPn1XsU2r6d7DMMFQOUIxVGutUeGxz/v8GxkaS
	 mMA6eqcluuUlHS8zoaQfDfmlrMQabZDfXqh+qm9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thanassis Avgerinos <thanassis.avgerinos@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.1 185/236] firewire: nosy: ensure user_length is taken into account when fetching packet contents
Date: Tue, 14 May 2024 12:19:07 +0200
Message-ID: <20240514101027.388173215@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


