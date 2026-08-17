Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C82F8EA2;
	Mon, 17 Aug 2026 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975304; cv=none; b=ZCSR5YyBj8h6+joRqLj/B+2JSIUfNKl5FMBWO/WUnnnE1dSJN1cV6uUOQv77LUk+fHwFqLigEL9crAG0dAybZxRtbO/MdNwXdAQ4jAckIrqqF0Kk7UqwGCbIZslyc+dXZGBNG0xQ804qyB/Wk3yvgcjt4WaEBzeS9gxiiOFJ7Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975304; c=relaxed/simple;
	bh=ZBwhgAdCr14eVLcPkuPBB4no9aSvAh2syITSOGo5QFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2fTPGYejem0LgQINEWsfV4IHLKaXPMo5qvxTbiSV0KYtRkf+fXVYqZG3h1QjifeSrgZdbER+TQif/jKbB70UrHxzcH2snulsC9S+hLwme1392QjWrnD7JeKn3Fxg2CSNYHjYVtLs34e6kK+mWuccSM1qCq0X4smfds1vZfysGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EeJSK+l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EeJSK+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D147F1F000E9;
	Mon, 17 Aug 2026 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975299;
	bh=NOQVG7cR4x7yb804U7lvZPgwGkK8aTEH/lnq8hupRpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0EeJSK+ltS7wJA8JqdreMAFoggvYDAutyvgmCe3RKKs9SM0XbuXzmjDNsHlG+3DUU
	 A0rPi0/7oP2tSlKDt++ImaK4J9c4Ccn84rEce4Ffg+yl3b8EGmGpShSlc8siD1qwg0
	 9eOztwogDzO13DFqk/euOGVZKwGVqVwDj5Sie+6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 230/250] ring-buffer: Initialise reader page order in rb_allocate_cpu_buffer()
Date: Mon, 17 Aug 2026 15:33:11 +0200
Message-ID: <20260817132545.897651315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit 6d014e44b68ddd43f71288d2a4dbb1a259869149 upstream.

In rb_allocate_cpu_buffer(), bpage->order was omitted, leaving it as 0.
This is an issue for a ring-buffer with subbufs bigger than PAGE_SIZE if
when freed: free_buffer_page() relies on this value. Align the value
with the actual allocation size (buffer::subbuf_order).

Cc: stable@vger.kernel.org
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Link: https://patch.msgid.link/20260806211306.3704194-4-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2361,6 +2361,7 @@ rb_allocate_cpu_buffer(struct trace_buff
 			    GFP_KERNEL, cpu_to_node(cpu));
 	if (!bpage)
 		return NULL;
+	bpage->order = cpu_buffer->buffer->subbuf_order;
 
 	rb_check_bpage(cpu_buffer, bpage);
 


