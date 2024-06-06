Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B73196C89;
	Thu,  6 Jun 2024 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682943; cv=none; b=uCgd0NFcUKPi9W7nqVMGx4AccuFBr0F1HHxGckB7zkZ1m4oD1kQOoCZRgjLYMMKSyq2qBZyJCVCZufVld9X22cI6W2vPMS30fgxG1Re7JagZxEYmUW35BN1polrWRlsseQTh4vqISzV3whwNOmWChOcWfIRsc1et6/P8UAUSXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682943; c=relaxed/simple;
	bh=f5E+SHqVaemLMC1hhAoaJH/ctFPC6UBP//WdsVQ50ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KommezOG5FzRHJ5fjAwau+soJ4G8I3JKrF4D1bJNrNXMy5TniEnAi61QqW0Ot53zm0/DE4LxcmvtS+5HFWM8z+0YV5bhQhfGQ7U/fZGKJUrndc4RYadsIWlEPt1s546cL278BFp3Ui8OiaxQoM73l03yQwoVXSoEodePqKjzBc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jv3UdEao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jv3UdEao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF98C32781;
	Thu,  6 Jun 2024 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682943;
	bh=f5E+SHqVaemLMC1hhAoaJH/ctFPC6UBP//WdsVQ50ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jv3UdEaoG1mGjYJctLJdhydlTUBrQDeDJvpuy96JaKk2PofuRMO/sbzndZQDqBSwn
	 7LNA/MDVjQyN6xY/saJMSNkNq+cjUiDXqRo7flzBb93nWg/7NNZmndPmktY9LyqNyY
	 mK46V0IoEwJaO5qP+clAExjh4lyG7tPJOpGLu0RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 050/374] perf dwarf-aux: Check pointer offset when checking variables
Date: Thu,  6 Jun 2024 16:00:29 +0200
Message-ID: <20240606131653.495648134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 645af3fb62bf12911ce1fc79efa676dae9a8289b ]

In match_var_offset(), it checks the offset range with the target type
only for non-pointer types.  But it also needs to check the pointer
types with the target type.

This is because there can be more than one pointer variable located in
the same register.  Let's look at the following example.  It's looking
up a variable for reg3 at tcp_get_info+0x62.  It found "sk" variable but
it wasn't the right one since it accesses beyond the target type (struct
'sock' in this case) size.

  -----------------------------------------------------------
  find data type for 0x7bc(reg3) at tcp_get_info+0x62
  CU for net/ipv4/tcp.c (die:0x7b5f516)
  frame base: cfa=0 fbreg=6
  offset: 1980 is bigger than size: 760
  check variable "sk" failed (die: 0x7b92b2c)
   variable location: reg3
   type='struct sock' size=0x2f8 (die:0x7b63c3a)

