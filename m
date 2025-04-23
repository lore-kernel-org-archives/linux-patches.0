Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB4928C5B9;
	Wed, 23 Apr 2025 15:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421010; cv=none; b=EnTwoXitJymjU1eNWqMYJxTFHbqdpN+7BKHjRHkymqKOcXqdsFR8lZUnM9vaA8Kv9zHpAeLiaojpedOtpiIKCiN0ic2oL4SKVWvpKxeCSRvz84k0OT0PX42sfNoEu+s0DmrNh5QqHVD3nWH/DfvbA/EH8xXBjC1qsnFXzuSWqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421010; c=relaxed/simple;
	bh=ZK6GyPNmxdUgjZly8+ZUtsuzKtq1owZLb6kh+gDDjWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gJOs10h+O4W7j+Lutr74pGKextAmVncdwi/Y6cUNR/8Teyu5rHda/ZlvNlu/rfI697JLn19X2Xdys9u3ooVr5MoWBYZfp3pM8Ti0msshWo9MwS+nS9YOol5mb4HPxv1x1Xxuojeg9e0jLfIZLgQTeLZUEw/I2aLpYWacX/6IVw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxMw+gvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxMw+gvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F5CC4CEEB;
	Wed, 23 Apr 2025 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421009;
	bh=ZK6GyPNmxdUgjZly8+ZUtsuzKtq1owZLb6kh+gDDjWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxMw+gvr+Oe1E/nNlk9DqpAtpJuov6QhXub0N63ik+a/KPPPMkSEgeMEj+HB3DL7I
	 fSFf1SuSGTv5wvUyN/1cS2KAWkhbLZ4g/m3RcRYsoHxABkB2AmoobG6Pm441UPcI7k
	 rdrn2VoL2BveyG/ZmI7GxDZWemd8PjmC1rtN/ZdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.6 135/393] tpm, tpm_tis: Fix timeout handling when waiting for TPM status
Date: Wed, 23 Apr 2025 16:40:31 +0200
Message-ID: <20250423142648.954872728@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

commit 7146dffa875cd00e7a7f918e1fce79c7593ac1fa upstream.

The change to only use interrupts to handle supported status changes
introduced an issue when it is necessary to poll for the status. Rather
than checking for the status after sleeping the code now sleeps after
the check. This means a correct, but slower, status change on the part
of the TPM can be missed, resulting in a spurious timeout error,
especially on a more loaded system. Switch back to sleeping *then*
checking. An up front check of the status has been done at the start of
the function, so this does not cause an additional delay when the status
is already what we're looking for.

Cc: stable@vger.kernel.org # v6.4+
Fixes: e87fcf0dc2b4 ("tpm, tpm_tis: Only handle supported interrupts")
Signed-off-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Michal Suchánek <msuchanek@suse.de>
Reviewed-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -114,11 +114,10 @@ again:
 		return 0;
 	/* process status changes without irq support */
 	do {
+		usleep_range(priv->timeout_min, priv->timeout_max);
 		status = chip->ops->status(chip);
 		if ((status & mask) == mask)
 			return 0;
-		usleep_range(priv->timeout_min,
-			     priv->timeout_max);
 	} while (time_before(jiffies, stop));
 	return -ETIME;
 }


