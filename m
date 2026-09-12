Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A4947A87A;
	Sat, 12 Sep 2026 12:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215873; cv=none; b=ktRCmZRgPgcchc1HwXQ1ryh2xE58fizYoLjsojuZ8WLt3TBHwa4To7AeWMPkYmElYyUaOVLZqIrptIxE1On/5ZzZbJcOOO/aPD5id4KPvBEDQtnVuwxF0O2Zj9nCbzmZ91l7SqyqbL3PcA/X1NPmy57fr8BsKJiPjFGD8G2P/so=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215873; c=relaxed/simple;
	bh=YJznvmNYeuSFJDdscKxCMQvJvNPCIJPeS3oV1Q/SgPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qj97aieaCD/66ZEZO9z4sUkoJbYARYWJC9MNUEm392ebH+yNiMeXZ7HOmvQozWc67jEhhMblbAmkSX0n2xbHL/8RRg9BzZqSSxHanRN/C/FkPYM28YhTyfaRrY5KDCTPMUCjqkB4IHQA4odqh2elFacHpOIOJ3W1tJqaBW61vLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYgnwK4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYgnwK4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03A71F00898;
	Sat, 12 Sep 2026 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215867;
	bh=i+ywreugqMo/5OBoKXz2dVH7luuKXOkBgzzK7wo2G48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYgnwK4Xo30Nn2+Qm7J1s+Dpop3d1P7q32fpJJ/oKZEmeS1an9GETRvA0puAu6oa3
	 YvessaAa2UO0l1gL0jyhiCKf96I7shj3sZhDQGPexi6HtMxampaq8GraaSzAFhqC68
	 b8v/Aq8sVOYX9axdkWNjemJWTlpfKxZFKgaXhls0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re?=" <rbm@suse.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0621/1376] libbpf: Search /lib64 and /lib in resolve_full_path()
Date: Sat, 12 Sep 2026 08:50:47 +0200
Message-ID: <20260912065621.384619671@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marlière <rbm@suse.com>

[ Upstream commit 7b5ae0481efdac040cea72b4fabd1398109f975b ]

attach_probe/uprobe-lib and uprobe_autoattach selftests fail with "failed
to resolve full path for libc.so.6" on older non-usrmerged distros, where
libc.so.6 lives under a top-level /lib64 or /lib rather than /usr/lib64 or
/usr/lib. Add /lib64:/lib to the search paths, alongside the existing
/usr/lib64:/usr/lib and Debian multiarch entries.

Fixes: 1ce3a60e3c28 ("libbpf: auto-resolve programs/libraries when necessary for uprobes")
Signed-off-by: Ricardo B. Marlière <rbm@suse.com>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/bpf/20260720-selftests-bpf_fixes-v2-3-b450eda93dfe@suse.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9bbf7a3b87de7..ffb0d1f7e9a08 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -11946,13 +11946,14 @@ static const char *arch_specific_lib_paths(void)
 /* Get full path to program/shared library. */
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
-	const char *search_paths[3] = {};
+	const char *search_paths[4] = {};
 	int i, perm;
 
 	if (str_has_sfx(file, ".so") || strstr(file, ".so.")) {
 		search_paths[0] = getenv("LD_LIBRARY_PATH");
 		search_paths[1] = "/usr/lib64:/usr/lib";
 		search_paths[2] = arch_specific_lib_paths();
+		search_paths[3] = "/lib64:/lib";
 		perm = R_OK;
 	} else {
 		search_paths[0] = getenv("PATH");
-- 
2.53.0



