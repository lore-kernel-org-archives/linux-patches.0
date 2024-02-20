Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D384612D7;
	Tue, 20 Feb 2024 21:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463878; cv=none; b=pw3/IeArZARrA30NFPpn5fQ0io8FTNS7TGf2NHc7dA90FC16RDcQ15ndWvbqwKLhfCXayTOwUhusXXqojTVNEn10Xb28DMPifIW54urtwe3lVgwmRTkKBtDq4zZNvH/3BRkVEYLmI8Y4X4+WHTjHiSo4jsYXWzdFvH45FJQxH3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463878; c=relaxed/simple;
	bh=HigfHR0jQassX0HDtula1rqqSmQ3DBUAMUnnGjTLwJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvNw/M5n+ZxxRtRREB5jJqw/KtOjwCA9tStv5+n+hNxPuxl+K/TZ/JgOgUxPokN+YoXbvA6YFxW/Rk5S5Sy6Kjl6vIQILniG1ocEXJ839WGP1ATkaOVqCv273kxpa45787m453P0khNYgTNxTh1TN4BF/YfdZgRKg8lM3/Aj0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRSPLjfn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRSPLjfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA07FC433C7;
	Tue, 20 Feb 2024 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463878;
	bh=HigfHR0jQassX0HDtula1rqqSmQ3DBUAMUnnGjTLwJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRSPLjfn45iwwaZQL/upT9oF+aiLTDKEhKY+sb4yFJNKLX3WUh8JGYyjxBuqAxOHM
	 5KtrDFpFCp5QwxDPYUxTisPV7kIn3U2AKEoAwfwMG7iEmphJXJbHeAsYdH0n+ddgrL
	 RiC/QTDAwuo1XUDBpUDIDhpHjHYk6B+Ipt7U7vLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 153/331] tracing/probes: Fix to search structure fields correctly
Date: Tue, 20 Feb 2024 21:54:29 +0100
Message-ID: <20240220205642.343875764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 9704669c386f9bbfef2e002e7e690c56b7dcf5de upstream.

Fix to search a field from the structure which has anonymous union
correctly.
Since the reference `type` pointer was updated in the loop, the search
loop suddenly aborted where it hits an anonymous union. Thus it can not
find the field after the anonymous union. This avoids updating the
cursor `type` pointer in the loop.

Link: https://lore.kernel.org/all/170791694361.389532.10047514554799419688.stgit@devnote2/

Fixes: 302db0f5b3d8 ("tracing/probes: Add a function to search a member of a struct/union")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_btf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_btf.c b/kernel/trace/trace_btf.c
index ca224d53bfdc..5bbdbcbbde3c 100644
--- a/kernel/trace/trace_btf.c
+++ b/kernel/trace/trace_btf.c
@@ -91,8 +91,8 @@ const struct btf_member *btf_find_struct_member(struct btf *btf,
 	for_each_member(i, type, member) {
 		if (!member->name_off) {
 			/* Anonymous union/struct: push it for later use */
-			type = btf_type_skip_modifiers(btf, member->type, &tid);
-			if (type && top < BTF_ANON_STACK_MAX) {
+			if (btf_type_skip_modifiers(btf, member->type, &tid) &&
+			    top < BTF_ANON_STACK_MAX) {
 				anon_stack[top].tid = tid;
 				anon_stack[top++].offset =
 					cur_offset + member->offset;
-- 
2.43.2



