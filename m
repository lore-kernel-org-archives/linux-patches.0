Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D72E3BE630;
	Mon,  4 May 2026 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904082; cv=none; b=k8HVat7/ldy45rWjeoW0PlfoqZoGLqbN8LVzai6RaYsre2HlbAP3GuYN6hHQhkumMKF8ygm8+6Y7fAyIkMM+GXo79MtMHchhHT9loNNtluYk1s148zIvRUjnx+arNT18l0oVsWB5eNGdGq3473mxHq0D6PZPjGRk+wAJCjfNr4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904082; c=relaxed/simple;
	bh=KxtXCqojtfaZdwrucVMG5XarfHyVHyG4mU5yQ9BCft4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FleVr8Jt2cPnseH0ED4j9fHYyRWDCkPQRcQboY99Y+4m/Qt32IZnwNCPnMmLrLFzRrm+bK/NpBI7IBCPeveg7xsRme39eEoTjjnstjItaS5uV648tkbiZeI+CZQEAhqhLfab/vf+o8wBhWvCTC6su9ZEXiyylVzh1612aTl5jfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz9i0AsV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz9i0AsV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DF9C2BCC4;
	Mon,  4 May 2026 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904082;
	bh=KxtXCqojtfaZdwrucVMG5XarfHyVHyG4mU5yQ9BCft4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz9i0AsVYhhKHh0K6L7s2auiK9Jv8SEk59SbemoRrAcQEAFF5c+Hb/GcctodQQ5mM
	 rHbLz2Elh2WHFBcKZuU7FTXkvcLacv5EK9Tmx3rmt59wwByTt2UEl5gWaj+JzleMQq
	 duzPCabcFgntD21fqqOluXqVIX/BmMFebM7Z0SVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 159/275] tpm: tpm_tis: stop transmit if retries are exhausted
Date: Mon,  4 May 2026 15:51:39 +0200
Message-ID: <20260504135148.910264608@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacqueline Wong <jacqwong@google.com>

commit 949692da7211572fac419b2986b6abc0cd1aeb76 upstream.

tpm_tis_send_main() will attempt to retry sending data TPM_RETRY times.
Currently, if those retries are exhausted, the driver will attempt to
call execute. The TPM will be in the wrong state, leading to the
operation simply timing out.

Instead, if there is still an error after retries are exhausted, return
that error immediately.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 280db21e153d8 ("tpm_tis: Resend command to recover from data transfer errors")
Signed-off-by: Jacqueline Wong <jacqwong@google.com>
Signed-off-by: Jordan Hand <jhand@google.com>
Link: https://lore.kernel.org/r/20260415160006.2275325-3-jacqwong@google.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -557,11 +557,16 @@ static int tpm_tis_send_main(struct tpm_
 			break;
 		else if (rc != -EAGAIN && rc != -EIO)
 			/* Data transfer failed, not recoverable */
-			return rc;
+			goto out_err;
 
 		usleep_range(priv->timeout_min, priv->timeout_max);
 	}
 
+	if (rc == -EAGAIN || rc == -EIO) {
+		dev_err(&chip->dev, "Exhausted %d tpm_tis_send_data retries\n", TPM_RETRY);
+		goto out_err;
+	}
+
 	/* go and do it */
 	rc = tpm_tis_write8(priv, TPM_STS(priv->locality), TPM_STS_GO);
 	if (rc < 0)


