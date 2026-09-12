Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8174932779D;
	Sat, 12 Sep 2026 12:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214934; cv=none; b=tFHuCYCAoTnxgX6wGFGs5aGaueCDke5vyC2Bsy6M+D+IoHmTAGaQK1CPW+yicBBmaKuiMTmVay0kx4BwdMVc56XJxll7XLHUIurwJ3Fu7No3PqKGHg6xj7nvvQhu+wHXUi7dHiQV+6cJamsedeaWXGBlShHdsne5Jb9zBgUc+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214934; c=relaxed/simple;
	bh=EcGSxvWm8GIVhBjoPsZa/+uCqy7iUcDiQr5eMCtBcbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzVAhqI0GSILaO5RalZPGthkO6GV3VdBWrpCZxDuP/3q7EEYDYBO9PW3wok+K8rdRRxsnvdd80LMQLS9rRPOklASUAegHoyi25vC4Hp9hsFeFi/boU3v+ZEGl1YZ2Im8vMk5/o/53ydXMfa+6nhJu8Kdvh2xjW2KNRU+P2PYIUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6la/sKU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6la/sKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A01F000FF;
	Sat, 12 Sep 2026 12:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214933;
	bh=z77DAedu6UCgLHMUWsrmHABo9x1CgGIACBJ9WpVHvhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6la/sKUk1jMUJzu3qRSPG5OE8UGICHoQUmZgikU/uhsgaFTSQf8HrSX+BX8sPZca
	 O+BIrb8OMPaY+ms+E11CJE612+SmQ/X1Tdj9SbxJSBHVKZB2Mw8LFYebUzHJ0hg+OC
	 cQ5k+KTT1N9XP7KvAcDLwIszaM5jV6uPHVrdZ3q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0375/1376] tools/bpf/bpftool: Reset vmlinux BTF after map commands
Date: Sat, 12 Sep 2026 08:46:41 +0200
Message-ID: <20260912065615.905240326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 66d7e39e49b0dd57610c9b63afc65b4d5690983b ]

get_map_kv_btf() caches the vmlinux BTF object when a map uses
btf_vmlinux_value_type_id. map dump released that object when the
command completed, but left the global pointer stale.

The same cached object can also be returned to print_key_value(), which
freed it directly. That leaves btf_vmlinux dangling before the command
cleanup path runs.

Use free_map_kv_btf() for per-entry cleanup, and reset the cached
btf_vmlinux pointer when the map command releases the object. This keeps
batch mode from reusing a freed BTF object.

Fixes: 4e1ea33292ff ("bpftool: Support dumping a map with btf_vmlinux_value_type_id")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/9072F43B3F74DF91+20260624025055.1574875-2-chenyichong@uniontech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index b89bd792c1d51..332e040677154 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -787,6 +787,12 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static struct btf *btf_vmlinux;
 
+static void free_btf_vmlinux(void)
+{
+	btf__free(btf_vmlinux);
+	btf_vmlinux = NULL;
+}
+
 static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 {
 	int err = 0;
@@ -955,7 +961,7 @@ static int do_dump(int argc, char **argv)
 		close(fds[i]);
 exit_free:
 	free(fds);
-	btf__free(btf_vmlinux);
+	free_btf_vmlinux();
 	return err;
 }
 
@@ -1046,7 +1052,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 		btf_wtr = get_btf_writer();
 		if (!btf_wtr) {
 			p_info("failed to create json writer for btf. falling back to plain output");
-			btf__free(btf);
+			free_map_kv_btf(btf);
 			btf = NULL;
 			print_entry_plain(info, key, value);
 		} else {
@@ -1062,7 +1068,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	} else {
 		print_entry_plain(info, key, value);
 	}
-	btf__free(btf);
+	free_map_kv_btf(btf);
 }
 
 static int do_lookup(int argc, char **argv)
-- 
2.53.0



