Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C83D35B142;
	Fri,  9 Jan 2026 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962376; cv=none; b=MWe4OBaLmKpiqI1GzMAFjy4fxEP8PKN01to55Ku9mGfpVZmRBOyhyy0xoKvbJvZkGlmskE5xLfHPruloBw1VSXoL3t+krXcG4sljRR/vhOrFy4TedaSpGF9wZp0ANCcf39kTZi4gdz9R8+ZS6tbbD7mSqmsBXYYSnhr+LeiNWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962376; c=relaxed/simple;
	bh=J84TDmOUqzwtMKRr5KALRUcT/adCKddMTx4Gd6hNEzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1kIcldRNJjYhZyj1OXcCoVqXlDhEk5VD2QD4YGM7SH9dQ/4kDiS2d+9FlirW4QTXVNXgEvIsoVm4uoHv8nFmK7uRCF+k6bnt7Vj2rfMFmbBOKpdeM9NhRYjGAAC8igLCBYS9x/hwtjL/N3TOYYTW+9T5peu7/VHiobmRmrkBD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJRWTqp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJRWTqp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9D6C4CEF1;
	Fri,  9 Jan 2026 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962376;
	bh=J84TDmOUqzwtMKRr5KALRUcT/adCKddMTx4Gd6hNEzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJRWTqp03Qe2+M5J8/Vs9Ka5hNuZ9vlJ1YCIuQVR1C1D799Y6GUWFXLjOX6UQlLH8
	 kFSrbgj3cEXvSGwnHkOK/R8EvTdDQbHnO7KfPzoM29jzo3fgoKdouof5/ISLOqQk12
	 UNz+rdSKLlm7vTx5MyMWvvnkcT0gF3hWT2++Dzis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 342/634] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Fri,  9 Jan 2026 12:40:20 +0100
Message-ID: <20260109112130.393155329@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -836,7 +836,10 @@ static long ac_ioctl(struct file *file,
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