Actually there was another variable "tp" in the function and it's
located at the same (reg3) because it's just type-casted like below.

  void tcp_get_info(struct sock *sk, struct tcp_info *info)
  {
      const struct tcp_sock *tp = tcp_sk(sk);
      ...

The 'struct tcp_sock' contains the 'struct sock' at offset 0 so it can
just use the same address as a pointer to tcp_sock.  That means it
should match variables correctly by checking the offset and size.
Actually it cannot distinguish if the offset was smaller than the size
of the original struct sock.  But I think it's fine as they are the same
at that part.

So let's check the target type size and retry if it doesn't match.
Now it succeeded to find the correct variable.

  -----------------------------------------------------------
  find data type for 0x7bc(reg3) at tcp_get_info+0x62
  CU for net/ipv4/tcp.c (die:0x7b5f516)
  frame base: cfa=0 fbreg=6
  found "tp" in scope=1/1 (die: 0x7b92b16) type_offset=0x7bc
   variable location: reg3
   type='struct tcp_sock' size=0xa68 (die:0x7b81380)

Fixes: bc10db8eb8955fbc ("perf annotate-data: Support stack variables")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240412183310.2518474-3-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 2791126069b4f..f7f7171539d3c 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1280,7 +1280,7 @@ struct find_var_data {
 #define DWARF_OP_DIRECT_REGS  32
 
 static bool match_var_offset(Dwarf_Die *die_mem, struct find_var_data *data,
-			     u64 addr_offset, u64 addr_type)
+			     u64 addr_offset, u64 addr_type, bool is_pointer)
 {
 	Dwarf_Die type_die;
 	Dwarf_Word size;
@@ -1294,6 +1294,12 @@ static bool match_var_offset(Dwarf_Die *die_mem, struct find_var_data *data,
 	if (die_get_real_type(die_mem, &type_die) == NULL)
 		return false;
 
+	if (is_pointer && dwarf_tag(&type_die) == DW_TAG_pointer_type) {
+		/* Get the target type of the pointer */
+		if (die_get_real_type(&type_die, &type_die) == NULL)
+			return false;
+	}
+
 	if (dwarf_aggregate_size(&type_die, &size) < 0)
 		return false;
 
@@ -1361,31 +1367,38 @@ static int __die_find_var_reg_cb(Dwarf_Die *die_mem, void *arg)
 		if (data->is_fbreg && ops->atom == DW_OP_fbreg &&
 		    data->offset >= (int)ops->number &&
 		    check_allowed_ops(ops, nops) &&
-		    match_var_offset(die_mem, data, data->offset, ops->number))
+		    match_var_offset(die_mem, data, data->offset, ops->number,
+				     /*is_pointer=*/false))
 			return DIE_FIND_CB_END;
 
 		/* Only match with a simple case */
 		if (data->reg < DWARF_OP_DIRECT_REGS) {
 			/* pointer variables saved in a register 0 to 31 */
 			if (ops->atom == (DW_OP_reg0 + data->reg) &&
-			    check_allowed_ops(ops, nops))
+			    check_allowed_ops(ops, nops) &&
+			    match_var_offset(die_mem, data, data->offset, 0,
+					     /*is_pointer=*/true))
 				return DIE_FIND_CB_END;
 
 			/* Local variables accessed by a register + offset */
 			if (ops->atom == (DW_OP_breg0 + data->reg) &&
 			    check_allowed_ops(ops, nops) &&
-			    match_var_offset(die_mem, data, data->offset, ops->number))
+			    match_var_offset(die_mem, data, data->offset, ops->number,
+					     /*is_pointer=*/false))
 				return DIE_FIND_CB_END;
 		} else {
 			/* pointer variables saved in a register 32 or above */
 			if (ops->atom == DW_OP_regx && ops->number == data->reg &&
-			    check_allowed_ops(ops, nops))
+			    check_allowed_ops(ops, nops) &&
+			    match_var_offset(die_mem, data, data->offset, 0,
+					     /*is_pointer=*/true))
 				return DIE_FIND_CB_END;
 
 			/* Local variables accessed by a register + offset */
 			if (ops->atom == DW_OP_bregx && data->reg == ops->number &&
 			    check_allowed_ops(ops, nops) &&
-			    match_var_offset(die_mem, data, data->offset, ops->number2))
+			    match_var_offset(die_mem, data, data->offset, ops->number2,
+					     /*is_poitner=*/false))
 				return DIE_FIND_CB_END;
 		}
 	}
@@ -1447,7 +1460,8 @@ static int __die_find_var_addr_cb(Dwarf_Die *die_mem, void *arg)
 			continue;
 
 		if (check_allowed_ops(ops, nops) &&
-		    match_var_offset(die_mem, data, data->addr, ops->number))
+		    match_var_offset(die_mem, data, data->addr, ops->number,
+				     /*is_pointer=*/false))
 			return DIE_FIND_CB_END;
 	}
 	return DIE_FIND_CB_SIBLING;
-- 
2.43.0



