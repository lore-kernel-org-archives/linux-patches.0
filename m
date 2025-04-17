Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9E22580C4;
	Thu, 17 Apr 2025 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913141; cv=none; b=nWnaRzvwhAwY8AJItFP5u75dgybGD9aZumNKxrbR9IAVEfS5XXjzif05LnDNA65Um5zVb2rxXMWUaaosGGyjPMxXdhMjIHaiTcF2MzHe8ASZAera/mJCAg9zb6HG+1NCrMqWGxWCo064GSPpjOxmMfL5sYVmWNT4WkbdfnE+x1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913141; c=relaxed/simple;
	bh=35NX7QTC7QVshmajE/uAG10fze/qRVtMRKUmte2B5+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sQa1Tqfid49eyV4iTXGtNxyy3BfqyN41bVP7l1yZOW5c63hxM9AXAgxXZcAi9XXMO6Xa73kRHpa6EhrtOqDHzD0UkaCzqJHc577kLk8Vxov8w+ymNbR6CFW7cePi2oOXFRLssR1L1AyX5SQ8oMT8G7GGfY50rfuKlj78UBAwv/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wh+NyHiM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wh+NyHiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC5AC4CEE4;
	Thu, 17 Apr 2025 18:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913141;
	bh=35NX7QTC7QVshmajE/uAG10fze/qRVtMRKUmte2B5+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wh+NyHiMHBz0+79xEJoBHNWGPmWB3QvvNcnyIhNagd5amlfoQLKnOFf1YcJLOpzw8
	 Cz6L1Qy/u0VWOvS/aY/F/9SKtUvVgOA43DT0933IbLuZwqqoHvx9nw5zyY1uj8Yd48
	 /1sndUl+sBPLRpJYrI2CE+c41Y/M9Csp1DAJXF8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.14 241/449] tpm, tpm_tis: Fix timeout handling when waiting for TPM status
Date: Thu, 17 Apr 2025 19:48:49 +0200
Message-ID: <20250417175127.695789131@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


