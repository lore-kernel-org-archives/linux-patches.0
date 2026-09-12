Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E95303A35;
	Sat, 12 Sep 2026 16:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231470; cv=none; b=kvRPpkLJPaLSYgaxy3M38IYDvzv0J1dXxRfQ8GeJb9sZJp2uXkQmzDdiSPJikPbjb0ctyvpZ+gd670JEz0NloICaMfumnOzbLxr+rEv6BucriAXaUo41q0BU1bcEjh5seRDuHW3w4/FY0awHuonmh8jc7kY3qZ34TDWNQ/YhPNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231470; c=relaxed/simple;
	bh=/H5ZK20nsav/DZ4ILtg3aBZpC+lLeMtGYKHfu9yWeow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR943WnszqbsMdTz961LGl8P75qB+1Gifc0MgS2oIYMN/dZjoHKkEgkZ+U+fzcXGazCjzLo/fVywvJfbZ3a22skU8xJGNKlre5u2ZB6nayIYqO/Tfu9akP+S1Kos05PL2wQJNHzF190XGstxN5y4IkVSNXqUpfZcJzOPKQx9mC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0SXj6SD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0SXj6SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089C71F000FF;
	Sat, 12 Sep 2026 16:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231469;
	bh=6GtFFc2CFNGaw/HW/WrGhsmnBNZJkL2z9iJ+7gWOtHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0SXj6SDm1WEzcqgzkEBpeU74ilzb3/fDN5lgfvAJPUf/3KFZge4XrKDUy0NsGt94
	 kOAqc4MPjQpRyFZZH2CM/sUubhLlB2ixJPEjN7op2rMi1n+87Sdb31eFK38XY0A3uz
	 l4oWi/oucb0vivSSPShwIIL+dStKo67pJ++joI3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1004/1191] bpftool: Fix double close in map dump
Date: Sat, 12 Sep 2026 09:02:12 +0200
Message-ID: <20260912065610.746077891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit 259d60f5bfa41056fe01cbf2ba3f6f0331865a16 ]

map_dump() closes the map fd in its error path, and do_dump() then
closes the same fd again after a successful dump. Closing an already
closed fd leaves errno set to EBADF, which poisons later errno checks
such as the batch file read check in do_batch(). Let do_dump() own the
fd and remove the close from map_dump().

The same double-close pattern exists in do_show_subset(): both
show_map_close_json() and show_map_close_plain() already close the fd,
so drop the extra close() there as well.

Also propagate the error when bpf_map_get_info_by_fd() fails on a
subsequent map in do_dump(): set err = -1 before breaking out of the
loop, so a later failure is not silently hidden after an earlier
iteration succeeded.

Fixes: 99f9863a0c45f ("bpftool: Match maps by name")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260810142224.2907373-2-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/map.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 995675ef4dadf..a77bf45d6f834 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -653,8 +653,6 @@ static int do_show_subset(int argc, char **argv)
 			show_map_close_json(fds[i], &info);
 		else
 			show_map_close_plain(fds[i], &info);
-
-		close(fds[i]);
 	}
 	if (json_output && nb_fds > 1)
 		jsonw_end_array(json_wtr);	/* root array */
@@ -891,7 +889,6 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 exit_free:
 	free(key);
 	free(value);
-	close(fd);
 	free_map_kv_btf(btf);
 
 	return err;
@@ -940,6 +937,7 @@ static int do_dump(int argc, char **argv)
 	for (i = 0; i < nb_fds; i++) {
 		if (bpf_obj_get_info_by_fd(fds[i], &info, &len)) {
 			p_err("can't get map info: %s", strerror(errno));
+			err = -1;
 			break;
 		}
 		err = map_dump(fds[i], &info, wtr, nb_fds > 1);
-- 
2.53.0



