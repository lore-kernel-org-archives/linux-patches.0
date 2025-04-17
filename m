Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A271DE885;
	Thu, 17 Apr 2025 18:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915692; cv=none; b=o9OlTUexRZ/pnJduKZ/E5NawDxcgAGtgW2WISV/Z9KY2FTLYFmC/I2JNukRWle//O8qn5Sho2aMJgQzAmr7O3IPGAu/iH0RfTs3WVu5WbpQ6In7RCZIUWkxnWO/JEFy7wcS1UMb2VXkbWulNRszAJ5nYvqdoPyM/Fx2e5zZ7y8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915692; c=relaxed/simple;
	bh=Nnl9iSOPl9AZdB5YDdF25k4Yn+NeBY7qEHWs4l9yTQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b04lCpKb7XPZHXAvfQ1rMfrrbVfew8BVNnoJGJuw27OfT68aSnEhQV8dEoUHZILjK2jEyhjHykx6iGbSLfOGCS7AYYb1xtty5+CA3FuIEq6SBwTNONshHu7Aoshetb1KrhgeTneCdGUmp0I2scP0Y2Vpeer/YYCYCYcKwKIzzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyOfWCX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyOfWCX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEC3C4CEE4;
	Thu, 17 Apr 2025 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915692;
	bh=Nnl9iSOPl9AZdB5YDdF25k4Yn+NeBY7qEHWs4l9yTQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyOfWCX/QvYZbgdlFM3iTn/n+LckqWyVgTagAWrtzCzfZO59O3qtfr0f+ii6XLuG/
	 iqP7FRHFQ2YsWfI3CFj4A1le7MNmt1Hpk3i1Q/htZ1USv4Qf6hXbGWNaUA49T77jD5
	 gq0rskpIXV1661DXgSI4LO8PMsNOvK9F/qDlbVBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 209/393] tpm, tpm_tis: Fix timeout handling when waiting for TPM status
Date: Thu, 17 Apr 2025 19:50:18 +0200
Message-ID: <20250417175115.985393680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


