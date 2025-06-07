Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AD1207A22;
	Sat,  7 Jun 2025 10:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291026; cv=none; b=I0bWkOWQzMtBk3JfUL2Egrt4owPGUs6UySCspDMeK1QRCYkJTN4FaPawYZt3GYdz6OSEtI30SashuuN8sKP4YJfQlJbi9DlQpnNaIYE0Ad9/YJHtq72TFT9u4rpokBFxxICjsUjMOj4wUayk4FtPA2KlZ4G5HRfygKJ+t1oCjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291026; c=relaxed/simple;
	bh=EwuXNULlRy02ABoJPrLkJEc3OQrdykttWg9vPFu4gTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO8lmtA7v1JordeilqauwOWHB1cksWN4AC9TTFHaMeMFaeelcY+ppaXvn2TKublU0IqmXQkte9fRsc+u9SbFRyoakVkv3Y8Hehb7HzZzCV6H2i/fXO4Nr7bwT//gfptkkizxex8ZIQkGxvObqDG1UirdZ9vBrQKBlPyIL4MLkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zw/gAyoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zw/gAyoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D72C4CEE4;
	Sat,  7 Jun 2025 10:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291026;
	bh=EwuXNULlRy02ABoJPrLkJEc3OQrdykttWg9vPFu4gTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zw/gAyoDnCG6R3EgAzC5eyooUewrXXlBwn2hsrtKr+SMx0cmmb7n7XVxq4e3p5Yve
	 plMCoVpUQbJSjGcujCd6kfnt9oazln0VIfnFoi7qKOJxjdWaeGPwNc4nlufF9ddpMM
	 EGGJJn7SCU3MiDuU3jPGX8HGGzCOv0eqPVRiLnVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Pan Taixi <pantaixi@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.15 01/34] tracing: Fix compilation warning on arm32
Date: Sat,  7 Jun 2025 12:07:42 +0200
Message-ID: <20250607100719.773717451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pan Taixi <pantaixi@huaweicloud.com>

commit 2fbdb6d8e03b70668c0876e635506540ae92ab05 upstream.

On arm32, size_t is defined to be unsigned int, while PAGE_SIZE is
unsigned long. This hence triggers a compilation warning as min()
asserts the type of two operands to be equal. Casting PAGE_SIZE to size_t
solves this issue and works on other target architectures as well.

Compilation warning details:

kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
./include/linux/minmax.h:20:28: warning: comparison of distinct pointer types lacks a cast
  (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                            ^
./include/linux/minmax.h:26:4: note: in expansion of macro '__typecheck'
   (__typecheck(x, y) && __no_side_effects(x, y))
    ^~~~~~~~~~~

...

kernel/trace/trace.c:6771:8: note: in expansion of macro 'min'
        min((size_t)trace_seq_used(&iter->seq),
        ^~~

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250526013731.1198030-1-pantaixi@huaweicloud.com
Fixes: f5178c41bb43 ("tracing: Fix oob write in trace_seq_to_buffer()")
Reviewed-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Pan Taixi <pantaixi@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6824,7 +6824,7 @@ static ssize_t tracing_splice_read_pipe(
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
 					  min((size_t)trace_seq_used(&iter->seq),
-						  PAGE_SIZE));
+						  (size_t)PAGE_SIZE));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;


