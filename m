Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E1F318EE4;
	Fri, 15 May 2026 16:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860818; cv=none; b=VZiyR2R6FpdP7GKnlsVKTIg004QSCcfsGVCNCrS70hxWekxhlL2AGuvRqQaAf5Ybr/XBxwog1rNOZ3tazQI76duT4NsQLuSaToY8Eru822aFQ3QsXLnPECwzx6RnYy8nCu9bRc9rAmFpEotez5lYJTXKqOv2jYfeRrUYT8lLin8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860818; c=relaxed/simple;
	bh=cO9U3qwgLOhgsihHvedXuVmo8thu7xmgFgsUfCyT5tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uq+fRoK7KkLH2rKyVFugQ+18z/xQs8pOs8auiGHVsTrR/nP3IBgitLuq0CbKSaARZNSnbzqgI3ddko4y7Yj493GI9cVzNi2c2D6jPVCC5D/sKzclck8sgCplvr+F0o56SV1r+w+WIZxjwSRMWCmFxLaI+SSl0I9zuZJTb+5We1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zha3tIGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zha3tIGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB82C2BCB0;
	Fri, 15 May 2026 16:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860818;
	bh=cO9U3qwgLOhgsihHvedXuVmo8thu7xmgFgsUfCyT5tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zha3tIGMoq9SKB2GaaFv/rJbHhbO+h/7miTXiIBMfFr2GQxoHVjnP9kLTe7lpU75k
	 FYFat9goqQ8eMrkD9nAD1SK/EyQvw5YKwy++lW0DDL5pOGLzVN650v/f/9Tplqp2ru
	 4I6lf9qVzh07/5WAT0cmbKCJ+4yMTGC3JZbzDz94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacqueline Wong <jacqwong@google.com>,
	Jordan Hand <jhand@google.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 090/474] tpm: tpm_tis: stop transmit if retries are exhausted
Date: Fri, 15 May 2026 17:43:19 +0200
Message-ID: <20260515154716.985608711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


