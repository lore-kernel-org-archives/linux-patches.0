Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C663338837C;
	Sat, 12 Sep 2026 19:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240157; cv=none; b=thrpcqSSHdrFhDp1vHs/Q7eCVQWCLeVbY8xaPLNSlEp0OeClBXy+8iCSrJjq0/Q3Suh4ijT+9DIYP6Nuc28RqNm/sZVVl9PusS7tuzqAJbfdtHTXsoXboyX9ELSQgY1JHWU7PzI20cJr/hH8EqXH5aDQUBxEaPJaqJyjH3RScmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240157; c=relaxed/simple;
	bh=E2yc0s6epMkrnVoYNOG+EfN77je3si7wJTNwj39Rq2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+wtRMlV9ofr2zxNgWpzDd51rXCK95gFtl3UwDvez6pm+zdWB7wVO8TYfTfFRG00oYTUNBSofskUrrMP/Sa660stc1WdjMQVVQnqzP09RiZguA6CeGh0qKEj9eo33+KIJ46fg/FFHxPEXrLeJYP7iFRZh+yBzLtQAZGRwv43cts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXutBdmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXutBdmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3251F000FF;
	Sat, 12 Sep 2026 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240155;
	bh=Qd6GjEJji1t02484mXX9QAruNLOErtvCdR8/FZ3kTA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXutBdmWehlscGhj4ZtEruDAWOSyUW85nHLjzAEebXIqVyauhIRaxq4yQxMP7E03B
	 DB0N05T5Y+ZuPZht/ElJvKjIqHSR/xNa0w/DhHu8b1uyZF3sSh99KSlbJ9XDGdbgPF
	 Bm4HpmtEBbB9Nt/hQNpTANGO3iyMJ8pJcWA5F2cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vineet Gupta <vineet.gupta@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 809/935] selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM
Date: Sat, 12 Sep 2026 09:03:59 +0200
Message-ID: <20260912065545.394457414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vineet.gupta@linux.dev>

[ Upstream commit 3a59f11e0f989bdd637c87151992605a6559a7cb ]

vmtest.sh captures the trailing command with command="$@", which flattens
the arguments into a single space-separated string, and then pastes it
into the generated guest init script:

        cd /root/bpf
        echo ${command}
        stdbuf -oL -eL ${command}

That here-doc is unquoted, so the host expands ${command} and the
flattened text lands in the script verbatim. The guest bash then parses
those lines as shell source, re-splitting the text on whitespace and
glob-expanding it against /root/bpf. As a result any command with a glob
or an argument containing spaces is corrupted before it reaches the test
binary. For example:

        vmtest.sh -- ./test_progs -a 'verifier_*'

has 'verifier_*' expanded in the guest into the matching object/skeleton
files (verifier_align.bpf.o verifier_align.skel.h ...), so test_progs is
handed a list of filenames instead of the intended name filter and runs no
matching tests.

Quote each argument with printf '%q ' so the command is reproduced
verbatim inside the VM: the escaped text goes through exactly one round
of quote removal when the guest parses the init script, yielding the
original argv with globs and special characters intact. The common case
(e.g. -t <name>) is unaffected.

Only do this when there is a command to quote. printf '%q ' with no
arguments still applies the format once and emits '', which the -s
(debug shell) path would take for a real command and try to run.

Note this makes the trailing command strictly an argv rather than a shell
snippet: passing it pre-quoted as one word, e.g.

        vmtest.sh -- "./test_progs -t foo"

no longer works, and neither does embedding guest-side shell syntax such
as ';' or a redirection. 'sh -c ...' still works.

The RV64 recipe in README.rst does depend on the old double parse: it
wraps the denylist in \" so the literal quotes reach the guest, whose
second parse of the init script removes them. Under %q those quotes now
survive into argv, and parse_test_list() strtok_r()s on ',' turns them
into junk filters:

        -d ",exceptions,"  ->  ["] [exceptions] ["]

That is harmless for DENYLIST.riscv64 only because its first line is a
comment, so the leading field is empty. A denylist starting with a real
entry would silently lose it - ["*arena*] never matches - so drop the
backslashes and let the host consume the quotes instead.

Fixes: c9709f52386d ("bpf: Helper script for running BPF presubmit tests")
Signed-off-by: Vineet Gupta <vineet.gupta@linux.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260807204434.1036279-5-vineet.gupta@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/README.rst |  4 ++--
 tools/testing/selftests/bpf/vmtest.sh  | 13 +++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/README.rst b/tools/testing/selftests/bpf/README.rst
index 14a2cd45c78fe..5e059cbcea2db 100644
--- a/tools/testing/selftests/bpf/README.rst
+++ b/tools/testing/selftests/bpf/README.rst
@@ -58,12 +58,12 @@ Docker container and local rootfs image. The overall steps are as follows:
     tools/testing/selftests/bpf/vmtest.sh \
     -l <path of local rootfs image> -- \
     ./test_progs -d \
-        \"$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
+        "$(cat tools/testing/selftests/bpf/DENYLIST.riscv64 \
             | cut -d'#' -f1 \
             | sed -e 's/^[[:space:]]*//' \
                   -e 's/[[:space:]]*$//' \
             | tr -s '\n' ',' \
-        )\"
+        )"
 
 Link: https://github.com/pulehui/riscv-bpf-vmtest.git [0]
 Link: https://github.com/libbpf/ci/blob/main/rootfs/mkrootfs_debian.sh [1]
diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index 997f1a6592b55..45bc822c3cc7a 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -352,8 +352,17 @@ main()
 
 	if [[ $# -eq 0  && "${debug_shell}" == "no" ]]; then
 		echo "No command specified, will run ${DEFAULT_COMMAND} in the vm"
-	else
-		command="$@"
+	elif [[ $# -gt 0 ]]; then
+		# Quote each argument so the command survives into the guest: the
+		# host expands ${command} into the generated init script, which
+		# the guest bash then parses as shell source. Without the %q
+		# escapes an argument with a space or a glob (e.g. -a 'verifier_*')
+		# is re-split and expanded against /root/bpf there.
+		#
+		# Skip this when there is no command: printf '%q ' would still
+		# apply the format once and emit '', which is not the empty
+		# command that -s (debug shell) expects.
+		command=$(printf '%q ' "$@")
 	fi
 
 	local kconfig_file="${OUTPUT_DIR}/latest.config"
-- 
2.53.0



