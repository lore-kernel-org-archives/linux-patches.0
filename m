Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CBB27FB3A;
	Mon, 23 Mar 2026 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279397; cv=none; b=VdQZgSvy7Kwgbyrk1EeWCS3nWxWklJOmR8r6zXsE/XpSao+KtJKzcrXmCcQt9pYObQtbQjhsgZrKly5H1TlWq0gd7jep3q1SU/2zT3uvUhsbzXoRhK1mxn9KFLY4l8bYCqr/nConMFDFegR5FupS+0hLNllKpIvHzwAdx7QrTdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279397; c=relaxed/simple;
	bh=0b/VYNWkbKgUA1sAH/PVCzAy/UBntyJ2qKuBlh159js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OejEs2TRN1XWoQ6xrNQ3tupyXKwa+O87j7EkWLykwNPw2POa4RB1suYfmGahf9K9ilNZJvgQT4VIrW2+b2UvvFqF3lwbVAT5idR5w+fNiaAvnbkMzEQEdP3bnKvebO917hVwMw6RwTo/X/7voirBm/P++Bv2b764RQHp9oGAVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BByI9335; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BByI9335"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE476C4CEF7;
	Mon, 23 Mar 2026 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279397;
	bh=0b/VYNWkbKgUA1sAH/PVCzAy/UBntyJ2qKuBlh159js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BByI9335FfMLOnVsv7O1pmZUMYkFnIcTabIJINVeij3PrsUR1BRXkle3QcODICR11
	 7WR2/8VwAfDhV+YtHwuaun135jtj1JD0JL4zU1yo9YfP7FARQBC7O+unYCANkRZXgZ
	 4RCMpONnYhXSy+P4+XsFWAmF0UcCa1r44Jo8rB/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Meyer <kyle.meyer@hpe.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Steve Wahl <steve.wahl@hpe.com>
Subject: [PATCH 6.6 556/567] x86/platform/uv: Handle deconfigured sockets
Date: Mon, 23 Mar 2026 14:47:56 +0100
Message-ID: <20260323134547.755569608@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Kyle Meyer <kyle.meyer@hpe.com>

commit 1f6aa5bbf1d0f81a8a2aafc16136e7dd9a609ff3 upstream.

When a socket is deconfigured, it's mapped to SOCK_EMPTY (0xffff). This causes
a panic while allocating UV hub info structures.

Fix this by using NUMA_NO_NODE, allowing UV hub info structures to be
allocated on valid nodes.

Fixes: 8a50c5851927 ("x86/platform/uv: UV support for sub-NUMA clustering")
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Steve Wahl <steve.wahl@hpe.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ab2BmGL0ehVkkjKk@hpe.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -1760,8 +1760,22 @@ static void __init uv_system_init_hub(vo
 		struct uv_hub_info_s *new_hub;
 
 		/* Allocate & fill new per hub info list */
-		new_hub = (bid == 0) ?  &uv_hub_info_node0
-			: kzalloc_node(bytes, GFP_KERNEL, uv_blade_to_node(bid));
+		if (bid == 0) {
+			new_hub = &uv_hub_info_node0;
+		} else {
+			int nid;
+
+			/*
+			 * Deconfigured sockets are mapped to SOCK_EMPTY. Use
+			 * NUMA_NO_NODE to allocate on a valid node.
+			 */
+			nid = uv_blade_to_node(bid);
+			if (nid == SOCK_EMPTY)
+				nid = NUMA_NO_NODE;
+
+			new_hub = kzalloc_node(bytes, GFP_KERNEL, nid);
+		}
+
 		if (WARN_ON_ONCE(!new_hub)) {
 			/* do not kfree() bid 0, which is statically allocated */
 			while (--bid > 0)


