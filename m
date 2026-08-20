Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A1F361640;
	Thu, 20 Aug 2026 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238297; cv=none; b=mtHezQz0JGOISftW2mwjA9G49WwxCYfbGc4UfuPpBCq1WIixM2be/BTfO0Yl3gSa0ATTw1QYNqBXm9GZ/pNpy767Lv6+XRM33LKzjhMunp2QFei7DpMNhsUWKU/cnWIBSqrlbCU3wzftzm9TeQCiG+XF+fELttApOHE4x0wYIxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238297; c=relaxed/simple;
	bh=t/TT5S+Hhg6pUnYq7pDCmJ9s77htOUmNYpYWQXgBgtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOBvelQpLwLFopWpwnEPn8amgFTudmJLur0MTbYhveWA4ieJtuTYN00eP7/YgbIggWGns3bg+EnhSiZ//aVFNS6SYzo4R3pxQvmb3eIuKj0naApul5xU4a0ZVkUB9UXVz2Q4GzsXoAOK4G2iiHdHZjOAzYHwDjhjy6UuiG+dMCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+CHTMUe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+CHTMUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A691F000E9;
	Thu, 20 Aug 2026 15:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238296;
	bh=ir7zOGoACXWJ9OINENsgZ53TyvVhkY8DEbhrO+TFVoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V+CHTMUecvCxQF4x6pNwVwMgkKy1y1paRDW6zjn2oPEAwDdx+uiwrzP8rHvb/Dl4M
	 CscTl9EP9XlSkPrX8Vgb8kAgj7223vtrsrw3VnqFrZBDpVrMGjD3YjIOrpEmyxguP8
	 bnDAIleqvw7D50aNs2MR+C0DBTRk0RG5vnemxXGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.1 061/228] selftests/ftrace: Convert ELF entry point to file offset in uprobe test
Date: Thu, 20 Aug 2026 16:53:23 +0200
Message-ID: <20260820145246.323812526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

commit 24aa630f6259e6a2107936c06fed72063f712b64 upstream.

The add_remove_uprobe test uses readelf -h to obtain the ELF entry
point (e_entry) and passes it directly as the offset to uprobe_events.
However, uprobe_events expects a file offset, not a virtual address.

For PIE binaries, the virtual address happens to equal the file offset
because the first LOAD segment has p_vaddr == p_offset, so the test
works by coincidence. But for non-PIE executables, e_entry is an
absolute virtual address that can far exceed the file size. When the
probe is enabled, uprobe_register() checks offset > i_size_read(inode)
and rejects it with -EINVAL.

Fix this by converting the virtual address to a file offset using the
ELF program headers: scan readelf -lW output for the LOAD segment
containing the entry point, then compute file_offset = e_entry -
p_vaddr + p_offset. For PIE binaries the result is unchanged; for
non-PIE binaries the offset is correctly translated.

The conversion uses only POSIX shell primitives, with no dependency on
gawk or perl.

Link: https://lore.kernel.org/all/20260807081512.2974757-3-qirui.001@bytedance.com/

Fixes: dc4b165855f2 ("selftests/ftrace: Use readelf to find entry point in uprobe test")
Cc: stable@vger.kernel.org
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe.tc |   27 +++++++++-
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/add_remove_uprobe.tc
@@ -12,9 +12,32 @@ echo 0 > events/enable
 echo > dynamic_events
 
 REALBIN=`readlink -f /bin/sh`
-ENTRYPOINT=`readelf -h ${REALBIN} | grep Entry | sed -e 's/[^0]*//'`
 
-echo "p:myevent ${REALBIN}:${ENTRYPOINT}" >> uprobe_events
+# Get the entry point virtual address from ELF header
+ENTRY=`readelf -hW ${REALBIN} | grep "Entry point" | awk '{print $NF}'`
+
+# Convert virtual address to file offset: find the LOAD segment containing
+# the entry point, then compute file_offset = e_entry - p_vaddr + p_offset.
+# For PIE binaries this is a no-op (vaddr == file offset), but for non-PIE
+# executables the virtual address is much larger than the file size and
+# must be converted, otherwise uprobe_register() rejects it with -EINVAL.
+ENTRY_DEC=$(printf '%d' "$ENTRY")
+OFFSET=$ENTRY
+while IFS= read -r line; do
+    set -- $line
+    [ "$1" = "LOAD" ] || continue
+    VA_DEC=$(printf '%d' "$3")
+    OFF_DEC=$(printf '%d' "$2")
+    FSZ_DEC=$(printf '%d' "$5")
+    if [ "$ENTRY_DEC" -ge "$VA_DEC" ] && [ "$ENTRY_DEC" -lt "$((VA_DEC + FSZ_DEC))" ]; then
+        OFFSET=$(printf '0x%x' "$((ENTRY_DEC - VA_DEC + OFF_DEC))")
+        break
+    fi
+done << EOF
+$(readelf -lW ${REALBIN} | grep LOAD)
+EOF
+
+echo "p:myevent ${REALBIN}:${OFFSET}" >> uprobe_events
 
 grep -q myevent uprobe_events
 test -d events/uprobes/myevent


