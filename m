Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C2E151CCC;
	Tue, 20 Feb 2024 21:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464973; cv=none; b=bWoya6TrQ9p0rDRUguoK5Licvyvg0vnWoKqdh5Sqk/rYPOk07cvrTbLtBbi9aqtlZhBUgOiqTS8pqns2ZXOl/zSAlawV6Ny375sJ8+M9IJeYzimCwighNqQds8nhG+2EWQfsxoUj3dnfattGYW+SXVDYTHCs1yPBp2m/VpcS3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464973; c=relaxed/simple;
	bh=rcPNBkYriL0PhTcbhMRR/msXztP76/PtrIcX+WQKH/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jlw7KCV9KP9ac2hyhiMjayeqIC6ftSZHUcadIOeLIw1C2kCPf0AhkWmK7KHHHH/xC1Gzs04tcK/T476w6GzKqz37Orhj7qA0ywyuIPKmLOY8Jd9HcfFJkv3oikSQAupUDILLJGSXxKIlL9KNaX25u+KSw+PKHWBgFUxdM4Z4mc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW2et0Sz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW2et0Sz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B11C433F1;
	Tue, 20 Feb 2024 21:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464972;
	bh=rcPNBkYriL0PhTcbhMRR/msXztP76/PtrIcX+WQKH/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XW2et0SzFOjee2/PbY4CKvOm9+DPNIHvAsOg+Jwl04pOvHn11NMh7r6S77TF2/c+S
	 y1FjL36eMfctp6LoeW7Ez8mKmEhau/4NvTaD9Tb2h4dI680w2hymiR2EQWKs5WtYTI
	 Own73p76S8TS2QFy7zfgZz2ltM/8ES6xbGiw9kxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.7 166/309] tracing/probes: Fix to search structure fields correctly
Date: Tue, 20 Feb 2024 21:55:25 +0100
Message-ID: <20240220205638.347135627@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 9704669c386f9bbfef2e002e7e690c56b7dcf5de upstream.

Fix to search a field from the structure which has anonymous union
correctly.
Since the reference `type` pointer was updated in the loop, the search
loop suddenly aborted where it hits an anonymous union. Thus it can not
find the field after the anonymous union. This avoids updating the
cursor `type` pointer in the loop.

Link: https://lore.kernel.org/all/170791694361.389532.10047514554799419688.stgit@devnote2/

Fixes: 302db0f5b3d8 ("tracing/probes: Add a function to search a member of a struct/union")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_btf.c b/kernel/trace/trace_btf.c
index ca224d53bfdc..5bbdbcbbde3c 100644
--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -91,8 +91,8 @@ const struct btf_member *btf_find_struct_member(struct btf *btf,
 	for_each_member(i, type, member) {
 		if (!member->name_off) {
 			/* Anonymous union/struct: push it for later use */
-			type = btf_type_skip_modifiers(btf, member->type, &tid);
-			if (type && top < BTF_ANON_STACK_MAX) {
+			if (btf_type_skip_modifiers(btf, member->type, &tid) &&
+			    top < BTF_ANON_STACK_MAX) {
 				anon_stack[top].tid = tid;
 				anon_stack[top++].offset =
 					cur_offset + member->offset;
-- 
2.43.2



