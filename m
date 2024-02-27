Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE02C13B2AC;
	Tue, 27 Feb 2024 13:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041049; cv=none; b=eL3RyvOSCct4/NJcghZJX/EFMadoK6Sr7cjredFl9nX2XPdO1FciRjw/THo8w2gv5DIW0OvJWrDdZRGaz3rVNrwVRFS0ZyPfEyWRVStfv+JaeZkSY7WdKjgkzU6NuVIT4BZJr8SL6AADMMnh9CFrl1WQ0WSwcMAEBWKXUrSsyCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041049; c=relaxed/simple;
	bh=xTciEU1GQCFTM2km+Vu5a9Zh9qhZzfsrxJwk+nC/9gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4KeSdFxdadnn2layp0md2pulaK69DWmZ9V8jbs885k1KhV7IL42T+AbJ8x4Zuy8TkrSwOmHMsauaKfO1OafRjwiBANIhKlZWApxWnCRCmxIdnx9uAL3kFDh28lo5eVtY/iPfgl5PLuB7vWzai4mCvrg7X9ne68E/WlHEy8KxFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ut3a0BhR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ut3a0BhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED38C433F1;
	Tue, 27 Feb 2024 13:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041049;
	bh=xTciEU1GQCFTM2km+Vu5a9Zh9qhZzfsrxJwk+nC/9gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut3a0BhRxy+KE2JkhRmMKsC+aLsqDdDjoVc3vPNJIHG8D1ymvMq43GxVOZe/jTj1r
	 X83RaKgffnwtkGYwQF7OdAzeJZUU5XHZ/4S0vcPVpVGe+RafZ1uymn8vMPj3PWTzCj
	 f/x3G1F+tfZ+ujDSHkEV77C+7/lXtDejWvww8Pig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Jirman <megi@xff.cz>
Subject: [PATCH 6.7 201/334] Revert "usb: typec: tcpm: reset counter when enter into unattached state after try role"
Date: Tue, 27 Feb 2024 14:20:59 +0100
Message-ID: <20240227131637.215777365@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Jirman <megi@xff.cz>

commit 23b1d2d99b0f55326f05e7d757fa197c4a95dc5c upstream.

The reverted commit makes the state machine only ever go from SRC_ATTACH_WAIT
to SNK_TRY in endless loop when toggling. After revert it goes to SRC_ATTACHED
after initially trying SNK_TRY earlier, as it should for toggling to ever detect
the power source mode and the port is again able to provide power to attached
power sinks.

This reverts commit 2d6d80127006ae3da26b1f21a65eccf957f2d1e5.

Cc: stable@vger.kernel.org
Fixes: 2d6d80127006 ("usb: typec: tcpm: reset counter when enter into unattached state after try role")
Signed-off-by: Ondrej Jirman <megi@xff.cz>
Link: https://lore.kernel.org/r/20240217162023.1719738-1-megi@xff.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3730,9 +3730,6 @@ static void tcpm_detach(struct tcpm_port
 	if (tcpm_port_is_disconnected(port))
 		port->hard_reset_count = 0;
 
-	port->try_src_count = 0;
-	port->try_snk_count = 0;
-
 	if (!port->attached)
 		return;
 


