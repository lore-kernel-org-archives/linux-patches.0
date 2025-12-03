Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646A234B1AF;
	Wed,  3 Dec 2025 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778467; cv=none; b=XorI5DeWTD/dxLg2y23qgNj8pyWcpKRxU3t6ZI+yDNa7J5OcUNy6seW+xAcU+0PwwrDPQret11DpK/PTDvf1uaBlnSENPZ4XKuAkVu7nA/p+gN3yfiu1ivS803/QXEnjY30OUXn5Ho6SqX9bsoUSAJgUoMJyeC7dauuZisBUFfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778467; c=relaxed/simple;
	bh=5iFkhH5VKV08EqvqqV2mjrQkQvOQ1spZXaygcqGnBsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvZJxfq1GXD378s5rMh9AU2Qm5R57DZMV0iGdmAt++FFvXIhO598QGrzLQ1NylEjAPeHG4tSFxdM89dvvGQlJ+fiWjZMcT8juhywYQAzto8T1aTMJ7sk76Rl3du2J3xnEtoZeuV/wK7gkjewS0r3CrkhAn3ZDgWy5YfUXYDWnqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThFVX1PT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThFVX1PT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EDDC4CEF5;
	Wed,  3 Dec 2025 16:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778467;
	bh=5iFkhH5VKV08EqvqqV2mjrQkQvOQ1spZXaygcqGnBsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThFVX1PTKrGtNRHcNSfYl50Pnos7g+hGcgoYWB9QcT8IZVmZnwJ+rTlGoHykGsYOA
	 ArHV2IUSxx27YdWi7QC5o2EvEC9bUMbNAL77Jqltn+CouLZzMXa0n/hEiqtEY8Xakq
	 1K28U6wQZRIlg3DEqd1s5wN8Yl3D1cZ34RyyBO34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 355/392] atm/fore200e: Fix possible data race in fore200e_open()
Date: Wed,  3 Dec 2025 16:28:25 +0100
Message-ID: <20251203152427.229576140@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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
@@ -1377,7 +1377,9 @@ fore200e_open(struct atm_vcc *vcc)
 
 	vcc->dev_data = NULL;
 
+	mutex_lock(&fore200e->rate_mtx);
 	fore200e->available_cell_rate += vcc->qos.txtp.max_pcr;
+	mutex_unlock(&fore200e->rate_mtx);
 
 	kfree(fore200e_vcc);
 	return -EINVAL;


