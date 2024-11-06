Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7FC1D416E;
	Wed,  6 Nov 2024 12:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895247; cv=none; b=pwBAjwCtCAw12/8xl9b8ZgLO5dwthEuzca0wo+27t1bp+lVQ/2XrHduI9jyzYN45x+/NMZUcmh8ZV0k/vshX3FEvlY/cAdqsAbCQS3yxTCgM6OztLF9a0cFA9+spzK7+99J9YLwqZDoiwqvm0K/3d6CjPiRr5aZHeGMoR6eSUaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895247; c=relaxed/simple;
	bh=Ey17mPXiB5w6FOKzGqA3jru+3JxJuOtwJo+4+ERvjtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5D3v8kRv1yKr89SILU9uFtSCbIsVY8DI9O94KKUMh72RP7UIKvzwgmEE7BcE0lXqL2bHpIBU6bRhQj/qMQpztNmb2GXoqKz+GHWyhe0gyeGtU9DFhwiY1MWoolTiVuEWjVFqWgCnc0IIFXzsLmwCRh37uymcwWolGqg2SEfJVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DW/kT71J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW/kT71J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73709C4CECD;
	Wed,  6 Nov 2024 12:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895246;
	bh=Ey17mPXiB5w6FOKzGqA3jru+3JxJuOtwJo+4+ERvjtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW/kT71JNItjpsjKpZh9oNkbjC0SJgbxPJpxsxMJiRqhL1btSWZe3kyta6IfbJvEl
	 sE95/dm1VknruyZL52yK7ozSrqcGhUpQuHfaHSBe15GnLWOYDLt/LT8cXq5e3hFm9Y
	 Udxbgev4AmN2DvbGcVPTonK2j+c6cnWKGu44SJuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/350] ACPI: EC: Do not release locks during operation region accesses
Date: Wed,  6 Nov 2024 13:01:21 +0100
Message-ID: <20241106120324.696357763@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit dc171114926ec390ab90f46534545420ec03e458 ]

It is not particularly useful to release locks (the EC mutex and the
ACPI global lock, if present) and re-acquire them immediately thereafter
during EC address space accesses in acpi_ec_space_handler().

First, releasing them for a while before grabbing them again does not
really help anyone because there may not be enough time for another
thread to acquire them.

Second, if another thread successfully acquires them and carries out
a new EC write or read in the middle if an operation region access in
progress, it may confuse the EC firmware, especially after the burst
mode has been enabled.

Finally, manipulating the locks after writing or reading every single
byte of data is overhead that it is better to avoid.

Accordingly, modify the code to carry out EC address space accesses
entirely without releasing the locks.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/12473338.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 55 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 7db62dec2ee53..1d0366c2c2175 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -807,6 +807,9 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	unsigned long tmp;
 	int ret = 0;
 
+	if (t->rdata)
+		memset(t->rdata, 0, t->rlen);
+
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
 	/* Enable GPE for command processing (IBF=0/OBF=1) */
@@ -843,8 +846,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 
 	if (!ec || (!t) || (t->wlen && !t->wdata) || (t->rlen && !t->rdata))
 		return -EINVAL;
-	if (t->rdata)
-		memset(t->rdata, 0, t->rlen);
 
 	mutex_lock(&ec->mutex);
 	if (ec->global_lock) {
@@ -871,7 +872,7 @@ static int acpi_ec_burst_enable(struct acpi_ec *ec)
 				.wdata = NULL, .rdata = &d,
 				.wlen = 0, .rlen = 1};
 
-	return acpi_ec_transaction(ec, &t);
+	return acpi_ec_transaction_unlocked(ec, &t);
 }
 
 static int acpi_ec_burst_disable(struct acpi_ec *ec)
@@ -881,7 +882,7 @@ static int acpi_ec_burst_disable(struct acpi_ec *ec)
 				.wlen = 0, .rlen = 0};
 
 	return (acpi_ec_read_status(ec) & ACPI_EC_FLAG_BURST) ?
-				acpi_ec_transaction(ec, &t) : 0;
+				acpi_ec_transaction_unlocked(ec, &t) : 0;
 }
 
 static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 *data)
@@ -897,6 +898,19 @@ static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 *data)
 	return result;
 }
 
+static int acpi_ec_read_unlocked(struct acpi_ec *ec, u8 address, u8 *data)
+{
+	int result;
+	u8 d;
+	struct transaction t = {.command = ACPI_EC_COMMAND_READ,
+				.wdata = &address, .rdata = &d,
+				.wlen = 1, .rlen = 1};
+
+	result = acpi_ec_transaction_unlocked(ec, &t);
+	*data = d;
+	return result;
+}
+
 static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 {
 	u8 wdata[2] = { address, data };
@@ -907,6 +921,16 @@ static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 	return acpi_ec_transaction(ec, &t);
 }
 
+static int acpi_ec_write_unlocked(struct acpi_ec *ec, u8 address, u8 data)
+{
+	u8 wdata[2] = { address, data };
+	struct transaction t = {.command = ACPI_EC_COMMAND_WRITE,
+				.wdata = wdata, .rdata = NULL,
+				.wlen = 2, .rlen = 0};
+
+	return acpi_ec_transaction_unlocked(ec, &t);
+}
+
 int ec_read(u8 addr, u8 *val)
 {
 	int err;
@@ -1320,6 +1344,7 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	struct acpi_ec *ec = handler_context;
 	int result = 0, i, bytes = bits / 8;
 	u8 *value = (u8 *)value64;
+	u32 glk;
 
 	if ((address > 0xFF) || !value || !handler_context)
 		return AE_BAD_PARAMETER;
@@ -1327,13 +1352,25 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	if (function != ACPI_READ && function != ACPI_WRITE)
 		return AE_BAD_PARAMETER;
 
+	mutex_lock(&ec->mutex);
+
+	if (ec->global_lock) {
+		acpi_status status;
+
+		status = acpi_acquire_global_lock(ACPI_EC_UDELAY_GLK, &glk);
+		if (ACPI_FAILURE(status)) {
+			result = -ENODEV;
+			goto unlock;
+		}
+	}
+
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_enable(ec);
 
 	for (i = 0; i < bytes; ++i, ++address, ++value) {
 		result = (function == ACPI_READ) ?
-			acpi_ec_read(ec, address, value) :
-			acpi_ec_write(ec, address, *value);
+			acpi_ec_read_unlocked(ec, address, value) :
+			acpi_ec_write_unlocked(ec, address, *value);
 		if (result < 0)
 			break;
 	}
@@ -1341,6 +1378,12 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_disable(ec);
 
+	if (ec->global_lock)
+		acpi_release_global_lock(glk);
+
+unlock:
+	mutex_unlock(&ec->mutex);
+
 	switch (result) {
 	case -EINVAL:
 		return AE_BAD_PARAMETER;
-- 
2.43.0



