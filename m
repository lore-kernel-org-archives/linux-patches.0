Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3806B17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1DCC433C7;
	Wed,  9 Aug 2023 11:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580315;
	bh=werk7RZWHTc0ehFZfT3Fkw2zufSa3dzfdR3lFBoxkak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+7AhiyRx8KYqytwlw+MUBKjPEf43O9fPiYr7fEPEk3jbNwQMDSoutUJFaT9potfN
	 78pvZKPhhQERqKzQvTSezjJPmrgI0GncK2OUqvkFMZ/xPHzdOJPDa85bO+TMnHlonq
	 h+AsngJUxGwGHiZCF2IIYYnOpyR3I9qwOQtHTkLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Steffen <Alexander.Steffen@infineon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.19 274/323] tpm_tis: Explicitly check for error code
Date: Wed,  9 Aug 2023 12:41:52 +0200
Message-ID: <20230809103710.598335731@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Steffen <Alexander.Steffen@infineon.com>

commit 513253f8c293c0c8bd46d09d337fc892bf8f9f48 upstream.

recv_data either returns the number of received bytes, or a negative value
representing an error code. Adding the return value directly to the total
number of received bytes therefore looks a little weird, since it might add
a negative error code to a sum of bytes.

The following check for size < expected usually makes the function return
ETIME in that case, so it does not cause too many problems in practice. But
to make the code look cleaner and because the caller might still be
interested in the original error code, explicitly check for the presence of
an error code and pass that through.

Cc: stable@vger.kernel.org
Fixes: cb5354253af2 ("[PATCH] tpm: spacing cleanups 2")
Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -270,6 +270,7 @@ static int tpm_tis_recv(struct tpm_chip
 	int size = 0;
 	int status;
 	u32 expected;
+	int rc;
 
 	if (count < TPM_HEADER_SIZE) {
 		size = -EIO;
@@ -289,8 +290,13 @@ static int tpm_tis_recv(struct tpm_chip
 		goto out;
 	}
 
-	size += recv_data(chip, &buf[TPM_HEADER_SIZE],
-			  expected - TPM_HEADER_SIZE);
+	rc = recv_data(chip, &buf[TPM_HEADER_SIZE],
+		       expected - TPM_HEADER_SIZE);
+	if (rc < 0) {
+		size = rc;
+		goto out;
+	}
+	size += rc;
 	if (size < expected) {
 		dev_err(&chip->dev, "Unable to read remainder of result\n");
 		size = -ETIME;


