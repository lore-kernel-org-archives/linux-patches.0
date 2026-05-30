Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974A7320CAD;
	Sat, 30 May 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163469; cv=none; b=pXNeoFgbshtypyW5txQk70NPmt7/M2RGGClpyuYMAwd9XU00lThnQJk+Y9egttBlenGQQPBVk+YfY0bQgMVDJrxoHUDpwexdYnHaEjuwt7HjgOpI0FBbE/Ph9Chtgohrc5VPK07nkNVfkEN+/47n9BNC35KjKHk1hp+ApnKlNNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163469; c=relaxed/simple;
	bh=aJSJ4y9HzgJThU8hlZeXvgRwCpgpvVzyDTzidzQ7Qis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFzeertAEjh0eXx2mEvtfI/TaiPzrbgrwg9hDj9CRblp43D96LDrdanIHZIZlP6xGWieYYJT+pPmVVv8I0QlHu7/Cr0zQrlVIG9vUzXMYV4QqML+8Ow8wS7W8C1giaKmVKj6fSONOcP4apyvoEdxOpVam9vNEgztdtj/ik+BBS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0IZw1v6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0IZw1v6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC44D1F00893;
	Sat, 30 May 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163468;
	bh=sLUojZ5YBo7ngXAZuKgEF9+MqkklszBv8NKFmrssvRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e0IZw1v6iwbGHU3Mm2X758iQX7mb3LoubKOEQyeMxAxFVaI7K5yJ53kwyloD03UTt
	 tW29Yu/nScJUwoFU0WCPnsKUy6jYJ1xIYDEswd2tFrsc5S1OXrgXA9xfRZqHu8zlne
	 E7Zf3Aie29B5TMltzY51u2q4PYDy1YbpCa7pynjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 228/776] tpm: tpm_tis: add error logging for data transfer
Date: Sat, 30 May 2026 17:59:02 +0200
Message-ID: <20260530160246.417477951@linuxfoundation.org>
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

From: Jacqueline Wong <jacqwong@google.com>

commit 0471921e2d1043dcc6de5cffb49dd37709521abe upstream.

Add logging to more easily determine reason for transmit failure

Cc: stable@vger.kernel.org # v6.6+
Fixes: 280db21e153d8 ("tpm_tis: Resend command to recover from data transfer errors")
Signed-off-by: Jacqueline Wong <jacqwong@google.com>
Signed-off-by: Jordan Hand <jhand@google.com>
Link: https://lore.kernel.org/r/20260415160006.2275325-2-jacqwong@google.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -410,6 +410,8 @@ static int tpm_tis_send_data(struct tpm_
 		status = tpm_tis_status(chip);
 		if (!itpm && (status & TPM_STS_DATA_EXPECT) == 0) {
 			rc = -EIO;
+			dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be set. sts = 0x%08x\n",
+				status);
 			goto out_err;
 		}
 	}
@@ -427,6 +429,8 @@ static int tpm_tis_send_data(struct tpm_
 	status = tpm_tis_status(chip);
 	if (!itpm && (status & TPM_STS_DATA_EXPECT) != 0) {
 		rc = -EIO;
+		dev_err(&chip->dev, "TPM_STS_DATA_EXPECT should be unset. sts = 0x%08x\n",
+			status);
 		goto out_err;
 	}
 


