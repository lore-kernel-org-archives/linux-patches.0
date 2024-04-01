Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27171DFF4;
	Mon,  1 Apr 2024 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991105; cv=none; b=YnNEkB5lJWZYN+0S/g6/qB5vdxDxuPX2i/yngveM/lF8eG+jnHq8nXLNXRrIIi3MFvto0vh4q5cZetVuFxhyLmsHGN5p1AGmJVJmuf82G5D1cwn+XRSs2qpnEvfWl3I/3vhiE1F5cc+q/I2j4zWjU9ICAPB2wSsdppfIE9LZDn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991105; c=relaxed/simple;
	bh=TnCMbPSB/+2u6D9lBE9GlsBRztQQlxhTLUCaOqTfX5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6hFB7EHp0GOYTrQZ+u9LTjwxR0mxdW5ZVxoHTpgqflDLrCVBiDAFXZ7ABXi+iLcbX3uj8qZuaDM9Pu1VJuHOVaz/7tglo8pU2x+uQSdKvhhITRRRjvB5u3VVjxWTgnuIp6sTeBPbuk2OsjjI+kYoTfXAC15SMYwARWgcqrUtYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLOJeJv3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLOJeJv3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B88C433F1;
	Mon,  1 Apr 2024 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991105;
	bh=TnCMbPSB/+2u6D9lBE9GlsBRztQQlxhTLUCaOqTfX5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLOJeJv3s8kQHZZIBK6teySOoqKG+lRplsbhz5zxogu+dHy19bvlN47QufOuazxn6
	 5eELJyxBtK6Hwq90SIfWapB5ta04b7WZKQ+iQ6zXqBkxvufBn/rFLuV556uf14vS9S
	 a2RD6lCLemZoVvGo1xiUeJfCtMmKCBgiViTKpExI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Pitre <nico@fluxnic.net>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 165/272] vt: fix unicode buffer corruption when deleting characters
Date: Mon,  1 Apr 2024 17:45:55 +0200
Message-ID: <20240401152535.894234962@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -398,7 +398,7 @@ static void vc_uniscr_delete(struct vc_d
 		char32_t *ln = uniscr->lines[vc->state.y];
 		unsigned int x = vc->state.x, cols = vc->vc_cols;
 
-		memcpy(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
+		memmove(&ln[x], &ln[x + nr], (cols - x - nr) * sizeof(*ln));
 		memset32(&ln[cols - nr], ' ', nr);
 	}
 }


