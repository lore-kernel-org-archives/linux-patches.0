Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE1266F16;
	Thu, 17 Apr 2025 18:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914447; cv=none; b=qI6Wup6+h+07LaRTKfj75Ke9htrZe/EdkqYBcA8NlBpgAanjMyP1Uz2OPYHgyHJqY8E0o0pM42J5xasF7+4M0WJgCpmKv4c8wWf8xPJrWylZt6mymcBjd+aUfXIZQxabvLP6GuRmZUiaSWk6VHO8JQNHcrXmhKq7tOcw1lYhf1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914447; c=relaxed/simple;
	bh=KmsZuKgum0nurBTPmQiKINF2UefJY3n6PxNuUiGdv4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpJHB/GvlzDbA0CG7SpBtEIGhGlHsesnqpsLlIMNtybaSnBd9muP1d7qDLIRmRRBkzU8/KmCIhRRH+ZAYziYbQz4BX3USyQ3HIczMwI+AiPFjVCO7ZU26x8S/J+jR2mF0wC+DfTurbxmdIIjMIqFSj3A6gnEHC2dkAT0GjVlZTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6NjDXDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6NjDXDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F023AC4CEE4;
	Thu, 17 Apr 2025 18:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914447;
	bh=KmsZuKgum0nurBTPmQiKINF2UefJY3n6PxNuUiGdv4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6NjDXDicIdSMpOWjIgIZOF0OqtuwIH1Nbg4NeJ+4liDV6mQrGPbY2K6OgXUM1LnS
	 Y+Do1cj1m2lyO3AhxS+J/+FQyCjKLH6PwRby0xjwy2ZHg9yR6Ujxz7C9v4ZEA3Q5P7
	 Nl0SVhguSPtTYjlVCB7ILih7aOQJQCfDUyhsMoyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.13 219/414] tpm, tpm_tis: Fix timeout handling when waiting for TPM status
Date: Thu, 17 Apr 2025 19:49:37 +0200
Message-ID: <20250417175120.240790563@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


