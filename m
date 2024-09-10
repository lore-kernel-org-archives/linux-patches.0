Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D7E144D1A;
	Tue, 10 Sep 2024 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963259; cv=none; b=IcoHm3a/XL1B0XgluFSMwZ8M/BQlb2bNHmHqgrNCwZpGt0amtFYuPi+U+jtAzfdoXAp9FgwuKDKtkel23zst9f2+698auoylPLWftHZyEuiqbXzqMlUHQcMc+U4yDfli7E6qFsN74beNvoN74Rn0Zg/Q+kpRxejDEYIyeSnTtno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963259; c=relaxed/simple;
	bh=5/ewN1PwmusyqIwQhhhrCDcU2cZzuoBQA/L86r18Pes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKHwX8Va/CZ2tZFZ4Kyaol2RQzG8jY5sY8i8OK7r5p2bk1z1ErstsHPVz4zAmxs+PRmiSoZnRxGvY0+wgRU1ilqwIyY4E4CaheEJBpSekOntb561uB+GyI2CiPooRpE0jI+C2SSVaBeRpBmuJVUF/QNURykx/r/F91btapzOVBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IqCzKIv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IqCzKIv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA78C4CEC3;
	Tue, 10 Sep 2024 10:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963259;
	bh=5/ewN1PwmusyqIwQhhhrCDcU2cZzuoBQA/L86r18Pes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IqCzKIv9XHQ7VVZrtg1r8ETmWHovhWdo2cdkDQRxsaMX2M4rWEx20b2pc81dZtfQR
	 Omzx+0s4EmdpnDira5BFyFWJ3ijsihPi/YTlLGAQyip0Wa1yos/I7vKakAW+3KZesG
	 xySWb4KRPwbhEd38oF1WgZmJOqaiK+CE8a7qpGv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+958967f249155967d42a@syzkaller.appspotmail.com,
	Yonghong Song <yhs@fb.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Diogo Jahchan Koike <djahchankoike@gmail.com>
Subject: [PATCH 6.1 189/192] bpf: Silence a warning in btf_type_id_size()
Date: Tue, 10 Sep 2024 11:33:33 +0200
Message-ID: <20240910092605.575977092@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yhs@fb.com>

commit e6c2f594ed961273479505b42040782820190305 upstream.

syzbot reported a warning in [1] with the following stacktrace:
  WARNING: CPU: 0 PID: 5005 at kernel/bpf/btf.c:1988 btf_type_id_size+0x2d9/0x9d0 kernel/bpf/btf.c:1988
  ...
  RIP: 0010:btf_type_id_size+0x2d9/0x9d0 kernel/bpf/btf.c:1988
  ...
  Call Trace:
   <TASK>
   map_check_btf kernel/bpf/syscall.c:1024 [inline]
   map_create+0x1157/0x1860 kernel/bpf/syscall.c:1198
   __sys_bpf+0x127f/0x5420 kernel/bpf/syscall.c:5040
   __do_sys_bpf kernel/bpf/syscall.c:5162 [inline]
   __se_sys_bpf kernel/bpf/syscall.c:5160 [inline]
   __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5160
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

With the following btf
  [1] DECL_TAG 'a' type_id=4 component_idx=-1
  [2] PTR '(anon)' type_id=0
  [3] TYPE_TAG 'a' type_id=2
  [4] VAR 'a' type_id=3, linkage=static
and when the bpf_attr.btf_key_type_id = 1 (DECL_TAG),
the following WARN_ON_ONCE in btf_type_id_size() is triggered:
  if (WARN_ON_ONCE(!btf_type_is_modifier(size_type) &&
                   !btf_type_is_var(size_type)))
          return NULL;

Note that 'return NULL' is the correct behavior as we don't want
a DECL_TAG type to be used as a btf_{key,value}_type_id even
for the case like 'DECL_TAG -> STRUCT'. So there
is no correctness issue here, we just want to silence warning.

To silence the warning, I added DECL_TAG as one of kinds in
btf_type_nosize() which will cause btf_type_id_size() returning
NULL earlier without the warning.

  [1] https://lore.kernel.org/bpf/000000000000e0df8d05fc75ba86@google.com/

Reported-by: syzbot+958967f249155967d42a@syzkaller.appspotmail.com
Signed-off-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20230530205029.264910-1-yhs@fb.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/btf.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -466,10 +466,16 @@ static bool btf_type_is_fwd(const struct
 	return BTF_INFO_KIND(t->info) == BTF_KIND_FWD;
 }
 
+static bool btf_type_is_decl_tag(const struct btf_type *t)
+{
+	return BTF_INFO_KIND(t->info) == BTF_KIND_DECL_TAG;
+}
+
 static bool btf_type_nosize(const struct btf_type *t)
 {
 	return btf_type_is_void(t) || btf_type_is_fwd(t) ||
-	       btf_type_is_func(t) || btf_type_is_func_proto(t);
+	       btf_type_is_func(t) || btf_type_is_func_proto(t) ||
+	       btf_type_is_decl_tag(t);
 }
 
 static bool btf_type_nosize_or_null(const struct btf_type *t)
@@ -492,11 +498,6 @@ static bool btf_type_is_datasec(const st
 	return BTF_INFO_KIND(t->info) == BTF_KIND_DATASEC;
 }
 
-static bool btf_type_is_decl_tag(const struct btf_type *t)
-{
-	return BTF_INFO_KIND(t->info) == BTF_KIND_DECL_TAG;
-}
-
 static bool btf_type_is_decl_tag_target(const struct btf_type *t)
 {
 	return btf_type_is_func(t) || btf_type_is_struct(t) ||


