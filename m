Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0426FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41674C433EF;
	Mon, 19 Dec 2022 19:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477798;
	bh=yAcrlxapSA193BaI+p6HvnTi2F1LTYMxaNUhWgnfKlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vb86zGh2Ya9jgBjeT4lqGtAJPC79lM6g0449/YmpDIPJw+lYey0ro+ZAgkM/zPP1o
	 VTmGzp18dEd4ZwigtbC7cyUvNNBLz32PlAPjqN9eRopRcM4cZLC3Gy54U0KKmVfjCk
	 8V6M4/qHnGk1HyAJvV/10xY6Q04+FaJQqfPcd9LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Michael <fedora.dm0@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH 6.1 02/25] libbpf: Fix uninitialized warning in btf_dump_dump_type_data
Date: Mon, 19 Dec 2022 20:22:41 +0100
Message-Id: <20221219182943.502040859@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
References: <20221219182943.395169070@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Michael <fedora.dm0@gmail.com>

commit dfd0afbf151d85411b371e841f62b81ee5d1ca54 upstream.

GCC 11.3.0 fails to compile btf_dump.c due to the following error,
which seems to originate in btf_dump_struct_data where the returned
value would be uninitialized if btf_vlen returns zero.

btf_dump.c: In function ‘btf_dump_dump_type_data’:
btf_dump.c:2363:12: error: ‘err’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
 2363 |         if (err < 0)
      |            ^

Fixes: 920d16af9b42 ("libbpf: BTF dumper support for typed data")
Signed-off-by: David Michael <fedora.dm0@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/87zgcu60hq.fsf@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/btf_dump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1963,7 +1963,7 @@ static int btf_dump_struct_data(struct b
 {
 	const struct btf_member *m = btf_members(t);
 	__u16 n = btf_vlen(t);
-	int i, err;
+	int i, err = 0;
 
 	/* note that we increment depth before calling btf_dump_print() below;
 	 * this is intentional.  btf_dump_data_newline() will not print a


