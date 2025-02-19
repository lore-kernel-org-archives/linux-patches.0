Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466DF1D90B9;
	Wed, 19 Feb 2025 08:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954365; cv=none; b=rJ6QTZDHYzKfk1Y4tAFbhk5E2EpNeBBEhkPDsLqmLuF2OnaID1KwsPFiP4a1NF0jwxWVGS2yDdV2/KGWY3l50yK7vqh/tTXGYl1ZvmTTifs1/Lu1K3Q+6gIsZJXxASPvRgpPnouGDWP8vvLSLNcwaWBQici3NFCoL5Bbro9N2Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954365; c=relaxed/simple;
	bh=zJtzt7jtP7iVLhoWrVtt96e7al5ycJYQ5FcljtQec0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rnh8WjNUNlKBQ30c2qkHsH26Xf+UMN/zyGXi9wgbMpDkebBv9QTPBkZhCsod9kiMiaCKa6fxPe6aSQmqkCWNGRCTn15c9Ds9Umq3RL6fL4a+YILvSi4yIvHVPx7YJm1X1ZlnjFmiIsC0NTbxkMk63LP+47GDUQ0FcUj6T32ZHC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqLWVguF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqLWVguF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B983EC4CED1;
	Wed, 19 Feb 2025 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954365;
	bh=zJtzt7jtP7iVLhoWrVtt96e7al5ycJYQ5FcljtQec0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqLWVguFMVI0/T00vnS/fwZDG40CG5KaOGNgTPLlq+Bju8DRtasm3SiwWu8PYsV4s
	 w0WvXAddwNTdNGRJ/ZTt9eGb0khVvqTqT4Zvnj2XdvRKZLX/F4jFvQxG9A2ctFY1bD
	 UXFqZN29GVK9z2xoWrjzQViOF5Y+bD30jcqjWWzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Richard Cochran <richardcochran@gmail.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.13 182/274] ptp: vmclock: Dont unregister misc device if it was not registered
Date: Wed, 19 Feb 2025 09:27:16 +0100
Message-ID: <20250219082616.706264772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 39e926c3a21b25af6cae479fbb752f193240ce03 upstream.

vmclock_remove() tries to detect the successful registration of the misc
device based on the value of its minor value.
However that check is incorrect if the misc device registration was not
attempted in the first place.

Always initialize the minor number, so the check works properly.

Fixes: 205032724226 ("ptp: Add support for the AMZNC10C 'vmclock' device")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_vmclock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -547,6 +547,8 @@ static int vmclock_probe(struct platform
 		goto out;
 	}
 
+	st->miscdev.minor = MISC_DYNAMIC_MINOR;
+
 	/*
 	 * If the structure is big enough, it can be mapped to userspace.
 	 * Theoretically a guest OS even using larger pages could still
@@ -554,7 +556,6 @@ static int vmclock_probe(struct platform
 	 * cross that bridge if/when we come to it.
 	 */
 	if (le32_to_cpu(st->clk->size) >= PAGE_SIZE) {
-		st->miscdev.minor = MISC_DYNAMIC_MINOR;
 		st->miscdev.fops = &vmclock_miscdev_fops;
 		st->miscdev.name = st->name;
 


