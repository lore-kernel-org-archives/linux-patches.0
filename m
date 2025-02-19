Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70781BEF82;
	Wed, 19 Feb 2025 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955749; cv=none; b=TQHGMlq90/0hW5kt80KPBG1BL9bbaaQ04nT7W91u/WNPyATiKeOsw986pFQlB8SM1EnvPBVprKiuOXarxD1MqBHgvLNvpWASPkcCy6aSMzosHpN+9Vaid/qmmEjz1kugd4ST0BpzEGqoMx30JgdSYvKGc9G0ny/Xp6mlBHQ/RZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955749; c=relaxed/simple;
	bh=OrhVNWx5Ekwm/cS6QyeKxPqk4st6pW0vJ2wXmLVkhLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtK+riYogkRarMXMHLNGteEHNd97fTO6WdPJhSVatB/WhoA4ol4M8xpCakCh0PD250k9d95tnGV7LBWiYTkRK16IOwOgCbvuLbokF4oi2V7ViBe4zVH7YFYlEFJM6wimeC2vPnwzHm9DScy8vNMKq2maF42AvUAWUt7QpwYGTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx0ecYtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx0ecYtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A92C4CED1;
	Wed, 19 Feb 2025 09:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955749;
	bh=OrhVNWx5Ekwm/cS6QyeKxPqk4st6pW0vJ2wXmLVkhLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx0ecYtI0GsBur/BbmSYNMUzAgsuy873U3eObeaT+LvXAM7INle71iQnO7rwIoRAl
	 YdGRZm0y38UL1hTJI00jclP4zhcDI5LUGgj+VqEzOua7IwocHnMtSaai6pwjFE2+hi
	 1I/Qqg8/g5/O1Gv+tWivfuudeobngHxNt5Xnnfe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.6 069/152] usb: cdc-acm: Fix handling of oversized fragments
Date: Wed, 19 Feb 2025 09:28:02 +0100
Message-ID: <20250219082552.776261796@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jann Horn <jannh@google.com>

commit 12e712964f41d05ae034989892de445781c46730 upstream.

If we receive an initial fragment of size 8 bytes which specifies a wLength
of 1 byte (so the reassembled message is supposed to be 9 bytes long), and
we then receive a second fragment of size 9 bytes (which is not supposed to
happen), we currently wrongly bypass the fragment reassembly code but still
pass the pointer to the acm->notification_buffer to
acm_process_notification().

Make this less wrong by always going through fragment reassembly when we
expect more fragments.

Before this patch, receiving an overlong fragment could lead to `newctrl`
in acm_process_notification() being uninitialized data (instead of data
coming from the device).

Cc: stable <stable@kernel.org>
Fixes: ea2583529cd1 ("cdc-acm: reassemble fragmented notifications")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -416,7 +416,7 @@ static void acm_ctrl_irq(struct urb *urb
 	expected_size = sizeof(struct usb_cdc_notification) +
 					le16_to_cpu(dr->wLength);
 
-	if (current_size < expected_size) {
+	if (acm->nb_index != 0 || current_size < expected_size) {
 		/* notification is transmitted fragmented, reassemble */
 		if (acm->nb_size < expected_size) {
 			u8 *new_buffer;


