Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5786B62148;
	Mon,  8 Apr 2024 13:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582410; cv=none; b=N0Rbffufc+Mdxj93Byns24sPEIx3gHwJliiL5Fei9PYHWzWujxuuBf7iB3LVxFdHU6SmTazC2us4THzaf4mhYrMBz4GgbiUPMXAwXuLc84DJxPYUHijjl5ShcEk7vJg5H2b6iArqKaRCtHg94LaLXqjTjIjRXlZHbQopWMMGTRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582410; c=relaxed/simple;
	bh=tcaWZzWcJxGQoYUVbBZCX92pF5fs8f7xezT9dhZnpeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FWhHr/IiyRiBzmP23fpKFyh1Pbk3CzRbMK46vs222zfJ7Ag5kotbry1lKW63GZTbsIWn1XUtShiVkHC5s5XSWAWeM6LSGRoBmS7hFsz3XckUw5HE4QrKhQD8+LJNAHoaBLKayWDJa0YbvUb/eHqsQFsfx+IISQIdHBllqGxc0+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSkTRUWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSkTRUWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA801C433F1;
	Mon,  8 Apr 2024 13:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582410;
	bh=tcaWZzWcJxGQoYUVbBZCX92pF5fs8f7xezT9dhZnpeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSkTRUWMo/YMBHVcT0ohAqlbCyOP423EuYiRI9qabk8Rx5tEt9hZu2j+IELC4AKZV
	 9PWu/9vTsZZQelrAX1RuDy7C/ax0/D4nT+JuX+vn8+GWlnpKQ7NTMjMC6rAMMcNX6J
	 mUgVItZkTSoY891ya+VlcywneYV7C3deE1HjOBgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Joan=20Bruguera=20Mic=C3=B3?= <joanbrugueram@gmail.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.8 072/273] x86/bpf: Fix IP after emitting call depth accounting
Date: Mon,  8 Apr 2024 14:55:47 +0200
Message-ID: <20240408125311.536613958@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

commit 9d98aa088386aee3db1b7b60b800c0fde0654a4a upstream.

Adjust the IP passed to `emit_patch` so it calculates the correct offset
for the CALL instruction if `x86_call_depth_emit_accounting` emits code.
Otherwise we will skip some instructions and most likely crash.

Fixes: b2e9dfe54be4 ("x86/bpf: Emit call depth accounting if required")
Link: https://lore.kernel.org/lkml/20230105214922.250473-1-joanbrugueram@gmail.com/
Co-developed-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Signed-off-by: Joan Bruguera Micó <joanbrugueram@gmail.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20240401185821.224068-2-ubizjak@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/net/bpf_jit_comp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -466,7 +466,7 @@ static int emit_call(u8 **pprog, void *f
 static int emit_rsb_call(u8 **pprog, void *func, void *ip)
 {
 	OPTIMIZER_HIDE_VAR(func);
-	x86_call_depth_emit_accounting(pprog, func);
+	ip += x86_call_depth_emit_accounting(pprog, func);
 	return emit_patch(pprog, func, ip, 0xE8);
 }
 


