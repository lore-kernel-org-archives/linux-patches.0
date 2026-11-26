Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705524;
	b=Xp77p6BuW8dlE7mLiSHx2su075oqFIt5mILxc5EfPA8S3sRV5N6+Z2YKnzPBdDb2cDqw
	 VytFeBw/Gpe8ZPfJT5k6chrJYIgSOI5x8NOSbAAXtkII4YGAfH1LitpVJvsy8iS39DDJh
	 55HCPzsrwHver2xWCEFma08xqxoOKKajEdUeEPS1YLD2GcJCOY+g03PsgidFxPg1gVxsy
	 oIgQLp0VaoE3xSloSHNO5YlefEgH+AktlQX18K5LguWiRFmAS3w7FVfJ3Sa6U5u0yrujJ
	 TXs2aW+aZ3N7Qs/hsl/XI4yj7PwQJXZoVAfVNO4CVavBj4pWDzwcZKTaWdhPIwHrAaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dPY24d8JmL9Dxegu0y1C8MCyotlEnbL9FS1K6b7DBCo=;
	b=xexfyuurbMLFQjLOXeDX0TYiNpVuivR8OE8oWAEUk8iforrCfdEySvVJo2NTCi8YRDS4
	 xJsiy1RWY/YjZh7qBJWGDMAad4XmlXnwzzfKKjldPQaqUI/K5EXJajDnUfhhjtQKRW7S6
	 XlvYy+ohkGKcL+JHpK8xdq+QbfwGlEgmaTjh+7uooW21YRUyfPSw0mMNmwNlDu4e1FCeE
	 ORuT9yv9pK1deUqNJUrd7HidoqE9BLRsnbFwZmxJV8YSzKdOwXz+LddaRrezl6r4Ji2yA
	 qzz/Z2iKvBq7Y3L6tBNOyLWFKCULaXE6rLQGD6yxyGTKgHUisr1OU8Wf0+HTwyDtKZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeFjdn7R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C201A606A336;
	Thu, 26 Nov 2026 15:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XeFjdn7R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A621F000D1;
	Thu, 26 Nov 2026 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705524;
	bh=dPY24d8JmL9Dxegu0y1C8MCyotlEnbL9FS1K6b7DBCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeFjdn7RWpftInhslC/Tj2mqAVMhTWiv+TOF/Q0/RqENwe0FwxpfNjFWTh+Xa/gyG
	 COc+uzK1tytlrC5ce8pNULS8sAl4koibEymUsq5eVKaeEoAPKU5gJe1/P+MKLPW58E
	 97iLhR6uz9T9V6IULeu3a/44c5BfdE4ggp7mjVlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 228/319] tracing/eprobe: Fix 1-byte signed field fetch in get_event_field()
Date: Thu, 26 Nov 2026 15:39:56 +0100
Message-ID: <20261126144011.894972264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a0f836eea463d4c468edb58eedb03911c9c0791d upstream.

Because the kernel is built with -funsigned-char, plain 'char' is
unsigned on all architectures. Reading 1-byte signed trace event fields
via *(char *)addr in get_event_field() therefore zero-extends instead of
sign-extending negative s8 values.

Use explicit fixed-width integer types (s8/u8, s16/u16, s32/u32) when
reading event fields.

Link: https://lore.kernel.org/all/179455852542.403392.15666310371702309464.stgit@devnote2/

Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -343,21 +343,21 @@ static unsigned long get_event_field(str
 	switch (field->size) {
 	case 1:
 		if (field->is_signed)
-			val = *(char *)addr;
+			val = *(s8 *)addr;
 		else
-			val = *(unsigned char *)addr;
+			val = *(u8 *)addr;
 		break;
 	case 2:
 		if (field->is_signed)
-			val = *(short *)addr;
+			val = *(s16 *)addr;
 		else
-			val = *(unsigned short *)addr;
+			val = *(u16 *)addr;
 		break;
 	case 4:
 		if (field->is_signed)
-			val = *(int *)addr;
+			val = *(s32 *)addr;
 		else
-			val = *(unsigned int *)addr;
+			val = *(u32 *)addr;
 		break;
 	default:
 		if (field->is_signed)


