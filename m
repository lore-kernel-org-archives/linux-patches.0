Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5CA3803C3;
	Thu, 20 Aug 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238817; cv=none; b=l7+W3HY6m1uq9Af6S5pI1AHV7AVVgQzUItPT2TbqqkwVrb1EIvh5FiLvyeMVTKClpnrkx0ijktM85iV7A7GZves20fQyAmV1lQyWgQTwvli9AbOZ1S4LhkTENlyg9nQ+WHl7WZ+81Y3REPzeqH4iuSDbWF/d2chNtgdZnIyrszA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238817; c=relaxed/simple;
	bh=J46ruC53ip81NlM8x4Z3knZ9R89q9xicfcEYVOD027c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gaa+XsTBQRawc1u0mn5ecEFAB8TaeJEDqLhVQkCUuEeejL2DdZvtekvwP+G+fRBNdNlN1eMGlkHsfhdObclIiTfAdz0ElbdS/BCC6dIcbI3TdCMkrvipXxk8D6bst2kmj4hxYoRaUwtoXYw2VJys0FA0ck/xGaEMnSmPH80bQAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7n9ydvJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7n9ydvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFBD1F000E9;
	Thu, 20 Aug 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238816;
	bh=2V/VpxO5y+fZbYz0NZVlIbJ8SswX9tWcAkerQx09Nxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7n9ydvJK78Xc2C7YXLbguhE6oN/Zk55tNRkxSfB7w9k6EnbPaXBg+19Mx3BHV3JD
	 vv2DCmGsQvcsr66Nnqr2zXMJX/pHhpD1MWvZ37fMC1tmwbpmcJ+VDrD8OIIwUBmc7v
	 ip/Cm/piHjaA0khbb3hAzfdyCwDwMVL0d0GPCx7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 052/217] selftests/ftrace: Convert ELF entry point to file offset in uprobe test
Date: Thu, 20 Aug 2026 16:53:40 +0200
Message-ID: <20260820145239.184686296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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


