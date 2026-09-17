Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8164F402C;
	Thu, 17 Sep 2026 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668632; cv=none; b=MdatPjsOwpUEgNXTuJk3gpNkjh2sSFtgYmFIjhzdqVgBWgEe3FDD8nFtC5dnixIsI0iGLDZRPdLmTlaANFzwKEZkIMob2+cGmsby1bhNdygJrayucZ2wZTJS50J6gFpq5wUmiTCXcd29Zi9yoUcPhI01xBwBhPCw1fJb1iZx74U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668632; c=relaxed/simple;
	bh=Vs34+mGejYd8usYPV/M8vFJK0d8udEuIiTuF5/PzxBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooY7R/W/o68Wog/5YbiX5gMncX1PERfiGPmIGaAhFsnwrudRV93JigqVCaPzDOE4oQr2IxEN4s5IVnyP32qKyMucuJL3x6uoI67iwzIPccDuayPakcmMvbWE3n7lV22aeXaja6Hm56QPW/DKm7NnNEHa0e/vxBy1SAmfraCdKaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUWFZ+cJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUWFZ+cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D471F000FF;
	Thu, 17 Sep 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668630;
	bh=hsKiQli9Oq+APo88VnxV4fbLrZTXALJpj4F7TUCjQbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUWFZ+cJFCKwi1N/FQ/SggFE7kB6os0Kvi3uxrd6zpqzGFvnsUn/iK33ZGPzpcplY
	 hz95ujQtlzSu1krkEs8Fh9zoVjUr+nQdLhI9+YsPXNUZb+vicd9ly9QvCCspbFU8Pb
	 YRwTrVGiIcNPeyk5fjFazL7SZ7d8zEBLkvsKl68c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0489/1102] bpf: Guard __get_user acesss with access_ok for uprobe_multi data
Date: Thu, 17 Sep 2026 16:07:12 +0100
Message-ID: <20260917151551.985446921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 4d87a251d45b4a95eb4c0abcfab809c9f231258a ]

As reported by sashiko [1] we need to use access_ok to check the user
space data bounds before we use __get-user to get it.

[1] https://lore.kernel.org/bpf/20260610145235.CB1441F00893@smtp.kernel.org/
Fixes: 0b779b61f651 ("bpf: Add cookies support for uprobe_multi link")
Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20260611114230.950379-2-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e3038cc26f675..bac2db75dcd1d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3308,6 +3308,7 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	unsigned long __user *uoffsets;
 	u64 __user *ucookies;
 	void __user *upath;
+	unsigned long size;
 	u32 flags, cnt, i;
 	struct path path;
 	char *name;
@@ -3342,6 +3343,16 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	uref_ctr_offsets = u64_to_user_ptr(attr->link_create.uprobe_multi.ref_ctr_offsets);
 	ucookies = u64_to_user_ptr(attr->link_create.uprobe_multi.cookies);
 
+	/*
+	 * All uoffsets/uref_ctr_offsets/ucookies arrays have the same value
+	 * size, we need to check their address range is safe for __get_user
+	 * calls.
+	 */
+	size = sizeof(*uoffsets) * cnt;
+	if (!access_ok(uoffsets, size) || !access_ok(uref_ctr_offsets, size) ||
+	    !access_ok(ucookies, size))
+		return -EFAULT;
+
 	name = strndup_user(upath, PATH_MAX);
 	if (IS_ERR(name)) {
 		err = PTR_ERR(name);
-- 
2.53.0



