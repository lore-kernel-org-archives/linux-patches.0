Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563703557EC;
	Tue,  6 Jan 2026 17:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720289; cv=none; b=eo7iH5m0qQQUN1jNEJgRff6SPs4D1OGeASClz7Grys/EygmIzFvv2va2oO51uZCbv77RJ8K4qH9T3voRqA39uOtG3/5FjLrCCX7LtVgQopjw4zAJdwST5fgnHOIICbzkQmebcQc5wjdlOlcXQ90oGxZxVRQR8lABXS0tOhGoFQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720289; c=relaxed/simple;
	bh=pTXFzuaHQpMVtiGKB0F1WG/Om2TlgfZvi5DfmNat9GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjOsC5q5O64GjtrOQNUZaPTKAg6pdCnUodzA7VEPmoJwnZ5pVo/zFejOgL+SDnqt8HrQHGd5f8jj3bNi6fP1USnr4Xvwwc/pRcEgaWyF6zr7pK6uzm2cwCBiX0U7Jln53GQcBsUjGXms7dZQl2mN7jHGKE1W8sck0QNby9j9Jo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+RCV9gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+RCV9gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5C8C116C6;
	Tue,  6 Jan 2026 17:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720289;
	bh=pTXFzuaHQpMVtiGKB0F1WG/Om2TlgfZvi5DfmNat9GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+RCV9gveSBtHxwsh2ShvAgOXBayDu+N21NFEhdxxo/L51C8+GmDcQkbYdKOUjLTY
	 AOeCgqrXmwMpYHTHfJ9I15tl4nnP3tppHdaVCO94UL3jnJxm6OPd6YlerK5KmoNe00
	 9984AAySUQeOfrBWONRO4EDdroD5c5sPrYv6exR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 191/567] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Tue,  6 Jan 2026 17:59:33 +0100
Message-ID: <20260106170458.392150173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit 82d12088c297fa1cef670e1718b3d24f414c23f7 upstream.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

In ac_ioctl, the validation of IndexCard and the check for a valid
RamIO pointer are skipped when cmd is 6. However, the function
unconditionally executes readb(apbs[IndexCard].RamIO + VERS) at the
end.

If cmd is 6, IndexCard may reference a board that does not exist
(where RamIO is NULL), leading to a NULL pointer dereference.

Fix this by skipping the readb access when cmd is 6, as this
command is a global information query and does not target a specific
board context.

Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20251128155323.a786fde92ebb926cbe96fcb1@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/applicom.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -835,7 +835,10 @@ static long ac_ioctl(struct file *file,
 		ret = -ENOTTY;
 		break;
 	}
-	Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
+	if (cmd != 6)
+		Dummy = readb(apbs[IndexCard].RamIO + VERS);
+
 	kfree(adgl);
 	mutex_unlock(&ac_mutex);
 	return ret;


