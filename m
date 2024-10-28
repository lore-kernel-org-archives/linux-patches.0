Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C8418E35B;
	Mon, 28 Oct 2024 06:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097983; cv=none; b=ADkwFLcXR3qQtuAnNSxtUTSCjReB8JKa1PHPL+ffNaQaX/qU0072o0kyxa0IgajhxdRDT7g0yq7ngvSX4o9ESkF6b6gT/r7KvGNXOedwvzhn4VIrJQ4UpTFdl+A96quxcQ3CI4zX4iyV5yU9Lx3vpaSKHt/qeSpeoYtKw37ti8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097983; c=relaxed/simple;
	bh=exC88oUJc/FILt6cz2wooknUUX0r3/VL0NaIKp0gOlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlbW/KtmbtzlH1wjvIzKt28nq8kMedXFkBzmxmkBZnp2pFPr4PXgwXAwHzBXEl+8kJ+BqPPX9luSHjFE/2/Stz3jF0fjrFDQ3A6SlNbLcPmiW2Wio5bGW4vGQAhQQbgD+L5Zfe60y5fumJoURjs1odQ3JoCQE8NBeG81BYXHvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlqsDhRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlqsDhRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97644C4CEC3;
	Mon, 28 Oct 2024 06:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097982;
	bh=exC88oUJc/FILt6cz2wooknUUX0r3/VL0NaIKp0gOlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlqsDhRXmsi3mtfaGI9R5X1iOWeVqL4Ptn+pUF1I7KmPxvLT+egsWEq/tGsqh2i8s
	 ogWmcTE56fBDFlJah3mzA73xLUFMoaBSnc7XwsWPqgioDrbi/Z5Bt8JB5nRbGQIhDB
	 M4SP4iGMV3fQ84/03CIBK+879w+MX/xmQvT+/p0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 018/261] bpf: Check the remaining info_cnt before repeating btf fields
Date: Mon, 28 Oct 2024 07:22:40 +0100
Message-ID: <20241028062312.467832036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 797d73ee232dd1833dec4824bc53a22032e97c1c ]

When trying to repeat the btf fields for array of nested struct, it
doesn't check the remaining info_cnt. The following splat will be
reported when the value of ret * nelems is greater than BTF_FIELDS_MAX:

  ------------[ cut here ]------------
  UBSAN: array-index-out-of-bounds in ../kernel/bpf/btf.c:3951:49
  index 11 is out of range for type 'btf_field_info [11]'
  CPU: 6 UID: 0 PID: 411 Comm: test_progs ...... 6.11.0-rc4+ #1
  Tainted: [O]=OOT_MODULE
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x57/0x70
   dump_stack+0x10/0x20
   ubsan_epilogue+0x9/0x40
   __ubsan_handle_out_of_bounds+0x6f/0x80
   ? kallsyms_lookup_name+0x48/0xb0
   btf_parse_fields+0x992/0xce0
   map_create+0x591/0x770
   __sys_bpf+0x229/0x2410
   __x64_sys_bpf+0x1f/0x30
   x64_sys_call+0x199/0x9f0
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x4b/0x53
  RIP: 0033:0x7fea56f2cc5d
  ......
   </TASK>
  ---[ end trace ]---

Fix it by checking the remaining info_cnt in btf_repeat_fields() before
repeating the btf fields.

Fixes: 64e8ee814819 ("bpf: look into the types of the fields of a struct type recursively.")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241008071114.3718177-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 9b068afd17953..5f4f1d0bc23a4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3528,7 +3528,7 @@ static int btf_get_field_type(const struct btf *btf, const struct btf_type *var_
  *   (i + 1) * elem_size
  * where i is the repeat index and elem_size is the size of an element.
  */
-static int btf_repeat_fields(struct btf_field_info *info,
+static int btf_repeat_fields(struct btf_field_info *info, int info_cnt,
 			     u32 field_cnt, u32 repeat_cnt, u32 elem_size)
 {
 	u32 i, j;
@@ -3548,6 +3548,12 @@ static int btf_repeat_fields(struct btf_field_info *info,
 		}
 	}
 
+	/* The type of struct size or variable size is u32,
+	 * so the multiplication will not overflow.
+	 */
+	if (field_cnt * (repeat_cnt + 1) > info_cnt)
+		return -E2BIG;
+
 	cur = field_cnt;
 	for (i = 0; i < repeat_cnt; i++) {
 		memcpy(&info[cur], &info[0], field_cnt * sizeof(info[0]));
@@ -3592,7 +3598,7 @@ static int btf_find_nested_struct(const struct btf *btf, const struct btf_type *
 		info[i].off += off;
 
 	if (nelems > 1) {
-		err = btf_repeat_fields(info, ret, nelems - 1, t->size);
+		err = btf_repeat_fields(info, info_cnt, ret, nelems - 1, t->size);
 		if (err == 0)
 			ret *= nelems;
 		else
@@ -3686,10 +3692,10 @@ static int btf_find_field_one(const struct btf *btf,
 
 	if (ret == BTF_FIELD_IGNORE)
 		return 0;
-	if (nelems > info_cnt)
+	if (!info_cnt)
 		return -E2BIG;
 	if (nelems > 1) {
-		ret = btf_repeat_fields(info, 1, nelems - 1, sz);
+		ret = btf_repeat_fields(info, info_cnt, 1, nelems - 1, sz);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.43.0



