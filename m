Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C4335A93F;
	Fri,  9 Jan 2026 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960542; cv=none; b=TlF/z5NpzDDZIv5evNXf071OGDdMu28Mz6MOCyHuQvk32gTLagOOkBilfj6BqPZ2aLKRftuAt3GnmnjpVzFc0j0rG4VtckK+M0Z8LKsDJ2GgN9k6BO0aFyt0DlTunGGDDihp9NcoSD+w5hOHRzWZ3fDa4cl+NHRkwpwj1owAq4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960542; c=relaxed/simple;
	bh=yrwz8xOrob5degoenQy+AmEAVhb6yrgbJCFqFnIj2tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HIjL4NB4SwhvneXDJvqR5HufXBcUCl+TATuUwRCISXK8r1BDotVSAOuTCaIXk7RiguNYhmZYWvKiMNZWnDhRRL20frRD+yplXL6inS6wltQV2QhJbJ1mW31g/z+qBtoF5G3BYYbE/8chGoZ89BhRq5d02fDiQZBks+wbwHW5H4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ws70ZTII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ws70ZTII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9540DC16AAE;
	Fri,  9 Jan 2026 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960542;
	bh=yrwz8xOrob5degoenQy+AmEAVhb6yrgbJCFqFnIj2tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ws70ZTIIcxS9zlnzuC1VI1ieJvMRM8Ga99IxUVXughgq51YYllE04cicgmrSIv31c
	 MvzEPwTDfWmyHrMPL4UEO9zju57Dz5lgLC7wJxdYDyFDG7YbHmEW1FxALTrKNMfxNH
	 TlX4TavABMFWVKdkrdKfsYoNaJIU/ac5EmUW5p7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 441/737] char: applicom: fix NULL pointer dereference in ac_ioctl
Date: Fri,  9 Jan 2026 12:39:40 +0100
Message-ID: <20260109112150.580213890@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


