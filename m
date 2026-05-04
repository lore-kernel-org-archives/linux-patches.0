Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21F11A6827;
	Mon,  4 May 2026 14:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904147; cv=none; b=hruSJHie7V67Zcpg3MyocGqz6pGz7NGlKOj0B5K0jB9Ex/yAPyJANrucSPCG1ynGcQQujj7DC56uaoLgNCdYOgIUtgEqhe4M3ihcLt+YHQ94D0463vaSW86L1E+q3dSheh49p7lQ4/AXpxzVCa0UzxjkP72vOSwmRxBt8U9i8ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904147; c=relaxed/simple;
	bh=Da2ZdHruZTDgEPidCdanSaAch0vLLQSLQJMzJHPTI2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJmOm9OE2bkiAn46gqrKJiAAPh+uiei4TlxZyXVzlefTibS3Zn2SH0wkzh1vo6pJqBkkUnObo6EfwhweEyASHBK/huN0J7NiiHlMd+8Fmkn+TtjugTsmeZryewrdxpWxhPhD+1IE/To70wJIbe/qBZh6vnZm/FdwaAC1nSChKNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFfQV+7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFfQV+7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA41C2BCB8;
	Mon,  4 May 2026 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904146;
	bh=Da2ZdHruZTDgEPidCdanSaAch0vLLQSLQJMzJHPTI2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFfQV+7vq09HCxAv/0AbGeuhTa3+/DWWZvLyTr2+0D9L3kPNKMizDSVd8nX4hbaVn
	 pjADnn1pGJBZFj8Ja9aSYzR+qTD1iSjxFRPaxqkXra1SoSCkOn5NcJwMxU17RPYK5g
	 cg+UQvXppy3LeE3j6y5s393yixY4OEgcFYSTYw8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <wangrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev,
	Rong Bao <rong.bao@csmantle.top>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/275] perf annotate: Use jump__delete when freeing LoongArch jumps
Date: Mon,  4 May 2026 15:52:14 +0200
Message-ID: <20260504135150.284875128@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Bao <rong.bao@csmantle.top>

[ Upstream commit a355eefc36c4481188249b067832b40a2c45fa5c ]

Currently, the initialization of loongarch_jump_ops does not contain an
assignment to its .free field. This causes disasm_line__free() to fall
through to ins_ops__delete() for LoongArch jump instructions.

ins_ops__delete() will free ins_operands.source.raw and
ins_operands.source.name, and these fields overlaps with
ins_operands.jump.raw_comment and ins_operands.jump.raw_func_start.
Since in loongarch_jump__parse(), these two fields are populated by
strchr()-ing the same buffer, trying to free them will lead to undefined
behavior.

This invalid free usually leads to crashes:

        Process 1712902 (perf) of user 1000 dumped core.
        Stack trace of thread 1712902:
        #0  0x00007fffef155c58 n/a (libc.so.6 + 0x95c58)
        #1  0x00007fffef0f7a94 raise (libc.so.6 + 0x37a94)
        #2  0x00007fffef0dd6a8 abort (libc.so.6 + 0x1d6a8)
        #3  0x00007fffef145490 n/a (libc.so.6 + 0x85490)
        #4  0x00007fffef1646f4 n/a (libc.so.6 + 0xa46f4)
        #5  0x00007fffef164718 n/a (libc.so.6 + 0xa4718)
        #6  0x00005555583a6764 __zfree (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x106764)
        #7  0x000055555854fb70 disasm_line__free (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x2afb70)
        #8  0x000055555853d618 annotated_source__purge (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x29d618)
        #9  0x000055555852300c __hist_entry__tui_annotate (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x28300c)
        #10 0x0000555558526718 do_annotate (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x286718)
        #11 0x000055555852ed94 evsel__hists_browse (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x28ed94)
        #12 0x000055555831fdd0 cmd_report (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x7fdd0)
        #13 0x000055555839b644 handle_internal_command (/home/csmantle/dist/linux-arch/tools/perf/perf + 0xfb644)
        #14 0x00005555582fe6ac main (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x5e6ac)
        #15 0x00007fffef0ddd90 n/a (libc.so.6 + 0x1dd90)
        #16 0x00007fffef0ddf0c __libc_start_main (libc.so.6 + 0x1df0c)
        #17 0x00005555582fed10 _start (/home/csmantle/dist/linux-arch/tools/perf/perf + 0x5ed10)
        ELF object binary architecture: LoongArch

