Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6D5254876;
	Mon, 23 Jun 2025 13:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684201; cv=none; b=Dd6TaxVUUvC3qS/8b5/ZZWEypH2LiK0dVUcFf2tHmbXP/Tavcw+pjGXow6CfH9bTte7uyEmDRPNy5N06kYkK/Uu+/2kwmYufZG0W00OIPYCwcWz1v5/6uQOhdjm8rm78/Aj3kA1zrR79JvwhzUM0kR/WteHNASZazd16zgPkAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684201; c=relaxed/simple;
	bh=HFmb4edGCFSHu4DiJgTgMLtCIUJmU+hSTaYoUngtFOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miCiyJSU8a3/PaY2ozCAN1tYozg84u6D+/5AWz5p6mkxLwr0iv3HDXM8E1v3v561n2QC053BAeTQZBL7yEV+Z0lvdzBwbk4wolzWycLySB42GQFmpm/hsW//DIc1qcgItsjnXd2HlM+ErdxlI9P6L0yfWdcAu4sdDV9Et0rCzMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWMotaYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWMotaYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DEFC4CEF3;
	Mon, 23 Jun 2025 13:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684200;
	bh=HFmb4edGCFSHu4DiJgTgMLtCIUJmU+hSTaYoUngtFOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWMotaYvqkcAfvRkWrJQkIQm57Bp1uB5LoF1OfPiJajvXxSU+s/WvVDvo4b3aQFw2
	 W7LvmtZqr2zTWw6RJQo/jm2xFfybSeoBrwlVZFkxZbnhH1nZACSNJ+ZL8wN8jSCmue
	 apKb3JlKJDiffgIhJr9D3SOuDjlSYs5Yvd9OkiGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeongjun Park <aha310510@gmail.com>,
	Pan Taixi <pantaixi@huaweicloud.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 001/222] tracing: Fix compilation warning on arm32
Date: Mon, 23 Jun 2025 15:05:36 +0200
Message-ID: <20250623130611.942486520@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6332,7 +6332,7 @@ static ssize_t tracing_splice_read_pipe(
 		ret = trace_seq_to_buffer(&iter->seq,
 					  page_address(spd.pages[i]),
 					  min((size_t)trace_seq_used(&iter->seq),
-						  PAGE_SIZE));
+						  (size_t)PAGE_SIZE));
 		if (ret < 0) {
 			__free_page(spd.pages[i]);
 			break;


