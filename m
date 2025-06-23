Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13417253358;
	Mon, 23 Jun 2025 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684211; cv=none; b=SBppSi4CFnQTunmnziEOCDGz3C2eBpeH1U0eaSIc7HXIOmUU0/IQGhLZgUb2o4beJ08Pc0fpcNZL7MewEcAYlJqHh/i91jpDdZKeIltfHlgzJ3hwDPrB3lH2J/zR+4HC0vKmBHIE1V+Auk06EJyh2IzYANRZ7kutEBWOkwpjSl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684211; c=relaxed/simple;
	bh=B46BNj6+pNi2fpZ3+wmaY1gKAZKN5AnFh3U7QkbuqaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY3KJND+M9CMYEVjBuj3mVqGbT6vDIabPs5chTeakdMh8NDbi//+0fVRNRF4XwMCQBKk2wDE02cy8TrPLURaNeUja5rTTYm6C2DuXp4rBfwMuU3XPYRjLaqUz00aA+lv1j36YQXxYU7FILghY5b6/ks40H9lspgj3W8NbtezL/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnS/7YMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnS/7YMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81467C4CEF0;
	Mon, 23 Jun 2025 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684210;
	bh=B46BNj6+pNi2fpZ3+wmaY1gKAZKN5AnFh3U7QkbuqaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnS/7YMkfkt+PdBEjaQm8pEYsRorlk7Tf6RotMGmPgRuXQutZcHHUYLrQrVu4Dl44
	 bQueHswNFm9d9yHSn4yFs5t4iGoSgFEJvAphO82ZPx8MNMpq9s2synrDmgJSUL5q1i
	 FwV2hyIGVI0H8AOVwZJIIjJ0BDeOGZUzpfH35aVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Pan Taixi <pantaixi@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 002/508] tracing: Fix compilation warning on arm32
Date: Mon, 23 Jun 2025 15:00:47 +0200
Message-ID: <20250623130645.319493615@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7050,7 +7050,7 @@ static ssize_t tracing_splice_read_pipe(
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
 					  min((size_t)trace_seq_used(&iter->seq),
-						  PAGE_SIZE));
+						  (size_t)PAGE_SIZE));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;


