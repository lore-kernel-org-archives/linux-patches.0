Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FEE411691;
	Tue, 21 Jul 2026 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660656; cv=none; b=nL08pn8mQvf4okyd+C6/6LhwttFOQnkGxopVYmJeNi/i4dE6ReDfN7BXZJ0rgbj755h5ZE+/0hSnkt3wL5zD2k4Kv7aMTTz3ssjLmu2uN4eHp5rpEo/aiVKcAUNI7ukPaf7E7oaFmpPwA3AWa2paGCXE1c1HGLy0/C2avkstKJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660656; c=relaxed/simple;
	bh=gE2C1fAmJv3fn990tcD3Vo/J7ORjnqg29KmXt5717Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKFm9Vf9SZKVsQOmtqim0itOXm6cleh3acT4IYSPP2kOjv/XVlbwcmHNkdq0FqYcCQtkZmg9ZDqk4kacbgDSJz2C88u/exgMVAcIWnVy9PH0JCPMeoddljfECVzMsjKIkgt4ke3fP6sANFgHd4Mgrenr4mIZRVH8y3mEhrgGkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k904EbkP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k904EbkP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055791F000E9;
	Tue, 21 Jul 2026 19:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660655;
	bh=2kIY9JoYTz9jnFObSdgxoKkwkUsG+Nj9gxtBLYxnYF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k904EbkPDPNDpC8OTmQDYfewQGFWnNParSpDAaviecoKoHw0YtXGLvsMzwRM6Kn0s
	 bZwAJknTU0KoHeGLrKf1HiXWkob0jWRTE8dpfStJHBHc8AvpNC4mKhMd4AxaH1YzPj
	 ZWiyDoGRNaf53N74M1jlOGtVBYQUtOpMO5F8WAQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1018/2077] perf tools: Use snprintf() in dso__read_running_kernel_build_id()
Date: Tue, 21 Jul 2026 17:11:31 +0200
Message-ID: <20260721152616.833087760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2ea64782a428bed74f595961e651ceb8c4c5bf22 ]

dso__read_running_kernel_build_id() uses sprintf() to format a sysfs
path from machine->root_dir into a PATH_MAX buffer.  If root_dir is
close to PATH_MAX in length, appending "/sys/kernel/notes" (18 bytes)
overflows the stack buffer.

Switch to snprintf() with sizeof(path) to prevent the overflow.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: cdd059d731eeb466 ("perf tools: Move dso_* related functions into dso object")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 99199c68d9b5cb..7200722464e719 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1772,7 +1772,7 @@ void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 
 	if (machine__is_default_guest(machine))
 		return;
-	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
+	snprintf(path, sizeof(path), "%s/sys/kernel/notes", machine->root_dir);
 	sysfs__read_build_id(path, &bid);
 	dso__set_build_id(dso, &bid);
 }
-- 
2.53.0



