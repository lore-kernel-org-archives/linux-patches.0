Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C0C32F769;
	Wed,  3 Dec 2025 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777095; cv=none; b=j3T1/390UWW65hQQSGmeZEhcfHMsJcWC7fP5zLPcD53GnBhdfYzMaVw3tKZssKhIYHAs5c9/4d5YCddcumI+tJk5aZ5KbHM0DaMZihMnCLBbWXYutWVEzLamxsUIR5tyqeC8veUYLvVlAfJnNa7RKtlbCFjc9COpDwKbJ1x1nGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777095; c=relaxed/simple;
	bh=Fy7NbzI6O1/J2zc1bpyTxTYevGDR3Yp7VBm5a8Zm/Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guhSEcYATltPWP+cmKZcuKtmSBPO4rNh8n3qG+1liCnHHb8ryM7iF92nA2zF2GS3gCcds4mS/+6AbJSTp8yUMyNe6tBHH1yA5UZj9pk7WU8hzwTUkdNOpaoU8ARLnUXmtJ2zwS743YNQze/hvbh0xndHoMqanyv1H9+1qyOtrqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih3AEMSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih3AEMSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB626C4CEF5;
	Wed,  3 Dec 2025 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777095;
	bh=Fy7NbzI6O1/J2zc1bpyTxTYevGDR3Yp7VBm5a8Zm/Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih3AEMSEtfB+lXwrjKqVNRYxTML/Q6sXGqYCuCdjeZPANtQPIrm5gyD9cS7ejZl8q
	 GqicJm60ti0lJ+ulmRLo/ZOZs89qg/cBiU3WqX7Qw4HWiuxqtQoEQJGnnZksRf+KNT
	 19fLDmT59EaJN2edNTvUHJXJbcBmo8lME/lF2+NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 081/146] atm/fore200e: Fix possible data race in fore200e_open()
Date: Wed,  3 Dec 2025 16:27:39 +0100
Message-ID: <20251203152349.428434208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 82fca3d8a4a34667f01ec2351a607135249c9cff upstream.

Protect access to fore200e->available_cell_rate with rate_mtx lock in the
error handling path of fore200e_open() to prevent a data race.

The field fore200e->available_cell_rate is a shared resource used to track
available bandwidth. It is concurrently accessed by fore200e_open(),
fore200e_close(), and fore200e_change_qos().

In fore200e_open(), the lock rate_mtx is correctly held when subtracting
vcc->qos.txtp.max_pcr from available_cell_rate to reserve bandwidth.
However, if the subsequent call to fore200e_activate_vcin() fails, the
function restores the reserved bandwidth by adding back to
available_cell_rate without holding the lock.

This introduces a race condition because available_cell_rate is a global
device resource shared across all VCCs. If the error path in
fore200e_open() executes concurrently with operations like
fore200e_close() or fore200e_change_qos() on other VCCs, a
read-modify-write race occurs.

Specifically, the error path reads the rate without the lock. If another
CPU acquires the lock and modifies the rate (e.g., releasing bandwidth in
fore200e_close()) between this read and the subsequent write, the error
path will overwrite the concurrent update with a stale value. This results
in incorrect bandwidth accounting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251120120657.2462194-1-hanguidong02@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/fore200e.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -1374,7 +1374,9 @@ fore200e_open(struct atm_vcc *vcc)
 
 	vcc->dev_data = NULL;
 
+	mutex_lock(&fore200e->rate_mtx);
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
+	mutex_unlock(&fore200e->rate_mtx);
 
 	kfree(fore200e_vcc);
 	return -EINVAL;