... and it can be confirmed with Valgrind:

        ==1721834== Invalid free() / delete / delete[] / realloc()
        ==1721834==    at 0x4EA9014: free (in /usr/lib/valgrind/vgpreload_memcheck-loongarch64-linux.so)
        ==1721834==    by 0x4106287: __zfree (zalloc.c:13)
        ==1721834==    by 0x42ADC8F: disasm_line__free (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x429B737: annotated_source__purge (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42811EB: __hist_entry__tui_annotate (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42848D7: do_annotate (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x428CF33: evsel__hists_browse (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==  Address 0x7d34303 is 35 bytes inside a block of size 62 alloc'd
        ==1721834==    at 0x4EA59B8: malloc (in /usr/lib/valgrind/vgpreload_memcheck-loongarch64-linux.so)
        ==1721834==    by 0x6B80B6F: strdup (strdup.c:42)
        ==1721834==    by 0x42AD917: disasm_line__new (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42AE5A3: symbol__disassemble_objdump (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42AF0A7: symbol__disassemble (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x429B3CF: symbol__annotate (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x429C233: symbol__annotate2 (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42804D3: __hist_entry__tui_annotate (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x42848D7: do_annotate (in /home/csmantle/dist/linux-arch/tools/perf/perf)
        ==1721834==    by 0x428CF33: evsel__hists_browse (in /home/csmantle/dist/linux-arch/tools/perf/perf)

This patch adds the missing free() specialization in loongarch_jump_ops,
which prevents disasm_line__free() from invoking the default cleanup
function.

Fixes: fb7fd2a14a503b9a ("perf annotate: Move raw_comment and raw_func_start fields out of 'struct ins_operands'")
Cc: stable@vger.kernel.org
Cc: WANG Rui <wangrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev
Signed-off-by: Rong Bao <rong.bao@csmantle.top>
Tested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/loongarch/annotate/instructions.c | 1 +
 tools/perf/util/disasm.c                          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/perf/arch/loongarch/annotate/instructions.c b/tools/perf/arch/loongarch/annotate/instructions.c
index 1c3abb43c8d72..1a0a1dacebc30 100644
--- a/tools/perf/arch/loongarch/annotate/instructions.c
+++ b/tools/perf/arch/loongarch/annotate/instructions.c
@@ -97,6 +97,7 @@ static int loongarch_jump__parse(struct arch *arch, struct ins_operands *ops, st
 }
 
 static struct ins_ops loongarch_jump_ops = {
+	.free	   = jump__delete,
 	.parse	   = loongarch_jump__parse,
 	.scnprintf = jump__scnprintf,
 };
diff --git a/tools/perf/util/disasm.c b/tools/perf/util/disasm.c
index b1be847446fea..c513db41137fa 100644
--- a/tools/perf/util/disasm.c
+++ b/tools/perf/util/disasm.c
@@ -47,6 +47,7 @@ static int jump__scnprintf(struct ins *ins, char *bf, size_t size,
 			   struct ins_operands *ops, int max_ins_name);
 static int call__scnprintf(struct ins *ins, char *bf, size_t size,
 			   struct ins_operands *ops, int max_ins_name);
+static void jump__delete(struct ins_operands *ops);
 
 static void ins__sort(struct arch *arch);
 static int disasm_line__parse(char *line, const char **namep, char **rawp);
-- 
2.53.0



