Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D369E3B7B72;
	Sat, 30 May 2026 17:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163214; cv=none; b=LMQ5upicEMekpkAVQJ4UMnIHgc+79zvCAF4tF5iXXjwgPRkHRIJSszEX9FFR06S5wloLAot2ieQ30rlqxZq1Rv7IWqmB05YjhTZdsjQC5y4gjC5RsJK5l31rB075I94Qwb3rzO2wI0wo460OZmr0mkQGu3yDMb5UpN1Qd2ev5iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163214; c=relaxed/simple;
	bh=mxhM8jtrrnKCdlnJWeiPxhXgyRcSKzCg6v3J6yPEdvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaC/28h7F22FuS7tDgwoCnHM/GYRgrpgrti+/PzjwRCSKNflq/Zd6xq2qgsiDs6lSHiLGRkN0RePLI+5E/mnliI/UVYnSbrP3XJWnX7p0CE8jHu9fCW2uhUivLKJZ0uSUl8R16pY4FCo6PiLP6Yb3UHL9cxqr1/ir0XoZ/ealNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKaaEpgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKaaEpgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71261F00893;
	Sat, 30 May 2026 17:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163212;
	bh=BEZt5mC2C4od0ElCoMQ2t1iJhJkpz59fi5xKcNdbU4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKaaEpgBZv2c4ZZnvnz4GzmdPCl07FUlD6LzjF7+5voYP8+HxL92aprwyHTD5sdez
	 UgxYSn4EyMoGlGvZzk1EuvMg8SQZcV1/62MTZzZUNUntehylsJBHvOmAl7bMZtHVI1
	 CaMNQAqfBKnE1hZmXoeQ17CjhJxlMc3CMnG9chNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Tyllis Xu <LivelyCarpet87@gmail.com>
Subject: [PATCH 5.15 189/776] ibmasm: fix heap over-read in ibmasm_send_i2o_message()
Date: Sat, 30 May 2026 17:58:23 +0200
Message-ID: <20260530160245.385635463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyllis Xu <livelycarpet87@gmail.com>

commit 9aad71144fa3682cca3837a06c8623016790e7ec upstream.

The ibmasm_send_i2o_message() function uses get_dot_command_size() to
compute the byte count for memcpy_toio(), but this value is derived from
user-controlled fields in the dot_command_header (command_size: u8,
data_size: u16) and is never validated against the actual allocation size.
A root user can write a small buffer with inflated header fields, causing
memcpy_toio() to read up to ~65 KB past the end of the allocation into
adjacent kernel heap, which is then forwarded to the service processor
over MMIO.

Silently clamping the copy size is not sufficient: if the header fields
claim a larger size than the buffer, the SP receives a dot command whose
own header is inconsistent with the I2O message length, which can cause
the SP to desynchronize. Reject such commands outright by returning
failure.

Validate command_size before calling get_mfa_inbound() to avoid leaking
an I2O message frame: reading INBOUND_QUEUE_PORT dequeues a hardware
frame from the controller's free pool, and returning without a
corresponding set_mfa_inbound() call would permanently exhaust it.

Additionally, clamp command_size to I2O_COMMAND_SIZE before the
memcpy_toio() so the MMIO write stays within the I2O message frame,
consistent with the clamping already performed by outgoing_message_size()
for the header field.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>
Link: https://patch.msgid.link/20260314165805.548293-1-LivelyCarpet87@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ibmasm/lowlevel.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/misc/ibmasm/lowlevel.c
+++ b/drivers/misc/ibmasm/lowlevel.c
@@ -19,17 +19,21 @@ static struct i2o_header header = I2O_HE
 int ibmasm_send_i2o_message(struct service_processor *sp)
 {
 	u32 mfa;
-	unsigned int command_size;
+	size_t command_size;
 	struct i2o_message *message;
 	struct command *command = sp->current_command;
 
+	command_size = get_dot_command_size(command->buffer);
+	if (command_size > command->buffer_size)
+		return 1;
+	if (command_size > I2O_COMMAND_SIZE)
+		command_size = I2O_COMMAND_SIZE;
+
 	mfa = get_mfa_inbound(sp->base_address);
 	if (!mfa)
 		return 1;
 
-	command_size = get_dot_command_size(command->buffer);
-	header.message_size = outgoing_message_size(command_size);
-
+	header.message_size = outgoing_message_size((unsigned int)command_size);
 	message = get_i2o_message(sp->base_address, mfa);
 
 	memcpy_toio(&message->header, &header, sizeof(struct i2o_header));


