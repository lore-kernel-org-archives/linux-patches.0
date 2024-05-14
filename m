Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E42D60A;
	Tue, 14 May 2024 11:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687123; cv=none; b=C1IxvrILLsgLlIQL/dkpADYwUHcxVUkW/5gqlj0XcU5ADBROKLRw2AfG7iN5eOR14sKBp1soMv2U98PvFj+EhJ0Tup494ShWrul4B/hT8Ub2e5WzCmWLeToPeZIlEDzMd4uJkOMTzFLeibkT7/kBS2E8Yz4OO+RrsaOz+ACGCpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687123; c=relaxed/simple;
	bh=eBCs5NISTj+wMXyPYqNw/iaUrgm0UqUCM+CjGLpmDXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVM6L/88ZTCl0vGuJbeVZHsiEK4+X7R/30Yu2Y8uYY5waaEHJIbQ2/ZDxQa8yBTRvvXOSy7tL+hxPO388mT1eSd28Q5G9ZhJMCnd8APrXi+XpqFoNOYsHP8wJ94CRfDmitIe/dmTH3shWiVUNa/pu1IxI6yRV21iWFA80LZYEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1ZVlpTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1ZVlpTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03998C2BD10;
	Tue, 14 May 2024 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687123;
	bh=eBCs5NISTj+wMXyPYqNw/iaUrgm0UqUCM+CjGLpmDXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1ZVlpTxEgJH9/di8pgBGD7nQyj43PsRTBToTQG0/qvv15EpEVWe/TeewgTHBhRbb
	 rGpKUJ/+M4K3quQUa+Kg2E5vPTDKsZswJhZn3OUOEWzmoIuz1VA67nNOnHSqVTDOAH
	 K0ylo5T3HOH7XgLeXpDiA0rE631VbrpZCIyxof9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thanassis Avgerinos <thanassis.avgerinos@gmail.com>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.4 73/84] firewire: nosy: ensure user_length is taken into account when fetching packet contents
Date: Tue, 14 May 2024 12:20:24 +0200
Message-ID: <20240514100954.427303247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


