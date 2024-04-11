Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F85145B04;
	Thu, 11 Apr 2024 10:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829714; cv=none; b=lFfcpIk4elo14RYYg7PgVS38TL93N+NsnRT3MbuJpUVnbu7yokbBQ6o9bJDFdX4E9gxS7SYmDPj0mBSzor+n+pT251B/c5dsXB8mpO5BDQoiA0TV07DYGYAqX9unZwS5Fq5UNS7a5LjovaBcny4Wus0FDWVzB5wgGJyiU3t2EM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829714; c=relaxed/simple;
	bh=5LGUp0flJXYBP/VOho2tB1xuJ6Y9zCdy9tUWB/lEtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5Ex2ILyU5K3nLxlezQwzTCW6AEh8vEPXZKtcnlp1L28vP1IykOQRGQHBD4GywMWudD3VbqlKEozFXDioPK3ZG4eNIP3GTNpcmq9JrZN30kjhdJO9ky7yuKYZSqGTYhwS7z+YOf3/IJhGTx0RceFCdxCeZzKsDTynKekNgSjczc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fr10Qur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fr10Qur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED424C433C7;
	Thu, 11 Apr 2024 10:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829714;
	bh=5LGUp0flJXYBP/VOho2tB1xuJ6Y9zCdy9tUWB/lEtPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fr10QurT28hHO6M8XE1HmSJcfNEBNw0u507jIXZEekUrKPijLtm9WDC6a0K1xCyI
	 9bPkx5kt7aIMGuCpjlTLE5bWdmUWVrFL3IBziwXvDxnHgvVXSk8c9EbzlIp/UN+zN8
	 vp0OS0IALaGfhjT0bNf0G4lUgAMdPTTy0+ygiZeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 078/175] vt: fix unicode buffer corruption when deleting characters
Date: Thu, 11 Apr 2024 11:55:01 +0200
Message-ID: <20240411095421.911662867@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Pitre <nico@fluxnic.net>

commit 1581dafaf0d34bc9c428a794a22110d7046d186d upstream.

This is the same issue that was fixed for the VGA text buffer in commit
39cdb68c64d8 ("vt: fix memory overlapping when deleting chars in the
buffer"). The cure is also the same i.e. replace memcpy() with memmove()
due to the overlaping buffers.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>
Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/sn184on2-3p0q-0qrq-0218-895349s4753o@syhkavp.arg
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -405,7 +405,7 @@ static void vc_uniscr_delete(struct vc_d
 		char32_t *ln = uniscr->lines[vc->vc_y];
 		unsigned int x = vc->vc_x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


