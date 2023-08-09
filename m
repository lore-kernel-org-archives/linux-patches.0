Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402D217AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DC1C433C8;
	Wed,  9 Aug 2023 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580578;
	bh=Elm/IbQH+RjVwVI8uuNCD+TQt7lRxqZV9TK74mGHsfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSyIxVTaO84kO78qJ7fFm5VKvo1aDQxVO+LQS1UOqspM5fiDLpF7BgkNQCe/gGqr9
	 JqEA8QgPPfWL7LugvOd42oXthFCYK8ujW6c+zdDU4QE0M8yqq634KytSGQmrZQ1dT+
	 qRQbzGTGP9JAakd5RURQKu6s7S8PavGkAUdgKoy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Steffen <Alexander.Steffen@infineon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.4 074/154] tpm_tis: Explicitly check for error code
Date: Wed,  9 Aug 2023 12:41:45 +0200
Message-ID: <20230809103639.439497408@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
@@ -266,6 +266,7 @@ static int tpm_tis_recv(struct tpm_chip
 	int size = 0;
 	int status;
 	u32 expected;
+	int rc;
 
 	if (count < TPM_HEADER_SIZE) {
 		size = -EIO;
@@ -285,8 +286,13 @@ static int tpm_tis_recv(struct tpm_chip
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


