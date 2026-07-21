Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A507E43901B;
	Tue, 21 Jul 2026 22:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672643; cv=none; b=Sz/hF2HCbiRU7Bbq+rHiLUFTGE0IKyuXGAjLpPajX6bvT8ESI2RMs3OdmGxZ058ASwL7pVxwW+mAPgyGetI0UXJgKyQQ5lVzUn0o2uMrRJPdIArcZzsJi0pn8/RYYHc8Mm5ZqrUrEYxnC6j+gBXzK0grz3qRZ5ojvBArcvIdDS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672643; c=relaxed/simple;
	bh=IRMZnJAup6FRy0Y1HxCXLSq4SLhFoR5q58nqKpWsdxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9otbTwnxN6bd9EmHQJWjz9SXXWCYiJTZWvWAeENl09G+JEv8aW6Ed1jjCpCmXx76SSSGSYuzNYq8AtEZZk52Er9Wt1bSsdLghzUPoUBpzgSCXnCCmP2PEdh/NLWo1tDdqqESb51lYe6wVpuAckPQgs+xTc3LUUDN1u1atfY6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcc18XcB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcc18XcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350DB1F000E9;
	Tue, 21 Jul 2026 22:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672642;
	bh=BGPuVlDUfw1ImPWcWqB8OV84A2S0qRPsRMQHrzGrS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcc18XcBYTgkX1oL7ougZ/ZAF4m3B5sVRVZBKKVtT7V6rKlDQsPCTyevvBFq53XjJ
	 JSJI3rkxxlfiWf//uhmzX+hfclbc3brAkkaJeEzLx7bs1nw3Zp9fhGdzspOpGRq9hR
	 gDjIrAnma4FIxYeAgitcphIcQWlEcQYrAi+vgwy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.15 702/843] s390/monwriter: Reject buffer reuse with different data length
Date: Tue, 21 Jul 2026 17:25:37 +0200
Message-ID: <20260721152421.841052642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

commit 2995ccec260caa9e85b3301a4aba1e66ed80ad74 upstream.

When data buffers are reused, e.g. for interval sample records, the
first record determines the data length, and the size of the buffer for
user copy. Current monwriter code does not check if the data length was
changed for subsequent records, which also would never happen for valid
user programs.

However, a malicious user could change the data length, resulting in out
of bounds user copy to the kernel buffer, and memory corruption. By
default, the monwriter misc device is created with root-only permissions,
so practical impact is typically low.

Fix this by checking for changed data length and rejecting such records.

Cc: stable@vger.kernel.org
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/char/monwriter.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -122,6 +122,9 @@ static int monwrite_new_hdr(struct mon_p
 			kfree(monbuf->data);
 			kfree(monbuf);
 			monbuf = NULL;
+		} else if (monbuf->hdr.datalen != monhdr->datalen) {
+			/* Data with buffer reuse must not change its length */
+			return -EINVAL;
 		}
 	} else if (monhdr->mon_function != MONWRITE_STOP_INTERVAL) {
 		if (mon_buf_count >= mon_max_bufs)


