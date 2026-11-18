Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056544;
	b=muWVo9QWX00D+QKVw5/KMf30N+0SX3yDBgaqDCIiNgx/Yap+2eSdq3mlfhQOPBDZjZ6W
	 XXh86RdYRIDsyAr1fPFYCZOCy+bO/g+vU3qSfER4ETnyhJCxfOtdo2KcwrLbrJ6VZIU46
	 tiM5xPqqy3sJqZ00VsP0pOJLb/zZFW5t900lxEQ0KZ+JSmiSBQiqekupXOQme0Mm0uTRr
	 iWhbF0FZsh45OxpoU4Enn8X2SzB9IZTvAy9Ihw4SpXV5Y+ilV+0jVIiBuRcHvg2ejgVNa
	 Oi39MySkTA+F8XCmxf7z+XBlk2UqxsFlJiJ+H5fZ+GG0gTKlGsJMZGg9Is8+sVab17A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MhJ70zVbzIWYt4gydrA6IdbUXtKqMuOWuNd51xcd3zo=;
	b=jGls4/sMLDL8Ey61kDi766Q4lmTC6RrwHAe8OZugiqWT/DL920LGywBtbwaDRyQX4/wk
	 mMr9HVsSNMPEETr1CJjTOrVfFXXjnGqN5noKQ9ZzgJt7Jkz4kKYuJ0FRxGCV21CV/ERT3
	 5VuZJmcU5QpiND0Pmh0xqqCR107nPYw4F5kCYxn1z+W36zttmLqBm94Zdv0CD5awrjV8u
	 +50MHZSK0LINhI3wj1kF+s1nbacpsceV2QiLKFbLqP8ZBNxO5ED43lU6O2qShZjN6CQB4
	 X6MFPjaKOUDEiNewHXcH6MkIrlQOe9Iecq4CijYbV3hdOVdlveMcFAmGvTKGT3ek4BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9Xpxw4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27871606A31C;
	Thu, 19 Nov 2026 02:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b9Xpxw4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3799E1F000C5;
	Thu, 19 Nov 2026 02:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056543;
	bh=MhJ70zVbzIWYt4gydrA6IdbUXtKqMuOWuNd51xcd3zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9Xpxw4o31esCkgnuib5yRMG1IBpxtpw/Teh9UmfBEh23AzPf8ERQDJ5GFAUCuUa5
	 q9hc/YDBx6AnBE2xDZYF+9tyNhaBZVhlk+vAiiyqRpfh7XXGLsG86FEQyROyyl4Qz4
	 PHIUuc0hsxX1zcJpI3L02xazxHYiIf2CBwAP8KwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2024/2214] bpf: Bound the nesting that the BTF show code follows
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150131.727542952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 13ac7c05bc45d3445b580da186548dd3487fae4e ]

btf_struct_show() and btf_array_show() recurse for every nested struct
and array.  MAX_RESOLVE_DEPTH bounds one resolve walk when BTF is loaded,
not the nesting: a member whose type is resolved already is not walked
again, so BTF that defines its types from the inside out can nest them as
deep as it has types.

Whoever may load BTF, with CAP_BPF or a BPF token, can give such a type
to the value of a map.  Reading the file of that map in bpffs then
overruns the kernel stack: with a few hundred levels the stack guard page
is hit and the kernel panics.

Stop at 32 levels.  That is MAX_RESOLVE_DEPTH, and __btf_show_indent()
has as many columns.  Nothing is shown for a member that lies deeper, and
the status becomes -E2BIG, which bpf_snprintf_btf() and
bpf_seq_printf_btf() return.  The types of an x86_64 defconfig kernel nest
14 deep.

Fixes: b00b8daec828 ("bpf: btf: Add pretty print capability for data with BTF type info")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-19-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 3515bd98a935f..98cf5bf367362 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -792,6 +792,8 @@ static const struct btf_type *btf_type_skip_qualifiers(const struct btf *btf,
 }
 
 #define BTF_SHOW_MAX_ITER	10
+/* nested structs and arrays shown; __btf_show_indent() has as many columns */
+#define BTF_SHOW_MAX_DEPTH	32
 
 #define BTF_KIND_BIT(kind)	(1ULL << kind)
 
@@ -1183,8 +1185,18 @@ static void *btf_show_start_aggr_type(struct btf_show *show,
 				      const struct btf_type *t,
 				      u32 type_id, void *data)
 {
-	void *safe_data = btf_show_start_type(show, t, type_id, data);
+	void *safe_data;
 
+	/*
+	 * Structs and arrays are shown by recursion.  BTF loading bounds the
+	 * depth of one resolve walk, not how deep resolved types may nest.
+	 */
+	if (show->state.depth >= BTF_SHOW_MAX_DEPTH) {
+		show->state.status = -E2BIG;
+		return NULL;
+	}
+
+	safe_data = btf_show_start_type(show, t, type_id, data);
 	if (!safe_data)
 		return safe_data;
 
-- 
2.53.0



