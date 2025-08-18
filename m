Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66583335BD8;
	Mon, 18 Aug 2025 13:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523254; cv=none; b=N3zJkhdnJhJuXTdbziVCSRg/zh3icynK/8MwzGGsmZNZ1Cz9K0oESYnfHXOmdqOa7pQRe7aIT6KX2jv3mUWGrxOqYmstJ11H0V3jcJQ1KcJ2p278VxSsSzAcsEcTPZCVxz6eS1WtPkP+OFh1WbJPcomsk5BmbIDyuO/KhnAr5y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523254; c=relaxed/simple;
	bh=6LyvAp5wXCz1mRRAvx26kaCMF0c9stVjtaMIB05px/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQUBBkiEmfYLh3kkgIagH10jBj+C9OkhSFW0xhWpYnejQYcsBsHn7tcE8ivwSs44h5Fg/26ICFoiDBsd+xlMohqxPTXEUGNOINmsAmDJ4sFliFjhbcpLQbKROJy3t82LfxEOmYK2bpyAV5p/TWNAVaU5VrhkJucRXPgbm+DVTlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+GGBl2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+GGBl2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5316DC4CEEB;
	Mon, 18 Aug 2025 13:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523254;
	bh=6LyvAp5wXCz1mRRAvx26kaCMF0c9stVjtaMIB05px/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+GGBl2y6mb9wjNqoc87BJjLwloudCgTKjVh+nY7QPMkcKKK/mwQ5+WvkMPk+XKrf
	 sZ5uUXSsbTqUiXyD6SeB05r0hhAbMHIigi48aCFCisPQAqxYIMOdhhAaGiIRTKCZz6
	 gWXdCS0TaLDnZ8VjHRycBt3zJrHIZjzllVwYTNU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 084/515] tpm: Check for completion after timeout
Date: Mon, 18 Aug 2025 14:41:10 +0200
Message-ID: <20250818124501.611173136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit d4640c394f23b202a89512346cf28f6622a49031 ]

The current implementation of timeout detection works in the following
way:

1. Read completion status. If completed, return the data
2. Sleep for some time (usleep_range)
3. Check for timeout using current jiffies value. Return an error if
   timed out
4. Goto 1

usleep_range doesn't guarantee it's always going to wake up strictly in
(min, max) range, so such a situation is possible:

1. Driver reads completion status. No completion yet
2. Process sleeps indefinitely. In the meantime, TPM responds
3. We check for timeout without checking for the completion again.
   Result is lost.

Such a situation also happens for the guest VMs: if vCPU goes to sleep
and doesn't get scheduled for some time, the guest TPM driver will
timeout instantly after waking up without checking for the completion
(which may already be in place).

Perform the completion check once again after exiting the busy loop in
order to give the device the last chance to send us some data.

Since now we check for completion in two places, extract this check into
a separate function.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-interface.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 8d7e4da6ed53..8d18b33aa62d 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -82,6 +82,13 @@ static bool tpm_chip_req_canceled(struct tpm_chip *chip, u8 status)
 	return chip->ops->req_canceled(chip, status);
 }
 
+static bool tpm_transmit_completed(u8 status, struct tpm_chip *chip)
+{
+	u8 status_masked = status & chip->ops->req_complete_mask;
+
+	return status_masked == chip->ops->req_complete_val;
+}
+
 static ssize_t tpm_try_transmit(struct tpm_chip *chip, void *buf, size_t bufsiz)
 {
 	struct tpm_header *header = buf;
@@ -129,8 +136,7 @@ static ssize_t tpm_try_transmit(struct tpm_chip *chip, void *buf, size_t bufsiz)
 	stop = jiffies + tpm_calc_ordinal_duration(chip, ordinal);
 	do {
 		u8 status = tpm_chip_status(chip);
-		if ((status & chip->ops->req_complete_mask) ==
-		    chip->ops->req_complete_val)
+		if (tpm_transmit_completed(status, chip))
 			goto out_recv;
 
 		if (tpm_chip_req_canceled(chip, status)) {
@@ -142,6 +148,13 @@ static ssize_t tpm_try_transmit(struct tpm_chip *chip, void *buf, size_t bufsiz)
 		rmb();
 	} while (time_before(jiffies, stop));
 
+	/*
+	 * Check for completion one more time, just in case the device reported
+	 * it while the driver was sleeping in the busy loop above.
+	 */
+	if (tpm_transmit_completed(tpm_chip_status(chip), chip))
+		goto out_recv;
+
 	tpm_chip_cancel(chip);
 	dev_err(&chip->dev, "Operation Timed out\n");
 	return -ETIME;
-- 
2.39.5



