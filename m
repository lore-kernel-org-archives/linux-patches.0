Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0DB1A6803;
	Tue, 16 Jun 2026 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630596; cv=none; b=lVwQwhShrc88yJta5BLEyQzJYuPUoQOeAQlGsQzsg/3tx5Oup3/ckT1bhswL+/QjNhH+dUTvBoLCPjo/a8PObTLS7RFU4z5SjhrPdCV+enmh5lxst5kOkFb2P5so+mDWV3b4Qtro8s6idQHXoXYzUgZ2EaOkjXCSkfvl78T8CgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630596; c=relaxed/simple;
	bh=7CyMGBwKuNq+UBX0z5mgzusLurkVrL1uu20KbthexVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hquMrH6grZfqNoLIysMZ0pBtZnlauzKnkFELbfSoCBTRqVV6k9oUnxOqDhhKaoE+Tpuibrwk3hd0abCbhQEelcRqeHPMFtxw6AwexY7hDwNs0KxDjRuF6gY3f9PnK/QAVtDNbkP6+NyGiYIUEri/jC3wTrRxEW1AY7TxCgsFggw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHQbGxcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHQbGxcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00251F000E9;
	Tue, 16 Jun 2026 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630594;
	bh=/O1nIiXq7m8eECmpSTDRR13dzuN4VnLwVSmn6mFTqxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NHQbGxcH2IgVyXBppX6nPUTQFRcrT0ZrfVrSJDX6HWhTzOWe/GTBpAcN/TVk4RmrE
	 DOUaF9aH8FRGPqIwh/e//5SADyi0Sgnk0nsYY1dHdPcH7vI6FXDTUzobF5bm5WCI6x
	 MuEzDa7WNkPY8Tp6yFwdV3nnfs0nUWPwXZbh2JtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/522] selftests/bpf: Add read_build_id function
Date: Tue, 16 Jun 2026 20:23:25 +0530
Message-ID: <20260616145128.496758161@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 88dc8b3605b38a440fba45edcc53a6c7a98eee3b ]

Adding read_build_id function that parses out build id from
specified binary.

It will replace extract_build_id and also be used in following
changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230331093157.1749137-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Fixes: be4e85369e5a ("selftests/bpf: Replace extract_build_id with read_build_id")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 82 +++++++++++++++++++++
 tools/testing/selftests/bpf/trace_helpers.h |  5 ++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 9c4be2cdb21a02..afc33ba36ccc6e 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -11,6 +11,9 @@
 #include <linux/perf_event.h>
 #include <sys/mman.h>
 #include "trace_helpers.h"
+#include <linux/limits.h>
+#include <libelf.h>
+#include <gelf.h>
 
 #define DEBUGFS "/sys/kernel/debug/tracing/"
 
@@ -224,3 +227,82 @@ ssize_t get_rel_offset(uintptr_t addr)
 	fclose(f);
 	return -EINVAL;
 }
+
+static int
+parse_build_id_buf(const void *note_start, Elf32_Word note_size, char *build_id)
+{
+	Elf32_Word note_offs = 0;
+
+	while (note_offs + sizeof(Elf32_Nhdr) < note_size) {
+		Elf32_Nhdr *nhdr = (Elf32_Nhdr *)(note_start + note_offs);
+
+		if (nhdr->n_type == 3 && nhdr->n_namesz == sizeof("GNU") &&
+		    !strcmp((char *)(nhdr + 1), "GNU") && nhdr->n_descsz > 0 &&
+		    nhdr->n_descsz <= BPF_BUILD_ID_SIZE) {
+			memcpy(build_id, note_start + note_offs +
+			       ALIGN(sizeof("GNU"), 4) + sizeof(Elf32_Nhdr), nhdr->n_descsz);
+			memset(build_id + nhdr->n_descsz, 0, BPF_BUILD_ID_SIZE - nhdr->n_descsz);
+			return (int) nhdr->n_descsz;
+		}
+
+		note_offs = note_offs + sizeof(Elf32_Nhdr) +
+			   ALIGN(nhdr->n_namesz, 4) + ALIGN(nhdr->n_descsz, 4);
+	}
+
+	return -ENOENT;
+}
+
+/* Reads binary from *path* file and returns it in the *build_id* buffer
+ * with *size* which is expected to be at least BPF_BUILD_ID_SIZE bytes.
+ * Returns size of build id on success. On error the error value is
+ * returned.
+ */
+int read_build_id(const char *path, char *build_id, size_t size)
+{
+	int fd, err = -EINVAL;
+	Elf *elf = NULL;
+	GElf_Ehdr ehdr;
+	size_t max, i;
+
+	if (size < BPF_BUILD_ID_SIZE)
+		return -EINVAL;
+
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -errno;
+
+	(void)elf_version(EV_CURRENT);
+
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (!elf)
+		goto out;
+	if (elf_kind(elf) != ELF_K_ELF)
+		goto out;
+	if (!gelf_getehdr(elf, &ehdr))
+		goto out;
+
+	for (i = 0; i < ehdr.e_phnum; i++) {
+		GElf_Phdr mem, *phdr;
+		char *data;
+
+		phdr = gelf_getphdr(elf, i, &mem);
+		if (!phdr)
+			goto out;
+		if (phdr->p_type != PT_NOTE)
+			continue;
+		data = elf_rawfile(elf, &max);
+		if (!data)
+			goto out;
+		if (phdr->p_offset + phdr->p_memsz > max)
+			goto out;
+		err = parse_build_id_buf(data + phdr->p_offset, phdr->p_memsz, build_id);
+		if (err > 0)
+			break;
+	}
+
+out:
+	if (elf)
+		elf_end(elf);
+	close(fd);
+	return err;
+}
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 238a9c98cde27f..709871f3285256 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -4,6 +4,9 @@
 
 #include <bpf/libbpf.h>
 
+#define __ALIGN_MASK(x, mask)	(((x)+(mask))&~(mask))
+#define ALIGN(x, a)		__ALIGN_MASK(x, (typeof(x))(a)-1)
+
 struct ksym {
 	long addr;
 	char *name;
@@ -21,4 +24,6 @@ void read_trace_pipe(void);
 ssize_t get_uprobe_offset(const void *addr);
 ssize_t get_rel_offset(uintptr_t addr);
 
+int read_build_id(const char *path, char *build_id, size_t size);
+
 #endif
-- 
2.53.0



