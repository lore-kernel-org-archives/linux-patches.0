Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207137;
	b=tu74uw5Mr4Bc1FGmk1XKuAbR9a1ZvONu2cKILf/b7RZYvXoXfZf9v7UDLVfngti4/Biz
	 0i+ZZp56b8zwmCxnJ4rG3tEiW5DzLzyJAs/VgiUb1hQLB5S596wMDbBn8Iuh3QyZxU8v1
	 e0GWRSxZ5qaNwOADQNT02pVQ6mj+PybhsZIBNXcIIcKO9ObRWCMT4JxU+6F5URDChNxCL
	 R1kWpQ73vDU+v2wbR/I7Z8sJAx/HOunv7BHcmU6QWdohHJ/xFgReE/viVtPleqzOsjS0I
	 oDHB8nalXhUOQ6c+MCp4v7YcOMfnOHRjzp1YUUl4S4q6iJLGGH3yhyeCMtV5Pasxe6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etlnVoDWP+qZVXm8BywI1awyz9nqd0Epmpdb2fpDMhU=;
	b=A06MU3NJRnyxyEHSU9OL2i/NF1Jz6S8IeAKlYm8OY+H9nYmMNXW/ErRtEbG6lAvWvsne
	 dDJUNv9qhM8uaR43IP+TzY2wSiWIFawNpa+2hfHGnRqORQhnOEwydmou/Qwc1/epkE56m
	 g9irSyeQmbmRY/DO0Y5Ahp8Nm+eISDZ77xS8znuo3kjlpfOemEpkGZytuk2EZAfguvFoq
	 +3kg6Uxg/5GD0RfP4em4YAIU2vFT9KjK2+6nFlkRtRhgFy+/Nr+Q1LDJoTLrgzKrFxcSm
	 d36rf0oV9VsOEMcb9Uw2Tki4VL382Nb8XzSm50g6+bk+SulQntML7u1EAr4yMLIFt0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K961b3D5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACB0606A322;
	Wed, 28 Oct 2026 17:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K961b3D5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91501F01825;
	Wed, 28 Oct 2026 17:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207136;
	bh=etlnVoDWP+qZVXm8BywI1awyz9nqd0Epmpdb2fpDMhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K961b3D5Jpbz970VfsuU7qrdCZ/AqBactgElwRMTN0Q1r0ISlyrBh/QtTbfYzPlQS
	 O9XcABmvUXaoaSXhZdTmgU+DXgF/P3dzQq44KkLjqPekyzVHU296ymxDCw5/hv6URN
	 gM1tlcCoEPT8GPEncaGT99N1VEH6CyR4a4dtYSfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 05/38] tracing: Hold trace_types_lock when updating modules in persistent instances
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028165940.540686254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 66877a312ae3c2c3d849e82e882f642ffd4ec3e2 upstream.

trace_module_record() walks ftrace_trace_arrays from the module notifier
without trace_types_lock. A concurrent rmdir of an instance removes it
from the list and frees it under that lock, so a module load or unload
can walk into a freed trace_array.

Cc: stable@vger.kernel.org
Fixes: 5f3719f697c3 ("tracing: Update modules to persistent instances when loaded")
Link: https://patch.msgid.link/20261016061638.214847-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9263,6 +9263,8 @@ static void trace_module_record(struct m
 	struct trace_array *tr;
 	unsigned long flags;
 
+	guard(mutex)(&trace_types_lock);
+
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		flags = tr->flags & (TRACE_ARRAY_FL_BOOT | TRACE_ARRAY_FL_LAST_BOOT);
 		/* Update any persistent trace array that has already been started */


