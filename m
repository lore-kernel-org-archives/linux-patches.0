Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807D33F9267;
	Wed, 20 May 2026 18:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300911; cv=none; b=iPWNIGmv+AYOKAFmgQnqHPGpF0ITv4rGlTjSQF6erpbqWZxFNVNxsqjfSItUYTdK6rvXKMd4P0QCPSBXEVOrTgiVGbznMEOTz/ikfTL3CmTP6cOlL0rhj4NVXH2nHB22up15rvaiiIlXELyOqqq3IHuKZo/6UKmoP4TgaPFVYX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300911; c=relaxed/simple;
	bh=1k0PBA+K0NYywj1G06v1ZsjRD7U4Vr/KPunjAItl1Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWShXeuFCG0Zf2viy2DeMiKn6DYSZPnh7vGnRHe9ywaRGImV9SWREYllLq8au+p0afNj79T6L1zor4stH8S21jbaOWvXXlTRhUmyvuyS/5PY+8fEZefcISGqSWuca64j/++nyVF2xC+4eCKkCR/j03aBUzPnZPl+ZJCplLrs0Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4lE8Sv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4lE8Sv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C591F00893;
	Wed, 20 May 2026 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300909;
	bh=wi1aXxGAiufbmSatmMpHv9jlcOz3iXGvisYS68x6ER0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4lE8Sv46ALogPBra9tMqYrqtUReYuLGO1ddLrngeZPG4y9yiSasGBbB64mTQzvTl
	 U6Q3ea5GRX1W4BNCWU2q8IByxbgMqBYZMtfCVXib1hONuo0luGx2ZOBtNFqhycb4rq
	 U7lvEvxGc4MgwtxshJA274Fg+rTiLHoiMUCvD4p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/666] libbpf: Prevent double close and leak of btf objects
Date: Wed, 20 May 2026 18:19:26 +0200
Message-ID: <20260520162118.928024715@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 380044c40b1636a72fd8f188b5806be6ae564279 ]

Sashiko found possible double close of btf object fd [1],
which happens when strdup in load_module_btfs fails at which
point the obj->btf_module_cnt is already incremented.

The error path close btf fd and so does later cleanup code in
bpf_object_post_load_cleanup function.

Also libbpf_ensure_mem failure leaves btf object not assigned
and it's leaked.

Replacing the err_out label with break to make the error path
less confusing as suggested by Alan.

Incrementing obj->btf_module_cnt only if there's no failure
and releasing btf object in error path.

Fixes: 91abb4a6d79d ("libbpf: Support attachment of BPF tracing programs to kernel modules")
[1] https://sashiko.dev/#/patchset/20260324081846.2334094-1-jolsa%40kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260416100034.1610852-1-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9c94d56e79764..c7b7a15b9901c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5664,11 +5664,12 @@ static int load_module_btfs(struct bpf_object *obj)
 		info.name = ptr_to_u64(name);
 		info.name_len = sizeof(name);
 
+		btf = NULL;
 		err = bpf_btf_get_info_by_fd(fd, &info, &len);
 		if (err) {
 			err = -errno;
 			pr_warn("failed to get BTF object #%d info: %s\n", id, errstr(err));
-			goto err_out;
+			break;
 		}
 
 		/* ignore non-module BTFs */
@@ -5682,15 +5683,15 @@ static int load_module_btfs(struct bpf_object *obj)
 		if (err) {
 			pr_warn("failed to load module [%s]'s BTF object #%d: %s\n",
 				name, id, errstr(err));
-			goto err_out;
+			break;
 		}
 
 		err = libbpf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
 					sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
 		if (err)
-			goto err_out;
+			break;
 
-		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
+		mod_btf = &obj->btf_modules[obj->btf_module_cnt];
 
 		mod_btf->btf = btf;
 		mod_btf->id = id;
@@ -5698,16 +5699,16 @@ static int load_module_btfs(struct bpf_object *obj)
 		mod_btf->name = strdup(name);
 		if (!mod_btf->name) {
 			err = -ENOMEM;
-			goto err_out;
+			break;
 		}
-		continue;
+		obj->btf_module_cnt++;
+	}
 
-err_out:
+	if (err) {
+		btf__free(btf);
 		close(fd);
-		return err;
 	}
-
-	return 0;
+	return err;
 }
 
 static struct bpf_core_cand_list *
-- 
2.53.0



