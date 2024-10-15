Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFA819B3FF;
	Tue, 15 Oct 2024 11:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993578; cv=none; b=HIsLzZW+os6uqn5w4Umet8UC6MKPkmn+r0IIKTHkQIpqZD6zIviHRyLtgXWyb8irMIP7l9+yNNfXgRL1Wa3S2n67IGaJkq63uKnpP/1U6Z0LWy2IiUnfbmzN1CwfitXYYowOK569Hq95KeUO8uyVyZRX9AUQ3ruPXmpi2K273Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993578; c=relaxed/simple;
	bh=cjGK+3W/Wsst0RdnV8lWqhc1vPuWCDETax0EzLEy5iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkqNYs1EEC0a/03WaIb2RgendAGuJhNBBFIm4MRs3St4LLMHuyBFLhptN77jtol5xVH/0IWvHaPkZQCXHvpRzmoPTQTZO5ZhnOkuBKIDXRBalH8LwjXEfkxZoel/dbnHKpuA6ule1y1acr6oPdyNUePWhLbdEO6V0cY+yK1ZSxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHXl6rdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHXl6rdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C154C4CED0;
	Tue, 15 Oct 2024 11:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993577;
	bh=cjGK+3W/Wsst0RdnV8lWqhc1vPuWCDETax0EzLEy5iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHXl6rdSUMlZG6tmnEnYJaInWKOo/1KIYB7Jn5KT1RdPBwnlwLfONovPBU1w/kydn
	 TBneaflpzkHLSnUDEbCYx6xarkbJmBNxpkM8/X1Gba5MDpy0WzJwZboX+z4nuZGhY+
	 4avm9kJVUnesktRtXQyW9yBJg7/Rzy2NeR5o4xNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 422/691] ACPI: EC: Do not release locks during operation region accesses
Date: Tue, 15 Oct 2024 13:26:10 +0200
Message-ID: <20241015112457.094545858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 59e617ab12a51..ddc5b3a3d9b38 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -773,6 +773,9 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	unsigned long tmp;
 	int ret = 0;
 
+	if (t->rdata)
+		memset(t->rdata, 0, t->rlen);
+
 	/* start transaction */
 	spin_lock_irqsave(&ec->lock, tmp);
 	/* Enable GPE for command processing (IBF=0/OBF=1) */
@@ -809,8 +812,6 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 
 	if (!ec || (!t) || (t->wlen && !t->wdata) || (t->rlen && !t->rdata))
 		return -EINVAL;
-	if (t->rdata)
-		memset(t->rdata, 0, t->rlen);
 
 	mutex_lock(&ec->mutex);
 	if (ec->global_lock) {
@@ -837,7 +838,7 @@ static int acpi_ec_burst_enable(struct acpi_ec *ec)
 				.wdata = NULL, .rdata = &d,
 				.wlen = 0, .rlen = 1};
 
-	return acpi_ec_transaction(ec, &t);
+	return acpi_ec_transaction_unlocked(ec, &t);
 }
 
 static int acpi_ec_burst_disable(struct acpi_ec *ec)
@@ -847,7 +848,7 @@ static int acpi_ec_burst_disable(struct acpi_ec *ec)
 				.wlen = 0, .rlen = 0};
 
 	return (acpi_ec_read_status(ec) & ACPI_EC_FLAG_BURST) ?
-				acpi_ec_transaction(ec, &t) : 0;
+				acpi_ec_transaction_unlocked(ec, &t) : 0;
 }
 
 static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 *data)
@@ -863,6 +864,19 @@ static int acpi_ec_read(struct acpi_ec *ec, u8 address, u8 *data)
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
@@ -873,6 +887,16 @@ static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
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
@@ -1293,6 +1317,7 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	struct acpi_ec *ec = handler_context;
 	int result = 0, i, bytes = bits / 8;
 	u8 *value = (u8 *)value64;
+	u32 glk;
 
 	if ((address > 0xFF) || !value || !handler_context)
 		return AE_BAD_PARAMETER;
@@ -1300,13 +1325,25 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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
@@ -1314,6 +1351,12 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



