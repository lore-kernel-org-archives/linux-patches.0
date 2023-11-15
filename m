Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919F63C465
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRIWUQfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0B3C433C7;
	Wed, 15 Nov 2023 19:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077161;
	bh=Do96oEl0jBGQcM+aFZzGC8NcJ44z52ud47+kaZDNpf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRIWUQfbOnisH9jdACAs3u25XMFplaEVONAjkbYHzIzu+pPm2L7kW9NqTsmOvPupY
	 s6plUFJUZLzV3BICxzTB8jq6czQJhvKug3sNcQme18LO47CYqU14vLzJQqLQ5R+F0u
	 VV8eOyENL14jvCGMI8fyQRt28ymgtGMiqSajw2Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/603] selftests/bpf: Make linked_list failure test more robust
Date: Wed, 15 Nov 2023 14:11:12 -0500
Message-ID: <20231115191622.029482116@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit da1055b673f3baac2249571c9882ce767a0aa746 ]

The linked list failure test 'pop_front_off' and 'pop_back_off'
currently rely on matching exact instruction and register values.  The
purpose of the test is to ensure the offset is correctly incremented for
the returned pointers from list pop helpers, which can then be used with
container_of to obtain the real object. Hence, somehow obtaining the
information that the offset is 48 will work for us. Make the test more
robust by relying on verifier error string of bpf_spin_lock and remove
dependence on fragile instruction index or register number, which can be
affected by different clang versions used to build the selftests.

Fixes: 300f19dcdb99 ("selftests/bpf: Add BPF linked list API tests")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231020144839.2734006-1-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/linked_list.c | 10 ++--------
 tools/testing/selftests/bpf/progs/linked_list_fail.c |  4 +++-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/linked_list.c b/tools/testing/selftests/bpf/prog_tests/linked_list.c
index 18cf7b17463d9..98dde091d2825 100644
--- a/tools/testing/selftests/bpf/prog_tests/linked_list.c
+++ b/tools/testing/selftests/bpf/prog_tests/linked_list.c
@@ -94,14 +94,8 @@ static struct {
 	{ "incorrect_head_var_off2", "variable ptr_ access var_off=(0x0; 0xffffffff) disallowed" },
 	{ "incorrect_head_off1", "bpf_list_head not found at offset=25" },
 	{ "incorrect_head_off2", "bpf_list_head not found at offset=1" },
-	{ "pop_front_off",
-	  "15: (bf) r1 = r6                      ; R1_w=ptr_or_null_foo(id=4,ref_obj_id=4,off=48,imm=0) "
-	  "R6_w=ptr_or_null_foo(id=4,ref_obj_id=4,off=48,imm=0) refs=2,4\n"
-	  "16: (85) call bpf_this_cpu_ptr#154\nR1 type=ptr_or_null_ expected=percpu_ptr_" },
-	{ "pop_back_off",
-	  "15: (bf) r1 = r6                      ; R1_w=ptr_or_null_foo(id=4,ref_obj_id=4,off=48,imm=0) "
-	  "R6_w=ptr_or_null_foo(id=4,ref_obj_id=4,off=48,imm=0) refs=2,4\n"
-	  "16: (85) call bpf_this_cpu_ptr#154\nR1 type=ptr_or_null_ expected=percpu_ptr_" },
+	{ "pop_front_off", "off 48 doesn't point to 'struct bpf_spin_lock' that is at 40" },
+	{ "pop_back_off", "off 48 doesn't point to 'struct bpf_spin_lock' that is at 40" },
 };
 
 static void test_linked_list_fail_prog(const char *prog_name, const char *err_msg)
diff --git a/tools/testing/selftests/bpf/progs/linked_list_fail.c b/tools/testing/selftests/bpf/progs/linked_list_fail.c
index f4c63daba2297..6438982b928bd 100644
--- a/tools/testing/selftests/bpf/progs/linked_list_fail.c
+++ b/tools/testing/selftests/bpf/progs/linked_list_fail.c
@@ -591,7 +591,9 @@ int pop_ptr_off(void *(*op)(void *head))
 	n = op(&p->head);
 	bpf_spin_unlock(&p->lock);
 
-	bpf_this_cpu_ptr(n);
+	if (!n)
+		return 0;
+	bpf_spin_lock((void *)n);
 	return 0;
 }
 
-- 
2.42.0



