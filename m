Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB7F370AFB;
	Thu, 17 Sep 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665681; cv=none; b=EvHf9D5ExWk34qrwZwBFHAEHmXIQPmp/s+Cwuohdj+OYFrzltKS51wb9hGl5eGQ652NJoDuLbuOtkx0DZz+PsAPlTadWA4/RTnaBV6Qb5FPQ01S71qV0vP1no6raOY+iOKlg8NHV/NrPuE1mnT3IW+wZELfkg4kz/A8M4tQUadg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665681; c=relaxed/simple;
	bh=sq8JFq0oZPaqeG2TKj4IcITXv0u82oYBcejnvpGFB7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFSf+Q98lBZOJVMPWqRFfJWLTu0efu6wrQRH601nN7/Zmh7Dpp2Qelajly1IE2Zb3eXVzCHVm3xvt/S+NVvRmhmrUcMDE1BPaIp5uBOm8ihcALGg6S5T148ytgzvMK7yLcXug+fmXmmxZh4dZ9B73nB/SFgimxzOoA4lg53ZB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDbNIDkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDbNIDkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF741F000FF;
	Thu, 17 Sep 2026 17:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665680;
	bh=k5jCQyjgs+tTMxBKb9M+RIVoDlZT/oePk1lQ8V9XapU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDbNIDkMVhts+afLLqwwE02I7tvKDXfhr06kUd7jogMHokLOjkrX0hnpHZFpJq9Hu
	 OsdgXF2gKlexOd+qNH8NCDhVqYjt6kOkylEVy221JndvLl+FFLYGIae2WC6SUNH38V
	 fsI2KFJc0tfirAvPuLQzWPejRtPMXzxyr9CaIIz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0786/1250] tracing: Fix to avoid creating trace instances with duplicate names
Date: Thu, 17 Sep 2026 16:09:41 +0100
Message-ID: <20260917151613.198665245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit d7dbdd2ee01e12211046d4a535623ac732b749fb ]

Since commit e645535a954a ("tracing: Add option to use memmapped
memory for trace boot instance") changed trace_array_get_by_name() to
trace_array_create_systems(), enable_instances() does not reuse the
same name instance. Therefore, if an administrator mistakenly specifies
multiple `trace_instance=` options with duplicate names, all are
created but only the first is accessible via tracefs.

Check whether an instance with the same name already exists before
creating a new one, and reject duplicates with a warning.

Link: https://patch.msgid.link/178847790399.283263.5313150997200138426.stgit@devnote2
Fixes: e645535a954a ("tracing: Add option to use memmapped memory for trace boot instance")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7c0ca37842508..7f25ae6330942 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -11194,6 +11194,11 @@ __init static void enable_instances(void)
 		if (flag_delim)
 			*flag_delim++ = '\0';
 
+		if (trace_array_find(name)) {
+			pr_warn("Tracing: Instance %s already exists\n", name);
+			continue;
+		}
+
 		if (backup) {
 			if (backup_instance_area(backup, &addr, &size) < 0)
 				continue;
-- 
2.53.0



